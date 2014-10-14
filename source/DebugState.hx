package;


import flixel.addons.display.FlxStarField.FlxStarField3D;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
/**
 * ...
 * @author Zaphod
 */
class DebugState extends FlxState
{

public var DemoButton1:FlxButton;
public var DemoButton2:FlxButton;
public var DemoButton3:FlxButton;


	override public function create():Void 
	{
		FlxG.mouse.visible = true;
		
		add(new FlxStarField3D());
		
		var t:FlxText;
		t = new FlxText(0, FlxG.height / 2 - 110, FlxG.width, "FlxTeroids");
		t.setFormat(null, 32, FlxColor.WHITE, "center", FlxText.BORDER_OUTLINE);
		add(t);
		
		t = new FlxText(0, FlxG.height - 140, FlxG.width, "click to play");
		t.setFormat(null, 16, FlxColor.WHITE, "center", FlxText.BORDER_OUTLINE);
		add(t);
		
		DemoButton1 =  new FlxButton((FlxG.width /2)-30 , (FlxG.height/4)*3, "Menu 2", closeDebug);
		add(DemoButton1);
		DemoButton2 =  new FlxButton(((FlxG.width /4)*3 )-30, FlxG.height/2, "More health", closeDebug2);
		add(DemoButton2);
		DemoButton3 =  new FlxButton(((FlxG.width /4)*1 )-30, FlxG.height/2, "Level3", closeDebug3);
		add(DemoButton3);
		
		
		
		
		
		
	}
	
	private function closeDebug():Void
	{
		trace("closeDebug");
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
		FlxG.switchState(new MenuState2());
	}
		private function closeDebug2():Void
	{
		trace("closeDebug2");
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
		Reg.moreHealth=true;
	}
		private function closeDebug3():Void
	{
		trace("closeDebug3");
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
		Reg.level=3;
		FlxG.switchState(new PlayState());
	}
	
}