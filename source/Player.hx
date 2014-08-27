package;

import openfl.Assets;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;

/**
 * ...
 * @author David Bell
 */
class Player extends FlxSprite 
{
	public static inline var RUN_SPEED:Int = 90;
	public static inline var GRAVITY:Int = 620;
	public static inline var JUMP_SPEED:Int = 200;
	public static inline var JUMPS_ALLOWED:Int = 1;
	public static inline var BULLET_SPEED:Int = 200;
	public static inline var GUN_DELAY:Float = 0.4;
	
	
	private var _gibs:FlxEmitter;
	private var _parent:PlayState;
	private var _bullets:FlxGroup;
	private var _blt:Bullet;
	private var _cooldown:Float;
	
	private var _jumpTime:Float = -1;
	private var _timesJumped:Int = 0;
	private var _jumpKeys:Array<String>;
	
	private var _xgridleft:Int = 0;
	private var _xgridright:Int = 0;
	private var _ygrid:Int = 0;
	
	public var climbing:Bool = false;
	private var _onLadder:Bool = false;
	private var jumped:Bool = false;
	
	
	public function new(X:Int, Y:Int, Parent:PlayState, Gibs:FlxEmitter, Bullets:FlxGroup) 
	{
		// X,Y: Starting coordinates
		super(X, Y);
		
		_bullets = Bullets;
		
		//Set up the graphics
		loadGraphic("assets/art/lizardhead3.png", true, 16, 20);
		
		animation.add("walking", [0, 1, 2, 3], 12, true);
		animation.add("idle", [3]);
		animation.add("jump", [2]);
		
		drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
		maxVelocity.set(RUN_SPEED, JUMP_SPEED);
		acceleration.y = GRAVITY;
		setSize(12, 16);
		offset.set(3, 4);
		
		
		// Initialize the cooldown so that helmutguy can shoot right away.
		_cooldown = GUN_DELAY; 
		_gibs = Gibs;
		// This is so we can look at properties of the playstate's tilemaps
		_parent = Parent;  
		
	}
	public override function update():Void
	{
		// Reset to 0 when no button is pushed
		acceleration.x = 0; 
			var _up:Bool = false;
			var _down:Bool = false;
			var _left:Bool = false;
			var _right:Bool = false;

		_up = 		PlayState.virtualPad2.buttonUp.status == FlxButton.PRESSED;
		_down = 	PlayState.virtualPad2.buttonDown.status == FlxButton.PRESSED;
		_left  = 	PlayState.virtualPad2.buttonLeft.status == FlxButton.PRESSED;
		_right = 	PlayState.virtualPad2.buttonRight.status == FlxButton.PRESSED;



		if (climbing) 
		{
			// Stop falling if you're climbing a ladder
			acceleration.y = 0;  
		}
		else 
		{
			acceleration.y = GRAVITY;
		}
		
		if (PlayState.virtualPad2.buttonLeft.status == FlxButton.PRESSED)
		{
			flipX = true;
			acceleration.x = -drag.x;
		}
		else if (PlayState.virtualPad2.buttonRight.status == FlxButton.PRESSED)
		{
			flipX = false;
			acceleration.x = drag.x;				
		}
		
		jump();
		
		// Can only climb when not jumping
		//if (_jumpTime < 0)
		//{
			climb();
		//}
				
		// Shooting
		if (PlayState.virtualPad2.buttonB.status == FlxButton.PRESSED)
		{
			//Let's put the shooting code in its own function to keep things organized
			shoot();  
		}
	

		// Animations
		if (velocity.x > 0 || velocity.x < 0) 
		{ 
			animation.play("walking"); 
		}
		else if (velocity.x == 0) 
		{ 
			animation.play("idle"); 
		}
		if (velocity.y < 0) 
		{ 
			animation.play("jump"); 
		}
		
		_cooldown += FlxG.elapsed;
		
		// Don't let helmuguy walk off the edge of the map
		if (x <= 0)
		{
			x = 0;
		}
		if ((x + width) > _parent.map.width)
		{
			x = _parent.map.width - width;
		}
		
		// Convert pixel positions to grid positions. Std.int and floor are functionally the same, 
		_xgridleft = Std.int((x + 3) / 16);   
		_xgridright = Std.int((x + width - 3) / 16);
		// but I hear int is faster so let's go with that.
		_ygrid = Std.int((y + height - 1) / 16);   
		
		if (_parent.ladders.getTile(_xgridleft, _ygrid) > 0 && _parent.ladders.getTile(_xgridright, _ygrid) > 0) 
		{
			_onLadder = true;
			climbing=true; //start climbing when walking on a ladder
			
			//we can jumping up a ladder probably
			_jumpTime = -1;
			_timesJumped = 0;
			
		}
		else 
		{
			_onLadder = false;
			climbing = false;
		}
		
		if (isTouching(FlxObject.FLOOR) && PlayState.virtualPad2.buttonA.status == FlxButton.NORMAL)
		{
			_jumpTime = -1;
			// Reset the double jump flag
			_timesJumped = 0;  
		}
		
		super.update();
	}
	
