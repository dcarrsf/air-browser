/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed unde the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.html
{
	import com.dancarrdesign.core.AIRUIComponent;
	import com.dancarrdesign.events.AIRLocationEvent;
	import com.dancarrdesign.events.types.AIRLocationEventType;
	import flash.display.*;    
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**********************************
	 * The HTMLHeader class extends the AIRUIComponent class
	 * to create a scalable location bar...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class HTMLHeader extends AIRUIComponent
	{
		//***************************
		// Properties:
		
		private var _btnXOffset:Number = 40;
		private var _dropdownRowCount:uint = 20;
		private var _settings:XML;
		
		//***************************
		// Constructor:
		
		public function HTMLHeader() 
		{
			// Size ourselves
			setSize(_preferredWidth, _preferredHeight);
			
			// Initialize...
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		//*****************************
		// Events:
		
		// Catch clicks from the navigation buttons
		
		protected function clickHandler(event:MouseEvent):void
		{
			// Populate info object with properties if needed...
			var info:XML = <info/>;
			
			// Process and relay events...
			switch( event.target.name )
			{
				case "back_btn":
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.BACK, info));
					break;
					
				case "forward_btn":
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.FORWARD, info));
					break;
					
				case "reload_btn":
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.RELOAD, info));
					break;
					
				case "cancel_btn":
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.CANCEL, info));
					break;
					
				case "bookmark_btn":
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.BOOKMARK, info));
					break;
					
				case "home_btn":
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.HOME, info));
					break;
			}
		}
		
		//*****************************
		// Public Methods:
		
		public function setButtonState(btnName:String, state:Boolean):void
		{
			switch( btnName )
			{
				case "back":
				
					back_btn.enabled = state;
					back_btn.mouseEnabled = state;
					back_btn.alpha = state ? 1 : .4;
					break;
					
				case "forward":
				
					forward_btn.enabled = state;
					forward_btn.mouseEnabled = state;
					forward_btn.alpha = state ? 1 : .4;
					break;
			}
		}
		
		public function setSize(w:Number, h:Number):void
		{
			w = Math.max(300, w);
			line_mc.width = w;
			background_mc.width = w;
			location_mc.setSize(w-location_mc.x, h);
			home_btn.x = w - _btnXOffset;
		}
		
		public function setLocation(loc:String):void
		{
			location_mc.setLocation(loc);
		}
		
		//*****************************
		// Public Properties:
		
		public function set settings(dp:XML):void
		{
			_settings = dp;
			
			// Configure tooltips
			back_btn.toolTipText = dp.location.tooltips.back;
			forward_btn.toolTipText = dp.location.tooltips.forward;
			reload_btn.toolTipText = dp.location.tooltips.reload;
			cancel_btn.toolTipText = dp.location.tooltips.cancel;
			bookmark_btn.toolTipText = dp.location.tooltips.bookmark;
			home_btn.toolTipText = dp.location.tooltips.home;
		}
		
		public function get settings():XML
		{
			return _settings;
		}
	}
}