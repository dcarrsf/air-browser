/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.controls 
{
	import com.dancarrdesign.core.AIRUIComponent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**********************************
	 * The LocationBar class extends the AIRUIComponent class
	 * to create a sizeable location display field...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class LocationBar extends AIRUIComponent
	{
		private var _location:String;
		private var _btnXOffset:Number = 40;
		
		//*****************************
		// Constructor:
		
		public function LocationBar():void
		{
			// Initialize...
		}
			
		//*****************************
		// Private Methods:
		
		public function setLocation(loc:String):void
		{
			_location = loc;
			location_txt.htmlText = loc;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			location_txt.width = w - (_btnXOffset + 60)
			background_mc.width = w - (_btnXOffset + 40);
		}
	}
}