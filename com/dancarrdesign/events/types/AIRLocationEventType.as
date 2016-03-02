/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed unde the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.events.types
{
	/**********************************
	 * The AIRLocationEventType class extends the Object class
	 * to create a list of location type constants...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRLocationEventType extends Object
	{
		//*****************************
		// Constants:
		
		public static const BACK:String = "back";
		public static const FORWARD:String = "forward";
		public static const RELOAD:String = "reload";
		public static const CANCEL:String = "cancel";
		public static const BOOKMARK:String = "bookmark";
		public static const HOME:String = "home";
		public static const CHANGE:String = "change";
		
		//-------------
		// Loading events...
		
		public static const LOCATION_CHANGE:String = "locationChange";
		public static const DOM_INITIALIZE:String = "domInitialize";
		public static const COMPLETE:String = "complete";
		public static const BOUNDS_CHANGE:String = "boundsChange";
		
		//*****************************
		// Constructor:
		
		public function AIRLocationEventType(){}
	}
}