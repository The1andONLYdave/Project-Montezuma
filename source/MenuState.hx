package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxStringUtil;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;

/**
 * ...
 * @author David Bell
 */
class MenuState extends FlxState 
{
	// How many menu options there are.
	public static inline var OPTIONS:Int = 3;
	public static inline var TEXT_SPEED:Float = 600;
	
	// Augh, so many text objects. I should make arrays.
	private var _text1:FlxText;
	private var _text2:FlxText;
	private var _text3:FlxText;
	private var _text4:FlxText;
	private var _text5:FlxText;  
	
	private var _pointer:FlxSprite;
	
	// This will indicate what the pointer is pointing at
	private var _option:Int;     
	
	private var moveIt:Bool = false;
	
public static var virtualPad:FlxVirtualPad;
	


	
	override public function create():Void 
	{
		


virtualPad = new FlxVirtualPad(UP_DOWN, A);
add(virtualPad);

	
		FlxG.mouse.visible = false;
		FlxG.state.bgColor = 0xFF101414;
		
		// Each word is its own object so we can position them independantly
		_text1 = new FlxText( -220, FlxG.height / 4, 320, "Montezumas");
		_text1.moves = true;
		_text1.size = 12;
		//rgb 0 162 232
		_text1.color = 0x00A2E8;
		_text1.antialiasing = true;
		_text1.velocity.x = TEXT_SPEED;
		add(_text1);
		
		// Base everything off of text1, so if we change color or size, only have to change one
		_text2 = new FlxText(FlxG.width - 200 , FlxG.height / 2.5, 320, "Tower 8bit");
		_text2.moves = true;
		_text2.size = _text1.size;
		_text2.color = _text1.color;
		_text2.antialiasing = _text1.antialiasing;
		_text2.velocity.x = - TEXT_SPEED;
		add(_text2);
		
		// Set up the menu options
		_text3 = new FlxText(FlxG.width * 2 / 5, FlxG.height * 2 / 3, 150, "Play (click A for select/jump, B for shooting)");
		_text4 = new FlxText(FlxG.width * 2 / 5, FlxG.height * 2 / 3 + 20, 150, "Give us Feedback");
		_text5 = new FlxText(FlxG.width * 2 / 5, FlxG.height * 2 / 3 + 30, 150, "Visit flixel.org");
		_text3.color = _text4.color = _text5.color = 0xAA00A2E8;
		_text3.size = _text4.size = _text5.size = 8;
		_text3.antialiasing = _text4.antialiasing = _text5.antialiasing = true;
		add(_text3);
		add(_text4);
		add(_text5);
		
		_pointer = new FlxSprite();
		_pointer.loadGraphic("assets/art/pointer.png");
		_pointer.x = _text3.x - _pointer.width - 10;
		add(_pointer);
		_option = 0;

		super.create();
		FlxG.sound.playMusic("assets/music/Menubackground.ogg");
	}
	
	override public function update():Void 
	{
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;

		
		// Stop the texts when they reach their designated position
		if (_text1.x > FlxG.width / 5)	
		{
			_text1.velocity.x = 0;
		}
		
		if (_text2.x < FlxG.width / 5) 
		{
			_text2.velocity.x = 0;
		}
		
		// this is the goofus way to do it. An array would be way better
		switch(_option)    
		{
			case 0:
				_pointer.y = _text3.y;
			case 1:
				_pointer.y = _text4.y;
			case 2:
				_pointer.y = _text5.y;
		}
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);	
		_up = _up || MenuState.virtualPad.buttonUp.status == FlxButton.PRESSED;
		_down = _down || MenuState.virtualPad.buttonDown.status == FlxButton.PRESSED;
		_left  = _left || MenuState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		_right = _right || MenuState.virtualPad.buttonA.status == FlxButton.PRESSED;

		
		if ((MenuState.virtualPad.buttonUp.status == FlxButton.PRESSED) && moveIt== false)
		{
			// A goofy format, because % doesn't work on negative numbers
			_option = (_option + OPTIONS - 1) % OPTIONS; 
			FlxG.sound.play("assets/sounds/menu" + Reg.SoundExtension, 1, false);
			moveIt=true;
		}
		if ((MenuState.virtualPad.buttonUp.status == FlxButton.NORMAL)&& (MenuState.virtualPad.buttonDown.status == FlxButton.NORMAL)){
        moveIt = false;
		}
		
		if ((FlxG.keys.justPressed.DOWN || MenuState.virtualPad.buttonDown.status == FlxButton.PRESSED)&& moveIt== false)
		{
			_option = (_option + OPTIONS + 1) % OPTIONS;
			FlxG.sound.play("assets/sounds/menu" + Reg.SoundExtension, 1, false);
			moveIt=true;
		}
		
		if (FlxG.keys.justPressed.RIGHT || MenuState.virtualPad.buttonA.status == FlxButton.PRESSED)
		{
			switch (_option) 
			{
				case 0:
					FlxG.cameras.fade(0xff969867, 1, false, startGame);
					FlxG.sound.play("assets/sounds/coin" + Reg.SoundExtension, 1, false);
					//#if mobile
					//virtualPad = FlxDestroyUtil.destroy(virtualPad);	
					//#end
				case 1:
					FlxG.openURL("http://kulsch-it.de/#contact");
				case 2:
					FlxG.openURL("http://flixel.org");
			}
		}
		
		super.update();
	}
	
	private function startGame():Void
	{
		FlxG.switchState(new PlayState());
	}
}