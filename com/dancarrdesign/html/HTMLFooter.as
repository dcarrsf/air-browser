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
	import flash.desktop.*;
	import flash.display.*;    
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**********************************
	 * The HTMLFooter class extends the AIRUIComponent class
	 * to create a scalable status bar...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class HTMLFooter extends AIRUIComponent
	{
		//***************************
		// Properties:
		
		private var _offset:Number = 30;
		private var _status:uint = 0;
		private var _text:String = "";
		private var _settings:XML;
		
		//***************************
		// Constructor:
		
		public function HTMLFooter() 
		{
			// Initialize...
			status_txt.mouseEnabled = false;
			
			// Size ourselves
			setSize(_preferredWidth, _preferredHeight);
		}
		
		//*****************************
		// Public Methods:
		
		public function clearStatus():void
		{
			status_txt.text = "";
			showLoadingAnimation(false);
		}
		
		public function setSize(w:Number, h:Number):void
		{
			line_mc.width = w;
			background_mc.width = w;
			background_mc.height = h;
			loadingIcon_mc.x = w - _offset;
		}
		
		public function setStatus(state:uint, str:String=""):void
		{
			switch( state )
			{
				case 0:
					str = _settings.status.messages.waiting + " " + str;
					break;
				case 1:
					str = _settings.status.messages.done + " " + str;
					break;
				case 2: 
					str = _settings.status.messages.error + " " + str;
					break;
			}
			_text = str;
			_status = state;
			status_txt.text = str;
		}
		
		public function showLoadingAnimation(b:Boolean):void
		{
			loadingIcon_mc.visible = b;
		}
		
		//*****************************
		// Public Properties:
		
		public function set settings(i:XML):void
		{
			_settings = i;
		}
		
		public function get settings():XML
		{
			return _settings;
		}
		
		//----------------
		// READ-ONLY:
		
		public function get status():Number
		{
			return _status;
		}
	}
}