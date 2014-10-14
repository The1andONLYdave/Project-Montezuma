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
public var DemoButton4:FlxButton;
public var DemoButton5:FlxButton;

private var _music:FlxText;
private var _sound:FlxText;

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
		
		DemoButton1 =  new FlxButton(((FlxG.width /4)*1 )-30 , (FlxG.height/4)*3, "Sound on/off", toggleSound);
		add(DemoButton1);
		DemoButton2 =  new FlxButton(((FlxG.width /4)*3 )-30, FlxG.height/2, "Apply", closeMenu);
		add(DemoButton2);
		DemoButton3 =  new FlxButton(((FlxG.width /4)*1 )-30, FlxG.height/2, "Toggle Music", toggleMusic);
		add(DemoButton3);
		DemoButton4 =  new FlxButton((FlxG.width /2)-30, FlxG.height-25, "Enable Debug (hide Healthbar)", enableDebug);
		add(DemoButton4);
		DemoButton5 =  new FlxButton((FlxG.width /2)-30, (FlxG.height/4)*3, "Menu Debug (developer only)", menuDebug);
		add(DemoButton5);
		

		_sound = new FlxText(((FlxG.width /4)*1 )+50 , (FlxG.height/4)*3, FlxG.width);
		_sound.setFormat(null, 5, FlxColor.GREEN, "left", FlxText.BORDER_OUTLINE, 0x131c1b);
		_sound.scrollFactor.set(0, 0);
		add(_sound);

		_music = new FlxText(((FlxG.width /4)+50) , FlxG.height/2, FlxG.width);
		_music.setFormat(null, 5, FlxColor.GREEN, "left", FlxText.BORDER_OUTLINE, 0x131c1b);
		_music.scrollFactor.set(0, 0);
		add(_music);
		
		
		
		
	}
		override public function update():Void 
	{
		if(Reg.sound==true){_sound.text="on";}
	else{_sound.text="off";}
	if(Reg.music==true){_music.text="on";}
	else{_music.text="off";}
	
	super.update();
	
	}
	
	private function toggleSound():Void
	{
		trace("toggleSound");
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
	if(Reg.sound==true){Reg.sound=false;}
	else{Reg.sound=true;}
	
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
	if(Reg.music==true){Reg.music=false;}
	else{Reg.music=true;}
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
	
	}
		private function enableDebug():Void
	{
		trace(enableDebug);
		if(Reg.debug==false){Reg.debug=true;}
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
	
	}
		private function menuDebug():Void
	{
		trace(menuDebug);
		//GAnalytics.trackEvent("Game", "PauseMenu", "starting", 1);
		FlxG.switchState(new DebugState());
	}
	
	
}