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
class WinningState extends FlxState 
{
	// How many menu options there are.
	public static inline var OPTIONS:Int = 3;
	public static inline var TEXT_SPEED:Float = 100;
	
	// Augh, so many text objects. I should make arrays.
	private var _text1:FlxText;
	private var _text2:FlxText;
	private var _text3:FlxText;
	private var _text4:FlxText;
	private var _text5:FlxText;
	
		
public static var virtualPad:FlxVirtualPad;
	


	
	override public function create():Void 
	{
		

virtualPad = new FlxVirtualPad(UP_DOWN, A);
add(virtualPad);

	
		FlxG.state.bgColor = 0xFF101414;
		
		// Each word is its own object so we can position them independantly
		_text1 = new FlxText( -220, FlxG.height / 4, 320, "You won!");
		_text1.moves = true;
		_text1.size = 20;
		//rgb 0 162 232
		_text1.color = 0x00A2E8;
		_text1.antialiasing = true;
		_text1.velocity.x = TEXT_SPEED;
		add(_text1);
		
		// Base everything off of text1, so if we change color or size, only have to change one
		_text2 = new FlxText(FlxG.width - 200 , FlxG.height / 2.5, 320, "Level 1 complete");
		_text2.moves = true;
		_text2.size = _text1.size;
		_text2.color = _text1.color;
		_text2.antialiasing = _text1.antialiasing;
		_text2.velocity.x = - TEXT_SPEED;
		add(_text2);
		
		// Set up the menu options
		_text3 = new FlxText(FlxG.width * 2 / 5, FlxG.height * 2 / 3, 150, "Play again with click A");
		_text3.color = 0xAA00A2E8;
		_text3.size  = 8;
		_text3.antialiasing =  true;
		add(_text3);
		
		super.create();
		FlxG.sound.playMusic("assets/music/Menubackground.ogg");
	}
	override public function update():Void 
	{
	
		// Stop the texts when they reach their designated position
		if (_text1.x > FlxG.width / 5)	
		{
			_text1.velocity.x = 0;
		}
		
		if (_text2.x < FlxG.width / 5) 
		{
			_text2.velocity.x = 0;
		}
		
		
		if (WinningState.virtualPad.buttonA.status == FlxButton.PRESSED)
		{
					FlxG.cameras.fade(0xff969867, 1, false, startGame);
					FlxG.sound.play("assets/sounds/coin" + Reg.SoundExtension, 1, false);
					//#if mobile
					//virtualPad = FlxDestroyUtil.destroy(virtualPad);	
					//#end
			
		}

		super.update();
	}
	private function startGame():Void
	{
		FlxG.switchState(new PlayState());
	}
}