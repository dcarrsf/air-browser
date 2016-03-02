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
	import flash.display.*;
	
	/**********************************
	 * The AIRMenuEvent class extends the Event class.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRMenuEvent extends Event
	{     
		//*****************************
		// Constants:
		
		public static const SELECT:String = "select";
		
		//*****************************
		// Properties:
		
		public var item:NativeMenuItem;
	 
	 	//******************************
		// Constructor:
		
		public function AIRMenuEvent( i:NativeMenuItem ):void
		{
			super(SELECT);
			
			// Update data...
			this.item = i;
		}
	 
	 	//******************************
		// Overrides:
		
		public override function clone():Event
		{
			return new AIRMenuEvent(item);
		}
		
		public override function toString():String
		{
			return formatToString("AIRMenuEvent", "item");
		}
	} 
}