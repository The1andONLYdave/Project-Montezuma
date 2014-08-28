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
  @:allow(Player.update)
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
	private var _tutorial:Bool;
	private var _text1:FlxText;
	private var _text2:FlxText;
	private var _enemies:FlxGroup;
	private var _coins:FlxGroup;
	private var _coinsRed:FlxGroup;
	private var _coinsGreen:FlxGroup;
	private var _coinsBlue:FlxGroup;
	private var _score:FlxText;
	private var _debug:FlxText;
	public static var virtualPad2:FlxVirtualPad;
	//private var _UINT_switchGreen:Uint;
	//private var _UINT_switchBlue:Uint;
	//private var _UINT_switchRed:Uint;
	//private var _UINT_boxGreen:Uint;
	//private var _UINT_boxBlue:Uint;
	public var _boxRed:UInt;
	
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
	
	
	//TESTI(NG)Room in upper left should not be removed, only locked in, because we need it here to find the right UINT of var.Tiles
//	_UINT_switchGreen=map.getTile(9, 5);
//	_UINT_switchBlue=map.getTile(8, 5);
//	_UINT_switchRed	=map.getTile(7, 5);
//	_UINT_boxGreen	=map.getTile(11,8);
//	_UINT_boxBlue	=map.getTile(8, 8);
//	_boxRed	=map.getTile(6, 8); //get red questionmarkbox
//	map.setTileProperties(_boxRed, FlxObject.NONE); //make all of them collision-off FOR DEBUG
//	map.setTileProperties(_UINT_boxGreen, FlxObject.ANY); //make all of them collision-on
//	map.setTileProperties(_UINT_boxBlue, FlxObject.ANY); //make all of them collision-on
	
	
	

		_tutorial = true;
		_restart = false;
		
		add(background.loadMap(Assets.getText("assets/levels/mapCSV_Group1_Map1back.csv"), "assets/art/simples_pimples.png", 16, 16, FlxTilemap.OFF));
		background.scrollFactor.x = background.scrollFactor.y = .5;
		
		add(map.loadMap(Assets.getText("assets/levels/mapCSV_Group1_Map1.csv"), "assets/art/simples_pimples.png", 16, 16));
		add(ladders.loadMap(Assets.getText("assets/levels/mapCSV_Group1_Ladders.csv"), "assets/art/simples_pimples.png", 16, 16));
		
		virtualPad2 = new FlxVirtualPad(FULL, A_B);
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
		
