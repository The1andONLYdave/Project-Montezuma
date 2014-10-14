package;

import flixel.FlxG;
import flixel.FlxSprite;
import openfl.Assets;

/**
 * ...
 * @author David Bell
 */
class CoinGreen extends FlxSprite 
{
	public function new(X:Float = 0, Y:Float = 0) 
	{ //color string add for choosing png path TODO v.1.0.0
		x=x*16;
		y=y*16;
		super(X, Y);
		
		loadGraphic("assets/art/coinspingreen.png", true);
		animation.add("spinning", [0, 1, 2, 3, 4, 5], 10, true);
		animation.play("spinning");
	}
	
	override public function kill():Void 
	{
		super.kill();
		
		if(Reg.sound==true){FlxG.sound.play("assets/sounds/coin" + Reg.SoundExtension, 3, false);}
		//Reg.score++;
	}
}