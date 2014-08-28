package org.haxe.extension;


import com.google.analytics.tracking.android.EasyTracker;
import com.google.analytics.tracking.android.Fields;
import com.google.analytics.tracking.android.GAServiceManager;
import com.google.analytics.tracking.android.GoogleAnalytics;
import com.google.analytics.tracking.android.Logger.LogLevel;
import com.google.analytics.tracking.android.Logger;
import com.google.analytics.tracking.android.MapBuilder;
import com.google.analytics.tracking.android.Tracker;


import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;

/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class GAnalytics extends Extension {
	
	
	
	
	private static Tracker _gaTracker;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public GAnalytics( ){
			//trace("constructor");
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void setDry_run( boolean b ){
			GoogleAnalytics.getInstance( mainContext ).setDryRun( b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void setOpt_out( boolean b ){
			GoogleAnalytics.getInstance( mainContext ).setAppOptOut( b );
		}


		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void startSession( String sUA_code , int iPeriod ) {
			//trace("startSession ::: "+sUA_code+" - "+iPeriod);
			_gaTracker = GoogleAnalytics.getInstance( mainContext ).getTracker( sUA_code );
			setDispatch_period( iPeriod );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void setDispatch_period( int iPeriod ) {
			GAServiceManager.getInstance().setLocalDispatchPeriod(iPeriod);
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void dispatch( ){
			GAServiceManager.getInstance().dispatchLocalHits( );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void trackScreen( String sScreen ){
			//trace("trackScreen ::: "+sScreen);
			_gaTracker.send( MapBuilder.createAppView( ).set( Fields.SCREEN_NAME , sScreen ).build( ) );

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void trackEvent( String sCat , String sAction , String sLabel , int iVal ){
			_gaTracker.send( MapBuilder.createEvent( sCat , sAction , sLabel , Long.valueOf( iVal ) ).build( ) );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void trackSocial( String sSocial_network , String sAction , String sTarget ){
			_gaTracker.send( MapBuilder.createSocial( sSocial_network , sAction , sTarget ).build( ) );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public static void sendTiming( String sCat , int iInterval , String sName , String sLabel ){
			_gaTracker.send( MapBuilder.createTiming( sCat , Long.valueOf( iInterval ) , sName , sLabel ).build( ) );
		}

	// -------o protected



	// -------o misc
	
	
	
	public static int sampleMethod (int inputValue) {
		
		return inputValue * 100;
		
	}
	
	
	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
		
		return true;
		
	}
	
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {
		
		
		
	}
	
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
		
		
		
	}
	
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
		
		EasyTracker.getInstance( mainContext ).activityStop( mainActivity );
		
	}
	
	
	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
		
		EasyTracker.getInstance( mainContext ).activityStart( mainActivity );
		GoogleAnalytics.getInstance( mainContext ).getLogger( ).setLogLevel( LogLevel.VERBOSE );
		
	}
	
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
		
		
		
	}
	
	
}