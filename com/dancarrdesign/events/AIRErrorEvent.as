/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed unde the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.events
{
	import flash.events.Event;
	
	/**********************************
	 * The AIRErrorEvent class extends the Event class.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRErrorEvent extends Event
	{ 
		//*****************************
		// Properties:
		
		public var info:String;
	 
	 	//******************************
		// Constructor:
		
		public function AIRErrorEvent( errorType:String, i:String ):void
		{
			super(errorType);
			
			// Update data...
			this.info = i;
		}
	 
	 	//******************************
		// Overrides:
		
		public override function clone():Event
		{
			return new AIRErrorEvent(type, info);
		}
		
		public override function toString():String
		{
			return formatToString("AIRErrorEvent", "type", "info");
		}
	} 
}