package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import openfl.Assets;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import admob.AD;
import GAnalytics;

class PlayState extends FlxState
{
	public var map:FlxTilemap;
	public var background:FlxTilemap;
	public var ladders:FlxTilemap;
	public var player:Player;

	private var _gibs:FlxEmitter;
	private var _mongibs:FlxEmitter;
	private var _bullets:FlxGroup;
	private var _badbullets:FlxGroup;
	private var _restart:Bool;
	private var _text1:FlxText;
	private var _enemies:FlxGroup;
	private var _coins:FlxGroup;
	private var _score:FlxText;
	public static var virtualPad2:FlxVirtualPad;
	
	
	
	override public function create():Void
	{
		AD.init("ca-app-pub-8761501900041217/8764631680", AD.CENTER, AD.BOTTOM, AD.BANNER_LANDSCAPE, true);
		GAnalytics.startSession( "UA-47310419-7" );
		GAnalytics.trackScreen( "90363841" );
		GAnalytics.trackEvent("level1", "action", "starting", 1);
		AD.show();
		map = new FlxTilemap();
		map.allowCollisions = FlxObject.ANY;
		background = new FlxTilemap();
		ladders = new FlxTilemap();
	
		_restart = false;
		
		add(background.loadMap(Assets.getText("assets/levels/mapCSV_Group1_Map1back.csv"), "assets/art/simples_pimples.png", 16, 16, FlxTilemap.OFF));
		background.scrollFactor.x = background.scrollFactor.y = .5;
		
		add(map.loadMap(Assets.getText("assets/levels/mapCSV_Group1_Map1.csv"), "assets/art/simples_pimples.png", 16, 16));
		add(ladders.loadMap(Assets.getText("assets/levels/mapCSV_Group1_Ladders.csv"), "assets/art/simples_pimples.png", 16, 16));
		
		virtualPad2 = new FlxVirtualPad(FULL, A);
		virtualPad2.setAll("alpha", 0.5);
		add(virtualPad2);	
		
		FlxG.camera.setBounds(0, 0, map.width, map.height);
		FlxG.worldBounds.set(0, 0, map.width, map.height);
		
		// Set up the gibs player
		_gibs = new FlxEmitter();
		_gibs.setXSpeed( -150, 150);
		_gibs.setYSpeed( -200, 0);
		_gibs.setRotation( -720, 720);
		_gibs.makeParticles("assets/art/lizgibs.png", 25, 16, true, .5);
			
		add(player = new Player(480, 20, this, _gibs));
		
		// Attach the camera to the player. The number is how much to lag the camera to smooth things out
		FlxG.camera.follow(player); 
		FlxG.camera.style = FlxCamera.STYLE_SCREEN_BY_SCREEN;
		
		// Set up the enemies here
		_enemies = new FlxGroup();
		placeMonsters(Assets.getText("assets/data/lurkcoords.csv"), Lurker);
		
		_coins = new FlxGroup();
		placeCoins(Assets.getText("assets/data/coins.csv"), Coin);
		
		add(_coins);
		add(_enemies);
		
		Reg.score = 0;
		Reg.silverKeys =9;
		Reg.goldKeys = 9;
		
		super.create();
		
		add(_gibs);
		
		// HUD - score
		_score = new FlxText(0, 0, FlxG.width);
		_score.setFormat(null, 16, FlxColor.YELLOW, "center", FlxText.BORDER_OUTLINE, 0x131c1b);
		_score.scrollFactor.set(0, 0);
		add(_score);
		
		// Set up the game over text
		_text1 = new FlxText(0, 30, FlxG.width, "Press A - Button to Restart.");
		_text1.setFormat(null, 40, FlxColor.RED, "center", FlxText.BORDER_OUTLINE, FlxColor.BLACK);
		_text1.visible = false;
		_text1.antialiasing = true;
		_text1.scrollFactor.set(0, 0);
		// Add last so it goes on top, you know the drill.
		add(_text1); 

		FlxG.sound.playMusic("assets/music/ScrollingSpace.ogg");
	}
	
	override public function update():Void 
	{
		FlxG.collide(player, map);
		FlxG.collide(_enemies, map);
		FlxG.collide(_gibs, map);
		
		super.update();
		
		_score.text = '$' + Std.string(Reg.score) + ' Silverkeys: ' + Std.string(Reg.silverKeys) + " Goldkeys: " + Std.string(Reg.goldKeys);
		
		if (!player.alive)
		{
			_text1.visible = true;
			AD.hide();
			GAnalytics.trackEvent("level1", "action", "player destroyed", 1);
		
			
			if (FlxG.keys.justPressed.R || PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED) 
			{
				AD.show();
				GAnalytics.trackEvent("level1", "action", "another try(pressed A Button)", 1);
				_restart = true;
			}
		}
		
		FlxG.overlap(player, _enemies, hitPlayer);
		FlxG.overlap(player, _coins, collectCoin);
		
		if (_restart) 
		{
			FlxG.switchState(new PlayState());
		}
	}
	
	private function collectCoin(P:FlxObject, C:FlxObject):Void 
	{
		C.kill();
		GAnalytics.trackEvent("level1", "action", "Collected a coin", 1);
		
	}
	
	private function hitPlayer(P:FlxObject, Monster:FlxObject):Void 
	{
		if (Std.is(Monster, Bullet))
		{
			GAnalytics.trackEvent("level1", "action", "Monster hitPlayer", 1);
			Monster.kill();
		}
		
		if (Monster.health > 0)
		{
			GAnalytics.trackEvent("level1", "action", "Monster hurtingPlayer", 1);
			// This should still be more interesting
			P.hurt(1); 
		}
	}
	
	private function placeMonsters(MonsterData:String, Monster:Class<FlxObject>):Void
	{
		var coords:Array<String>;
		// Each line becomes an entry in the array of strings
		var entities:Array<String> = MonsterData.split("\n");   
		
		for (j in 0...(entities.length)) 
		{
			// Split each line into two coordinates
			coords = entities[j].split(","); 
			
			if (Monster == Lurker)
			{ 
				_enemies.add(new Lurker(16*(Std.parseInt(coords[0])), (16*(Std.parseInt(coords[1]))), player));
			}
		}
	}
	
	private function placeCoins(CoinData:String, Sparkle:Class<FlxObject>):Void 
	{
		var coords:Array<String>;
		// Each line becomes an entry in the array of strings
		var entities:Array<String> = CoinData.split("\n");   
		
		for (j in 0...(entities.length)) 
		{
			//Split each line into two coordinates
			coords = entities[j].split(",");  
			
			if (Sparkle == Coin)
			{
				_coins.add(new Coin(16*(Std.parseInt(coords[0])), (16*Std.parseInt(coords[1])))); 
			}
		}
	}
	
}