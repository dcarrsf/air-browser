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
	import flash.events.Event;
	import fl.transitions.Tween;

	/**********************************
	 * The ToolTip class extends the AIRUIComponent class
	 * to create a tooltip label control...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 */
	public class ToolTip extends AIRUIComponent
	{
		private var _label:String;
		
		//*****************************
		// Constructor:
		
		public function ToolTip():void
		{
			// Initialize...
			alpha = 0;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//*****************************
		// Events:
		
		private function addedToStageHandler(event:Event):void
		{
			alpha = 0;
			var tween:Tween = new Tween(this, "alpha", null, 0, 100, 100, true);
		}
			
		//*****************************
		// Private Methods:
		
		protected function setLabel(lbl:String):void
		{
			_label = lbl;
			label_txt.autoSize = TextFieldAutoSize.LEFT
			label_txt.text = _label;
			background_mc.width = label_txt.width + 1;
		}
			
		//*****************************
		// Public API:
		
		public function set label(lbl:String):void
		{
			setLabel(lbl);
		}
		
		public function get label():String
		{
			return _label;
		}
	}
}