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
class SettingsState extends FlxState
{
public var DemoButton1:FlxButton;
public var DemoButton2:FlxButton;
public var DemoButton3:FlxButton;


	override public function create():Void 
	{
		FlxG.mouse.visible = true;
		
		add(new FlxStarField3D());
		
		var t:FlxText;
		t = new FlxText(0, FlxG.height / 2 - 110, FlxG.width, "Montezumas");
		t.setFormat(null, 32, FlxColor.WHITE, "center", FlxText.BORDER_OUTLINE);
		add(t);
		
		t = new FlxText(0, FlxG.height - 140, FlxG.width, "Tower 8bit");
		t.setFormat(null, 16, FlxColor.WHITE, "center", FlxText.BORDER_OUTLINE);
		add(t);
		
		DemoButton1 =  new FlxButton((FlxG.width /2)-30 , (FlxG.height/4)*3, "Sound on/off (coming soon)", toggleSound);
		add(DemoButton1);
		DemoButton2 =  new FlxButton(((FlxG.width /4)*3 )-30, FlxG.height/2, "Back", closeMenu);
		add(DemoButton2);
		DemoButton3 =  new FlxButton(((FlxG.width /4)*1 )-30, FlxG.height/2, "Toggle Music (coming soon)", toggleMusic);
		add(DemoButton3);
		
		
		
		
		
		
	}
	
	private function toggleSound():Void
	{
		trace("toggleSound");
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);

	}
		private function closeMenu():Void
	{
		trace("closeMenu");
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
		FlxG.switchState(new MenuState());
	}
		private function toggleMusic():Void
	{
		trace(toggleMusic);
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
	
	}
	
}