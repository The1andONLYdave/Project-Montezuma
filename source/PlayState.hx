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
//import admob.AD;
import GAnalytics;

import ru.zzzzzzerg.linden.GooglePlay;
import ru.zzzzzzerg.linden.play.Achievement;
import ru.zzzzzzerg.linden.play.AppState;



  @:allow(Player.update)
class PlayState extends FlxState
{
	public static var LEADERBOARD_ID = "CgkI5-a8jM8FEAIQEA";
	public static var ACHIEVEMENT_ID = "CgkI5-a8jM8FEAIQCg";
	public static var ACHIEVEMENT_ID_INC = "CgkI5-a8jM8FEAIQAg";

	public static var STATE_KEY = 1;

	public var googlePlay : GooglePlay;

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
	private var black:Bool=false;
	private var increment:Int;
	//private var _UINT_switchGreen:Uint;
	//private var _UINT_switchBlue:Uint;
	//private var _UINT_switchRed:Uint;
	//private var _UINT_boxGreen:Uint;
	//private var _UINT_boxBlue:Uint;
	public var _boxRed:UInt;
	private var enemyHurted:Int;
	private var enemyKilled:Int;
	private var achivement:Int;
	private var maximumScore:Int;
	
	override public function create():Void
	{
		//ad.init("ca-app-pub-8761501900041217/8764631680", AD.CENTER, AD.BOTTOM, AD.BANNER_LANDSCAPE, true);
		GAnalytics.startSession( "UA-47310419-7" );
		GAnalytics.trackScreen( "90363841" );
		GAnalytics.trackEvent(Std.string(Reg.level), "action", "starting", 1);
		//ad.show();
		map = new FlxTilemap();
		map.allowCollisions = FlxObject.ANY;
		background = new FlxTilemap();
		ladders = new FlxTilemap();
		enemyHurted=0;
		enemyKilled=0;
		achivement=0;
		increment=0;
		maximumScore=100;//just in case
	//TESTI(NG)Room in upper left should not be removed, only locked in, because we need it here to find the right UINT of var.Tiles

if(Reg.level>Reg.maxLevel){
	Reg.level=Reg.maxLevel;
}

if(Reg.level>0){ //tutorial only on first level, TODO if we need more tutorials for next levels choose them here
	_tutorial=false;
}
else{
	_tutorial = true;
	Reg.score = 0; //TODO different score for each level?
		
}
	
add(background.loadMap(Assets.getText("assets/levels/mapCSV_Group"+Std.string(Reg.level)+"_Map1back.csv"), "assets/art/simples_pimples.png", 16, 16, FlxTilemap.OFF));
	background.scrollFactor.x = background.scrollFactor.y = .5;	
add(map.loadMap(Assets.getText("assets/levels/mapCSV_Group"+Std.string(Reg.level)+"_Map1.csv"), "assets/art/simples_pimples.png", 16, 16));
add(ladders.loadMap(Assets.getText("assets/levels/mapCSV_Group"+Std.string(Reg.level)+"_Ladders.csv"), "assets/art/simples_pimples.png", 16, 16));
			
		_restart = false;
		
		
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
		add(player = new Player(400, 50, this, _gibs, _bullets));
		
		// Attach the camera to the player. The number is how much to lag the camera to smooth things out
		FlxG.camera.follow(player); 
		FlxG.camera.style = FlxCamera.STYLE_SCREEN_BY_SCREEN;
		
		
		if(Reg.level==0){
			// Set up the enemies here
			_enemies = new FlxGroup();
			placeMonsters(Assets.getText("assets/data/"+Std.string(Reg.level)+"lurkcoords.csv"), Lurker);
		
			_coins = new FlxGroup();
			placeCoins(Assets.getText("assets/data/"+Std.string(Reg.level)+"coins.csv"), Coin);
			
			_coinsRed = new FlxGroup();
			placeCoinsRed(Assets.getText("assets/data/"+Std.string(Reg.level)+"coinsred.csv"), CoinRed);
			trace("Pathdata: assets/data/"+Std.string(Reg.level)+"coinsred.csv");
			_coinsBlue = new FlxGroup();
			placeCoinsRed(Assets.getText("assets/data/"+Std.string(Reg.level)+"coinsblue.csv"), CoinBlue);
			_coinsGreen = new FlxGroup();
			placeCoinsRed(Assets.getText("assets/data/"+Std.string(Reg.level)+"coinsgreen.csv"), CoinGreen);
	
		//	_coinsRed.add(new CoinRed((16*25), (16*8))); 
			maximumScore=25;
		}	
		
		add(_coinsGreen);
		add(_coinsBlue);
		add(_coinsRed);
		
		add(_coins);
		add(_enemies);
		
		
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
		_text2 = new FlxText(0, 30, FlxG.width, "Official Developer Preview \n \n Press A - Jump \n Press B - Shoot \n Collect Color-Coins to unlock ?-Box in same color \n  Collect 25 Coin to win \n \n \n Press A to Start Playing! Have Fun");
		_text2.setFormat(null, 10, FlxColor.GREEN, "center", FlxText.BORDER_OUTLINE, FlxColor.BLACK);
		_text2.visible = false;
		_text2.antialiasing = true;
		_text2.scrollFactor.set(0, 0);
		// Add last so it goes on top, you know the drill.
		add(_text2); 

		FlxG.sound.playMusic("assets/music/ScrollingSpace"+Std.string(Reg.level)+".ogg",true);
		_debug.text='dbg: '+map.getTile(6, 8);
		
			
    googlePlay = new GooglePlay(new GooglePlayHandler());
   
	 if(!googlePlay.games.isSignedIn())
    {
      if(!googlePlay.games.connect())
      {
        trace("Failed to sign in to GooglePlay.GamesClient");
      }
    }
    else
    {
      trace("Signed in");
	   _debug.text='dbg:signed gpg in';
    }
	_debug.text="play level "+Std.string(Reg.level);
		}
	