	private function climb():Void
	{
		if (FlxG.keys.anyPressed(["UP", "W"]) || PlayState.virtualPad2.buttonUp.status == FlxButton.PRESSED)
		{
			if (_onLadder) 
			{
				climbing = true;
				_timesJumped = 0;
			}
			
			if (climbing && ((_parent.ladders.getTile(_xgridleft, _ygrid - 1)) > 0 || (_parent.ladders.getTile(_xgridleft, _ygrid )) > 0)) 
			{
				velocity.y = - RUN_SPEED;
			}
		}
		else if (FlxG.keys.anyPressed(["DOWN", "S"]) || PlayState.virtualPad2.buttonDown.status == FlxButton.PRESSED)
		{
			if (_onLadder) 
			{
				climbing = true;
				_timesJumped = 0;
			}
			
			if (climbing) 
			{
				velocity.y = RUN_SPEED;
			}
		}
	}
	
	private function jump():Void
	{
		if ( PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED)
		{
			if ((velocity.y == 0) && (_timesJumped < 1)) // Only allow two jumps
			{
				FlxG.sound.play("assets/sounds/jump" + Reg.SoundExtension, 1, false);
				_timesJumped++;
				_jumpTime = 0;
				_onLadder = false;
			}
		}
		
		// You can also use space or any other key you want
		if ((PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED) && _jumpTime >= 0) 
		{
			climbing = false;
			_jumpTime += FlxG.elapsed;
			
			// You can't jump for more than 0.25 seconds
			if (_jumpTime > 0.25)
			{
				_jumpTime = -1;
				jumped=true;
			}
			else if (_jumpTime > 0)
			{
				velocity.y = - 0.6 * maxVelocity.y;
			}
		}
	}
	
	private function shoot():Void 
	{
		// Prepare some variables to pass on to the bullet
		var bulletX:Int = Math.floor(x);
		var bulletY:Int = Math.floor(y + 4);
		var bXVeloc:Int = 0;
		var bYVeloc:Int = 0;
		
		if (_cooldown >= GUN_DELAY)
		{
			_blt = cast(_bullets.recycle(), Bullet);
			
			if (_blt != null)
			{
				if (flipX)
				{
					// nudge it a little to the side so it doesn't emerge from the middle of helmutguy
					bulletX -= Math.floor(_blt.width - 8); 
					bXVeloc = -BULLET_SPEED;
				}
				else
				{
					bulletX += Math.floor(width - 8);
					bXVeloc = BULLET_SPEED;
				}
				
				_blt.shoot(bulletX, bulletY, bXVeloc, bYVeloc);
				FlxG.sound.play("assets/sounds/shoot2" + Reg.SoundExtension, 1, false);
				// reset the shot clock
				_cooldown = 0; 
			}
		}
	}
	
	override public function kill():Void
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		FlxG.cameras.shake(0.005, 0.35);
		FlxG.cameras.flash(0xffDB3624, 0.35);
		
		if (_gibs != null)
		{
			_gibs.at(this);
			_gibs.start(true, 2.80);
		}
		
		FlxG.sound.play("assets/sounds/death" + Reg.SoundExtension, 1, false);
	}
}