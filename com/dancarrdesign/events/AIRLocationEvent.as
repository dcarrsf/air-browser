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
	 * The AIRLocationEvent class extends the Event class.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author David Gonzalez (dave@mindsteinmedia.com)
	 */
	public class AIRLocationEvent extends Event
	{       
		//*****************************
		// Properties:
		
		public var item:XML;
	 
	 	//******************************
		// Constructor:
		
		public function AIRLocationEvent( eventType:String, i:XML ):void
		{
			super(eventType);
			
			// Update data...
			this.item = i;
		}
	 
	 	//******************************
		// Overrides:
		
		public override function clone():Event
		{
			return new AIRLocationEvent(type, item);
		}
		
		public override function toString():String
		{
			return formatToString("AIRLocationEvent", "item");
		}
	} 
}