// Create the actual group of bullets here
		_bullets = new FlxGroup();
		_bullets.maxSize = 4;
		_badbullets = new FlxGroup();
		 
		//
		add(player = new Player(480, 20, this, _gibs, _bullets));
		
		// Attach the camera to the player. The number is how much to lag the camera to smooth things out
		FlxG.camera.follow(player); 
		FlxG.camera.style = FlxCamera.STYLE_SCREEN_BY_SCREEN;
		
		// Set up the enemies here
		_enemies = new FlxGroup();
		placeMonsters(Assets.getText("assets/data/lurkcoords.csv"), Lurker);
		
		_coins = new FlxGroup();
		placeCoins(Assets.getText("assets/data/coins.csv"), Coin);
		
		_coinsRed = new FlxGroup();
		//placeCoinsRed(Assets.getText("assets/data/coinsred.csv"), CoinRed);
		_coinsBlue = new FlxGroup();
		placeCoinsRed(Assets.getText("assets/data/coinsblue.csv"), CoinBlue);
		_coinsGreen = new FlxGroup();
		placeCoinsRed(Assets.getText("assets/data/coinsgreen.csv"), CoinGreen);
	
		_coinsRed.add(new CoinRed((16*25), (16*8))); 
			
		add(_coinsGreen);
		add(_coinsBlue);
		add(_coinsRed);
		
		add(_coins);
		add(_enemies);
		
		Reg.score = 0;
		Reg.silverKeys =9;
		Reg.goldKeys = 9;
		
		super.create();
		
			// Set up the individual bullets
		// Allow 4 bullets at a time
		for (i in 0...4)    
		{
			_bullets.add(new Bullet());
		}
		
		add(_badbullets);
		add(_bullets); 
		add(_gibs);
		add(_mongibs);
		
		// HUD - score
		_score = new FlxText(0, 0, FlxG.width);
		_score.setFormat(null, 16, FlxColor.YELLOW, "center", FlxText.BORDER_OUTLINE, 0x131c1b);
		_score.scrollFactor.set(0, 0);
		add(_score);

		_debug = new FlxText(0, 0, FlxG.width);
		_debug.setFormat(null, 10, FlxColor.GREEN, "left", FlxText.BORDER_OUTLINE, 0x131c1b);
		_debug.scrollFactor.set(0, 0);
		add(_debug);

		
		// Set up the game over text
		_text1 = new FlxText(0, 30, FlxG.width, "Press A - Button to Restart.");
		_text1.setFormat(null, 40, FlxColor.RED, "center", FlxText.BORDER_OUTLINE, FlxColor.BLACK);
		_text1.visible = false;
		_text1.antialiasing = true;
		_text1.scrollFactor.set(0, 0);
		// Add last so it goes on top, you know the drill.
		add(_text1); 

		// Set up the tutorial text
		_text2 = new FlxText(0, 30, FlxG.width, "Press A - Jump \n Press B - Shoot \n Collect Color-Coins to unlock ?-box in same color \n Collect 20 coin to hide Ad \n Collect 25 Coin to win \n A-Button to Start Playing! Have Fun");
		_text2.setFormat(null, 10, FlxColor.GREEN, "center", FlxText.BORDER_OUTLINE, FlxColor.BLACK);
		_text2.visible = false;
		_text2.antialiasing = true;
		_text2.scrollFactor.set(0, 0);
		// Add last so it goes on top, you know the drill.
		add(_text2); 

		FlxG.sound.playMusic("assets/music/ScrollingSpace.ogg");
		_debug.text='dbg: '+map.getTile(6, 8);
		
			
		}
	
	override public function update():Void 
	{
		FlxG.collide(player, map);
		FlxG.collide(_enemies, map);
		FlxG.collide(_gibs, map);
		FlxG.collide(_bullets, map);
		FlxG.collide(_badbullets, map);
		//FlxG.collide(player, 852, collectCoinRed);
		
		super.update();
		
		//_score.text = '$' + Std.string(Reg.score) + ' Silverkeys: ' + Std.string(Reg.silverKeys) + " Goldkeys: " + Std.string(Reg.goldKeys);
		_score.text = '$' + Std.string(Reg.score) + '/100';
		
		
		if (_tutorial)
		{
			_text2.visible = true;
			AD.hide();
			GAnalytics.trackEvent("level1", "action", "tutorial display", 1);
				
			
			if (PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED) 
			{
				AD.show();
				GAnalytics.trackEvent("level1", "action", "tutorial button", 1);
				_text2.visible=false;
				_tutorial=false;
			}
		}
		
		if (!player.alive)
		{
			_text1.visible = true;
			AD.hide();
			//FlxG.vibrate(1000);

			
			if (FlxG.keys.justPressed.R || PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED) 
			{
				AD.show();
				GAnalytics.trackEvent("level1", "action", "another try(pressed A Button)", 1);
				_restart = true;
			}
		}
		
		FlxG.overlap(player, _enemies, hitPlayer);
		FlxG.overlap(player, _coins, collectCoin);
		FlxG.overlap(_bullets, _enemies, hitmonster);
		FlxG.overlap(player, _badbullets, hitPlayer);
		FlxG.overlap(player, _coinsRed, collectCoinRed);
		FlxG.overlap(player, _coinsBlue, collectCoinBlue);
		FlxG.overlap(player, _coinsGreen, collectCoinGreen);
		
		
		if (_restart) 
		{
			FlxG.switchState(new PlayState());
		}
	}
	
	private function collectCoin(P:FlxObject, C:FlxObject):Void 
	{
		C.kill();
		GAnalytics.trackEvent("level1", "action", "Collected a coin", 1);
		//if(Reg.score > 89)
		if(Reg.score == 20)
		
		{
			//disable ADs maybe they hide the last 10 coin else
			GAnalytics.trackEvent("level1", "action", "Collected 20 coin", 1);
			AD.hide();
		}
		if(Reg.score > 24)
		{
			GAnalytics.trackEvent("level1", "action", "Collected 25 coin", 1);
			FlxG.switchState(new WinningState());
			AD.hide();
		}
		
		
		
	}
	
	//if tile 852 collide, unlock tile 902 (red mark and question box)
	private function collectCoinRed(P:FlxObject, C:FlxObject):Void 
	{
	//	if(Reg.red > 0)
			C.kill();
			GAnalytics.trackEvent("level1", "unlock", "red box", 1);
			map.setTileProperties(902, FlxObject.NONE);
			_debug.text='dbg: Red Box Unlocked';
		
	}	
	
	private function collectCoinBlue(P:FlxObject, C:FlxObject):Void 
	{
			C.kill();
			GAnalytics.trackEvent("level1", "unlock", "blue box", 1);
			map.setTileProperties(905, FlxObject.NONE);
			_debug.text='dbg: BoxBlue Unlocked';
		
	}	
	
	private function collectCoinGreen(P:FlxObject, C:FlxObject):Void 
	{
			C.kill();
			GAnalytics.trackEvent("level1", "unlock", "green box", 1);
			map.setTileProperties(906, FlxObject.NONE);
			_debug.text='dbg: Green Box Unlocked';
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
	
	private function hitmonster(Blt:FlxObject, Monster:FlxObject):Void 
	{
		if (!Monster.alive) 
		{ 
			// Just in case
			return; 
		}  
		
		if (Monster.health > 0) 
		{
			Blt.kill();
			Monster.hurt(1);
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
				_enemies.add(new Lurker(16*(Std.parseInt(coords[0])), (16*(Std.parseInt(coords[1]))), player, _badbullets));
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
	private function placeCoinsRed(CoinData:String, Sparkle:Class<FlxObject>):Void 
	{
		var coords:Array<String>;
		// Each line becomes an entry in the array of strings
		var entities:Array<String> = CoinData.split("\n");   
		
		for (j in 0...(entities.length)) 
		{
			//Split each line into two coordinates
			coords = entities[j].split(",");  
			
			if (Sparkle == CoinRed)
			{	
				_coinsRed.add(new CoinRed(16*(Std.parseInt(coords[0])), (16*Std.parseInt(coords[1])))); 
			}
			if (Sparkle == CoinBlue)
			{	
				_coinsBlue.add(new CoinBlue(16*(Std.parseInt(coords[0])), (16*Std.parseInt(coords[1])))); 
			}
			if (Sparkle == CoinGreen)
			{	
				_coinsGreen.add(new CoinGreen(16*(Std.parseInt(coords[0])), (16*Std.parseInt(coords[1])))); 
			}
		}
	}
}