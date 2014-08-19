package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author David Bell
 */
class Lurker extends EnemyTemplate 
{
	public static inline var RUN_SPEED:Int = 30;
	public static inline var GRAVITY:Int = 300;
	public static inline var HEALTH:Int = 1;
	public static inline var SPAWNTIME:Float = 45;
	public static inline var JUMP_SPEED:Int = 60;
	
	private var _spawntimer:Float;
	private var _playdeathsound:Bool;
	private var _cooldown:Float;
	
	public function new(X:Float, Y:Float, ThePlayer:Player) 
	{
		super(X, Y, ThePlayer);
		
		_spawntimer = 0;
		_playdeathsound = true;
		_cooldown = 0;
		
		loadGraphic("assets/art/lurkmonsta.png", true, 16, 17);
		
		animation.add("walking", [0, 1], 18, true);
		animation.add("idle", [0]);
		drag.x = RUN_SPEED * 9;
		drag.y = JUMP_SPEED * 7;
		acceleration.y = GRAVITY;
		acceleration.x = RUN_SPEED;
		maxVelocity.x = 300;
		maxVelocity.y = JUMP_SPEED;
		health = HEALTH;
		offset.x = 3;
		width = 10;
	}
	
	override public function update():Void 
	{
		if (touching == FlxObject.DOWN)
		{
			if (health <= 0 && _playdeathsound)
			{
				FlxG.sound.play("assets/sounds/mondead2" + Reg.SoundExtension, 1, false);
				_playdeathsound = false;
			}
		}
		
		// Animation
		if ((velocity.x == 0) && (velocity.y == 0)) 
		{ 
			animation.play("idle"); 
		}
		else 
		{ 
			animation.play("walking"); 
		}
		

		if (velocity.x < 30) 
		{
			velocity.x = 30;
		}
		else 
		{
			velocity.x = -30;
		}
		if (x != _startx)
		{
			velocity.x = -30;
			drag.x;
		}
			
		
		_cooldown += FlxG.elapsed;
		super.update();
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		
		health = HEALTH;
		_spawntimer = 0;
		acceleration.y = GRAVITY;
		maxVelocity.y = JUMP_SPEED;
		_playdeathsound = true;
	}
	
	
	
}
