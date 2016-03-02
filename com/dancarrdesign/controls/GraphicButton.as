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
	import flash.events.MouseEvent;

	/**********************************
	 * The GraphicButton class extends the AIRUIComponent class
	 * to create a button with manually generated button states...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 */
	public class GraphicButton extends AIRUIComponent
	{
		//*****************************
		// Constructor:
		
		public function GraphicButton():void
		{
			// Initialize...
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, onOverHandler);
		}
		
		//*****************************
		// Events:
		
		protected function onOverHandler(event:MouseEvent):void
		{
			gotoAndStop("over");
		}
		
		protected function onOutHandler(event:MouseEvent):void
		{
			gotoAndStop("up");
		}
		
		protected function onDownHandler(event:MouseEvent):void
		{
			gotoAndStop("down");
		}
	}
}