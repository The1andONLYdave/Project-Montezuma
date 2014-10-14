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
class MenuState2 extends FlxState
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
		
		DemoButton1 =  new FlxButton(((FlxG.width /4)*1 )-30 , (FlxG.height/4)*3, "Level 2", levelPlay2);
		add(DemoButton1);
		DemoButton2 =  new FlxButton(((FlxG.width /4)*3 )-30, FlxG.height/2, "Option", optionMenu);
		add(DemoButton2);
		DemoButton3 =  new FlxButton(((FlxG.width /4)*1 )-30, FlxG.height/2, "Level 1", levelPlay1);
		add(DemoButton3);
		DemoButton4 =  new FlxButton((FlxG.width /2)-30, FlxG.height-25, "Feedback (Email)", mailFeedback);
		add(DemoButton4);
		DemoButton5 =  new FlxButton((FlxG.width /2)-30, (FlxG.height/4)*3, "View Map", viewMap);
		add(DemoButton5);
		

		_sound = new FlxText(((FlxG.width /4)*1 )+50 , (FlxG.height/4)*3, FlxG.width);
		_sound.setFormat(null, 5, FlxColor.GREEN, "left", FlxText.BORDER_OUTLINE, 0x131c1b);
		_sound.scrollFactor.set(0, 0);
		add(_sound);
		_sound.visible=false;

		_music = new FlxText(((FlxG.width /4)+50) , FlxG.height/2, FlxG.width);
		_music.setFormat(null, 5, FlxColor.GREEN, "left", FlxText.BORDER_OUTLINE, 0x131c1b);
		_music.scrollFactor.set(0, 0);
		add(_music);
		_music.visible=false;
		
		
		
	}
		override public function update():Void 
	{
	
	super.update();
	
	}
	
	private function levelPlay1():Void
	{
	GAnalytics.trackEvent("Montezuma Mainmenu", "run", "level 1", 1);
	Reg.level = 1;
	Reg.score = 0; //TODO different score for each level?		
	FlxG.cameras.fade(0xff969867, 1, false, startGame);
	if(Reg.sound==true){FlxG.sound.play("assets/sounds/coin" + Reg.SoundExtension, 1, false);}
	}
	private function levelPlay2():Void
	{
	GAnalytics.trackEvent("Montezuma Mainmenu", "run", "level 2", 1);
	Reg.level=2;
	Reg.score =0;//for adding 25 for each level, because we need more coins to win
	FlxG.cameras.fade(0xff969867, 1, false, startGame);
	if(Reg.sound==true){FlxG.sound.play("assets/sounds/coin" + Reg.SoundExtension, 1, false);}
	}
	private function mailFeedback():Void
	{
		GAnalytics.trackEvent("Montezuma Mainmenu", "run", "contactformular", 1);
		FlxG.openURL("http://kulsch-it.de/#contact");
	}
	private function viewMap():Void
	{
		GAnalytics.trackEvent("Montezuma Mainmenu", "run", "mapview", 1);				
		FlxG.openURL("http://app-liste.de/other/Overview-level2.png");
	}
	private function optionMenu():Void
	{
		GAnalytics.trackEvent("Montezuma Mainmenu", "run", "OptionMenu", 1);
		FlxG.switchState(new SettingsState());
	}
	private function startGame():Void
	{	
		FlxG.switchState(new PlayState());
	}
	
}