	override public function update():Void 
	{
		FlxG.collide(player, map);
		FlxG.collide(_enemies, map);
		FlxG.collide(_gibs, map);
		FlxG.collide(_bullets, map);
		FlxG.collide(_badbullets, map);
		//FlxG.collide(player, 852, collectCoinRed); //TODO add fire collisions (need tilemapnumber for fire green, red, blue in all tilemapfiles)
		
		super.update();
		
		//_score.text = '$' + Std.string(Reg.score) + ' Silverkeys: ' + Std.string(Reg.silverKeys) + " Goldkeys: " + Std.string(Reg.goldKeys);
		_score.text = '$' + Std.string(Reg.score) + '/' + Std.string(maximumScore*Reg.level);
		
		
		if (_tutorial)
		{
			//ad.hide();
			if(!black){
				//FlxG.camera.fade(FlxColor.BLACK, .33, false);
				FlxG.camera.flash(0xff000000, 1);
				black=true;
				trace("black");
				GAnalytics.trackEvent(Std.string(Reg.level), "action", "tutorial black display", 1);
				_text2.visible = true;
			}
			
			
			//trace("run "+increment);
			//increment++;
			
			    
	
			if (PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED) 
			{
				//ad.show();
				GAnalytics.trackEvent(Std.string(Reg.level), "action", "tutorial button", 1);
				_text2.visible=false;
				_tutorial=false;
				
				googlePlay.games.unlockAchievement(ACHIEVEMENT_ID);
				googlePlay.games.incrementAchievement("CgkI5-a8jM8FEAIQCA", 1);
				googlePlay.games.incrementAchievement("CgkI5-a8jM8FEAIQCQ", 1);
				
			}
		}
		
		if (!player.alive)
		{
			_text1.visible = true;
			//ad.hide();
			googlePlay.games.incrementAchievement("CgkI5-a8jM8FEAIQAw", 1);
			GAnalytics.trackEvent(Std.string(Reg.level), "action", "player died", 1);
			//play gameover.ogg	
			FlxG.sound.music.stop();//stopgamemusic
			FlxG.sound.playMusic("assets/music/GameOver.ogg");
			
			if (FlxG.keys.justPressed.R || PlayState.virtualPad2.buttonA.status == FlxButton.PRESSED) 
			{
				//ad.show();
				GAnalytics.trackEvent(Std.string(Reg.level), "action", "another try(pressed A Button)", 1);
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
		GAnalytics.trackEvent(Std.string(Reg.level), "action", "Collected a coin", 1);
		googlePlay.games.incrementAchievement(ACHIEVEMENT_ID_INC, 1);
		if(Reg.score == 1) {
		googlePlay.games.unlockAchievement("CgkI5-a8jM8FEAIQAQ");
		}//if(Reg.score > 89)
		if(Reg.score == ((maximumScore*Reg.level)-5))
		
		{
			//disable ADs maybe they hide the last 10 coin else
			GAnalytics.trackEvent(Std.string(Reg.level), "action", "Collected maximumScore -5 coin", 1);
			//ad.hide();
		}
		if(Reg.score >= (maximumScore*Reg.level))
		{
			GAnalytics.trackEvent(Std.string(Reg.level), "action", "Collected maximumScore coin", 1);
			if(enemyHurted<1){googlePlay.games.unlockAchievement("CgkI5-a8jM8FEAIQBw");}
			if(enemyKilled<1){googlePlay.games.unlockAchievement("CgkI5-a8jM8FEAIQBg");}
			
			googlePlay.games.submitScore(LEADERBOARD_ID, Reg.score);
			googlePlay.games.showLeaderboard(LEADERBOARD_ID);
			
			FlxG.switchState(new WinningState());
			//ad.hide();
		}
		
		
		
	}
	
	//if tile 852 collide, unlock tile 902 (red mark and question box)
	private function collectCoinRed(P:FlxObject, C:FlxObject):Void 
	{
			C.kill();
			GAnalytics.trackEvent(Std.string(Reg.level), "unlock", "red box", 1);
			map.setTileProperties(902, FlxObject.NONE);
			_debug.text='dbg: Red Box Unlocked';
		
	}	
	
	private function collectCoinBlue(P:FlxObject, C:FlxObject):Void 
	{
			C.kill();
			GAnalytics.trackEvent(Std.string(Reg.level), "unlock", "blue box", 1);
			map.setTileProperties(905, FlxObject.NONE);
			_debug.text='dbg: BoxBlue Unlocked';
		
	}	
	
	private function collectCoinGreen(P:FlxObject, C:FlxObject):Void 
	{
			C.kill();
			GAnalytics.trackEvent(Std.string(Reg.level), "unlock", "green box", 1);
			map.setTileProperties(906, FlxObject.NONE);
			_debug.text='dbg: Green Box Unlocked';
	}	




	  	
	private function hitPlayer(P:FlxObject, Monster:FlxObject):Void 
	{
		if (Std.is(Monster, Bullet))
		{
			GAnalytics.trackEvent(Std.string(Reg.level), "action", "Monster killed", 1);
			googlePlay.games.unlockAchievement("CgkI5-a8jM8FEAIQBA");
			googlePlay.games.incrementAchievement("CgkI5-a8jM8FEAIQBQ", 1);
			GAnalytics.trackEvent(Std.string(Reg.level), "action", "Monster killed tracked", 1);
			Monster.kill();
			enemyKilled++;
			trace(["HitPlayer",enemyHurted,enemyKilled]);
	
		}
		
		if (Monster.health > 0)
		{
			GAnalytics.trackEvent(Std.string(Reg.level), "action", "Monster hurtingPlayer", 1);
			// This should still be more interesting
			P.hurt(1);
			trace(["HitPlayer",enemyHurted,enemyKilled]);			
		}
	}
	
	private function hitmonster(Blt:FlxObject, Monster:FlxObject):Void 
	{
		if (!Monster.alive) 
		{ 
			// Just in case
			trace(["hitmonster",enemyHurted,enemyKilled]);
			return; 
		}  
		
		if (Monster.health > 0) 
		{
			enemyHurted++;
			trace(["hitmonster",enemyHurted,enemyKilled]);
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
	 function onSignInGamesClick()
  {
    if(!googlePlay.games.isSignedIn())
    {
      if(!googlePlay.games.connect())
      {
        trace("Failed to sign in to GooglePlay.GamesClient");
      }
    }
    else
    {
      trace("Signed in");
    }
  }

  function onSignOutGamesClick()
  {
    googlePlay.games.signOut();
  }


  function onUnlockAchievementClick()
  {
    trace(["Unlock", ACHIEVEMENT_ID]);
	googlePlay.games.unlockAchievement(ACHIEVEMENT_ID);
  }

  function onUnlockIncrementalAchievementClick()
  {
      trace(["Increment", ACHIEVEMENT_ID_INC]);
	  googlePlay.games.incrementAchievement(ACHIEVEMENT_ID_INC, 1);
  }

  function onShowAchievementsClick()
  {
    googlePlay.games.showAchievements();
  }

  function onUpdateScoreClick()
  {
    googlePlay.games.submitScore(LEADERBOARD_ID, Std.random(1000));
  }

  function onShowLeaderboardClick()
  {
    googlePlay.games.showLeaderboard(LEADERBOARD_ID);
  }

}
class GooglePlayHandler extends ru.zzzzzzerg.linden.play.ConnectionHandler
{
  //var _m : Main;

  //public function new(m : Main)
 // {
   // super();
  //  _m = m;
 // }

  
  override public function onAchievementsLoaded(achievements : Array<Achievement>)
  {
    for(a in achievements)
    {
      trace(a);
    }
  }

  override public function onStateListLoaded(states : Array<AppState>)
  {
    for(s in states)
    {
      trace(s);
    }
  }


  override public function onWarning(msg : String, where : String)
  {
    trace(["Warning", msg, where]);
  }

  override public function onError(what : String, code : Int, where : String)
  {
    trace(["Error", what, code, where]);
  }

  override public function onException(msg : String, where : String)
  {
    trace(["Exception", msg, where]);
  }
}