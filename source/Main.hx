package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;

class Main extends Sprite 
{ //20x12 tiles = 320x192 pixel
	var gameWidth:Int = 320; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 192; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	//var zoom:Float = 1; // Testing for better scaling on different scrren sizes on android (nex4:1280x768(720 with softwarekeys on)(1,667) huawei-y300/s3mini:800x480(1,667))
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	// You can pretty much ignore everything from here on - your code should go in your states.
	
	public static function main():Void
	{	
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		if (stage != null) 
		{
			init();
		}
		else 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(?E:Event):Void 
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		setupGame();
	}
	
	private function setupGame():Void
	{
			//FlxG.log.add("testlog");

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		//if((stageWidth/stageHeight)>1.666666667){
		//var tempconversion:Float=stageHeight*1.666666667;
		//stageWidth=Std.int(tempconversion);
		//}

		if (zoom == -1) //TODO 27.8.14: add something like if ratio is not 1,667 make black borders around to archive this ratio, else we have devices with softwarekeys(onscreen), and due to scaling the game smaller (x-axis) we have something like 1 tilerow to much on y-axis.
		
		{
			var ratioX:Float = stageWidth / gameWidth;//4 or 2,5
			var ratioY:Float = stageHeight / gameHeight;//3,75 or 2,5
			zoom = Math.min(ratioX, ratioY);//3,75 or 2,5 
			gameWidth = Math.ceil(stageWidth / zoom);//342 or 320
			gameHeight = Math.ceil(stageHeight / zoom);//192 or 192
		}

		addChild(new FlxGame(gameWidth, 192, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
	}
}