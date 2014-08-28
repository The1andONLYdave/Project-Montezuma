package;

/*
Copyright (c) 2013, Hyperfiction
All rights reserved.

Update to Google Analytics V3 API and latest OpenFL API by Emiliano Angelini - Emibap

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class GAnalytics {

	// -------o public

	/**
	* Start the Ga tracking session
	*
	* @public
	* @param sUA : GA UA code ( String )
	* @param iPeriod ( Int )
	* @return	void
	*/

	static public function startSession( sUA : String , iPeriod : Int = 15 ) : Void {
		#if (android && openfl)
		
		if (ganalytics_startNewSession_jni == null) ganalytics_startNewSession_jni = JNI.createStaticMethod ("org.haxe.extension.GAnalytics", "startSession", "(Ljava/lang/String;I)V");
		
		ganalytics_startNewSession_jni(sUA, iPeriod);
		
		#elseif ios
		
		ganalytics_startNewSession(sUA, iPeriod);
		
		#end
	}

	/**
	* Stop the GA tracking session
	*
	* @public
	* @return	void
	*/

	static public function stopSession( ) : Void {
		#if (android && openfl)
		
		#elseif ios
		
		ganalytics_stopSession();
		
		#end
	}
	
	/**
	* Track a screen view
	*
	* @public
	* @param 	sScreen : Code of the screen to be tracked ( String )
	* @return	void
	*/

	static public function trackScreen( sScreen : String ) : Void {
		#if (android && openfl)
		
		if (ganalytics_trackScreen_jni == null) ganalytics_trackScreen_jni = JNI.createStaticMethod ("org.haxe.extension.GAnalytics", "trackScreen", "(Ljava/lang/String;)V");
		
		ganalytics_trackScreen_jni(sScreen);
		
		#elseif ios
		
		ganalytics_sendScreenView(sScreen);
		
		#end
	}

	/**
	* Track a event
	*
	* @public
	* @param	sCat		: Event category 	( String )
	* @param	sCat		: Action 			( String )
	* @param	sLabel	: Event label 		( String )
	* @param	value	: Event value 		( Int )
	* @return	void
	*/

	static public function trackEvent( sCat : String , sAction : String , sLabel : String , value : Int = 1 ) : Void {
		#if (android && openfl)
		
		if (ganalytics_trackEvent_jni == null) ganalytics_trackEvent_jni = JNI.createStaticMethod ("org.haxe.extension.GAnalytics", "trackEvent", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V");
		ganalytics_trackEvent_jni(sCat, sAction, sLabel, value);

		#elseif ios
			ganalytics_sendEvent(sCat, sAction, sLabel, value);
		#end
	}

	/**
	*
	*
	* @public
	* @param	sCat		: Event category 	( String )
	* @param	iInterval	: Timing interval 	( Int )
	* @param	sName	: Timing name 		( String )
	* @param	sLabel	: Label 			( String )
	* @return	void
	*/

	static public function sendTiming( sCat : String , iInterval : Int , sName : String , sLabel : String ) : Void {
		#if (android && openfl)

		if (ganalytics_sendTiming_jni == null) ganalytics_sendTiming_jni = JNI.createStaticMethod ("org.haxe.extension.GAnalytics", "sendTiming", "(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
		ganalytics_sendTiming_jni(sCat, iInterval, sName, sLabel);
		
		#elseif ios
		
		ganalytics_sendTiming(sCat, iInterval, sName, sLabel);
		
		#end
	}

	/**
	* Set a custom dimension value
	*
	* @public
	* @param	iIndex : Index of the dimension 	( Int )
	* @param	sValue : Dimension value 		( String )
	* @return	void
	*/

	static public function setCustom_dimension( iIndex : Int , sValue : String ) : Void {
		#if (android && openfl)
		
		#elseif ios
			ganalytics_setCustom_dimension(iIndex, sValue);
		#end
	}

	/**
	* Set a custom metric value
	*
	* @public
	* @param	iIndex : Index of the metric 	( Int )
	* @param	sValue : Metric value 		( String )
	* @return	void
	*/

	static public function setCustom_metric( iIndex : Int , iValue : Int ) : Void {
		#if (android && openfl)
		
		#elseif ios
		
		ganalytics_setCustom_metric(iIndex, iValue);
		
		#end
	}

	/**
	* Track a social event
	*
	* @public
	* @param 	sSocial_network :Targetted social network ( String )
	* @param 	sAction : Action ( String )
	* @return	void
	*/

	static public function trackSocial( sSocial_network : String , sAction : String , sTarget : String ) : Void {
		#if (android && openfl)
			
		if (ganalytics_trackSocial_jni == null) ganalytics_trackSocial_jni = JNI.createStaticMethod ("org.haxe.extension.GAnalytics", "trackSocial", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
		ganalytics_trackSocial_jni(sSocial_network, sAction, sTarget);
		
		#elseif ios
		
		ganalytics_sendSocial(sSocial_network, sAction, sTarget);
		
		#end
	}

	// -------o protected

	// -------o misc
	
	
	#if ios
	
	private static var ganalytics_startNewSession = Lib.load ("ganalytics", "ganalytics_startNewSession", 2);
	
	private static var ganalytics_stopSession = Lib.load ("ganalytics", "ganalytics_stopSession", 0);
	
	private static var ganalytics_sendScreenView = Lib.load ("ganalytics", "ganalytics_sendScreenView", 1);
	
	private static var ganalytics_sendEvent = Lib.load ("ganalytics", "ganalytics_sendEvent", 4);
	
	private static var ganalytics_sendTiming = Lib.load ("ganalytics", "ganalytics_sendTiming", 4);
	
	private static var ganalytics_setCustom_dimension = Lib.load ("ganalytics", "ganalytics_setCustom_dimension", 2);
	
	private static var ganalytics_setCustom_metric = Lib.load ("ganalytics", "ganalytics_setCustom_metric", 2);
	
	private static var ganalytics_sendSocial = Lib.load ("ganalytics", "ganalytics_sendSocial", 3);
	
	#end
	
	#if (android && openfl)
	
	private static var ganalytics_startNewSession_jni: Dynamic;
	
	private static var ganalytics_trackScreen_jni: Dynamic;
	
	private static var ganalytics_trackEvent_jni: Dynamic;
	
	private static var ganalytics_sendTiming_jni: Dynamic;
	
	private static var ganalytics_trackSocial_jni: Dynamic;
	
	#end
	
	
}