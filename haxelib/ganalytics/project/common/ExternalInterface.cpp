#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


using namespace ganalytics;



#ifdef IPHONE

	static value ganalytics_startNewSession( value sUA_code , value iPeriod ){
		startNewSession( val_string( sUA_code ) , val_int( iPeriod ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_startNewSession , 2 );

	static value ganalytics_sendScreenView( value sScreen ){
		sendScreenView( val_string( sScreen ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendScreenView , 1 );

	static value ganalytics_sendEvent( value sCat , value sAction , value sLabel , value iValue ){
		sendEvent(
					val_string( sCat ),
					val_string( sAction ),
					val_string( sLabel ),
					val_int( iValue )
				);
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendEvent , 4 );

	static value ganalytics_setCustom_dimension( value iIndex , value sValue ){
		setCustom_dimension( val_int( iIndex ) , val_string( sValue ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_setCustom_dimension , 2 );

	static value ganalytics_setCustom_metric( value iIndex , value iMetric ){
		setCustom_metric( val_int( iIndex ) , val_int( iMetric ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_setCustom_metric , 2 );

	static value ganalytics_sendTiming( value sCat , value interval , value name , value label ){
		sendTiming( val_string( sCat ) , val_int( interval ) , val_string( name ) , val_string( label ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendTiming , 4 );

	static value ganalytics_stopSession( ){
		stopSession( );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_stopSession , 0 );

	static value ganalytics_sendSocial( value sNetwork , value sAction , value sTarget ){
		sendSocial( val_string( sNetwork ) , val_string( sAction ) , val_string( sTarget ) );
		return alloc_null( );
	}
	DEFINE_PRIM( ganalytics_sendSocial , 3 );

#endif


extern "C" void ganalytics_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (ganalytics_main);


extern "C" int ganalytics_register_prims () { return 0; }