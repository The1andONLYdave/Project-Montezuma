package;

import flixel.util.FlxSave;

/**
* Handy, pre-built Registry class that can be used to store 
* references to objects and other things for quick-access. Feel
* free to simply ignore it or change it in any way you like.
*/
class Reg
{
	public static var SoundExtension:String = ".wav";
	
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int =1;
	public static var maxLevel:Int =3;//1=tutorial, 2=normal level
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var maximumScore:Array<Int> = [0,36,42,100];//level 0 dont exist
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	public static var live:Int=5;
	public static var debug:Bool=false;
	public static var moreHealth=false;
	public static var sound=true;
	public static var music=true;
	
	/**
	 * Generic container for a <code>FlxSave</code>. You might want to 
	 * consider assigning <code>FlxG.game._prefsSave</code> to this in
	 * your state if you want to use the same save flixel uses internally
	 */
	public static var save:FlxSave;
}