GAnalytics
=============================
A Google Analytics native extension for OpenFL
-----------------------------

This OpenFL native extension allows you to integrate Google Analytics ( v3.03 ) into your OpenFL application.
The supported compilation targets are [iOS](https://developers.google.com/analytics/devguides/collection/ios/v3) & [Android](https://developers.google.com/analytics/devguides/collection/android/v3/)

Installation
------------
You can install it directly from haxelib:
	
	haxelib install ganalytics


If you didn't install this extension via haxelib and or to have the latest dev version you can download
this sources and set its folder as the source using the following command:
	
	haxelib dev ganalytics path/to/your/downloaded/files

Recompiling
-----------
	lime rebuild ganalytics ios
	
	or
    lime rebuild ganalytics android

Usage
-----
Just call the public methods on the GAnalytics class.

**Baisc reference**

First start the session via :
	GAnalytics.startSession( "YOUR-UA-CODE" );

Tracking a screen view :
	GAnalytics.trackScreen( "your-page-code" );

Tracking an event :
	GAnalytics.trackEvent( "event-cat" , "event-action", "event-label", 1 );

For more advance methods just take a look a the GAnalytics class.
All the Google Analytics V3 methods are supported( timing, metric , social , dimension... )


**This project was Originally forked from HypGA (Hyperfiction)**
[hyperfiction.fr](http://hyperfiction.fr)

License
-------
This work is under BSD simplified License.
