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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**********************************
	 * The DynamicButton class extends the AIRUIComponent class
	 * to create a button with dynamically generated button states...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class DynamicButton extends AIRUIComponent
	{
		//*****************************
		// Properties:
		
		protected var _defaultStateAlpha:Number = 0;
		protected var _downStateAlpha:Number = .45;
		protected var _overStateAlpha:Number = .20;
		protected var _tintAlpha:Number = 0.75;
		protected var _tintColor:Number = 0x999999;
		
		// Tint state
		protected var tint_mc:Sprite;
		
		//*****************************
		// Constructor:
		
		public function DynamicButton():void
		{
			// Initialize...
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePressHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseReleaseHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//*****************************
		// Events:
		
		protected function addedToStageHandler(event:Event=null):void
		{
			// Create tint rectangle
			if( tint_mc == null ){
				tint_mc = new Sprite();
				addChild(tint_mc);
			}
			tint_mc.graphics.clear();
			tint_mc.graphics.beginFill(_tintColor, _tintAlpha);
			tint_mc.graphics.drawRect(0, 0, width, height);
			tint_mc.graphics.endFill();
			tint_mc.alpha = defaultStateAlpha;
		}
		
		protected function onMouseOverHandler(event:MouseEvent):void
		{
			if( enabled ){
				// OVER
				tint_mc.alpha = overStateAlpha;
			}
		}
		
		protected function onMouseOutHandler(event:MouseEvent):void
		{
			if( enabled ){
				// OUT
				tint_mc.alpha = defaultStateAlpha;
			}
		}
		
		protected function onMousePressHandler(event:MouseEvent):void
		{
			if( enabled ){
				// PRESS
				tint_mc.alpha = downStateAlpha;
			}
		}
		
		protected function onMouseReleaseHandler(event:MouseEvent):void
		{
			if( enabled ){
				// RELEASE
				tint_mc.alpha = overStateAlpha;
			}
		}
		
		//*****************************
		// Public Methods:
		
		public function setSize(w:Number, h:Number):void
		{
			tint_mc.width = w;
			tint_mc.height = h;
		}
		
		//*****************************
		// Public Properties:
		
		//----------------
		// defaultStateAlpha
		
		public function set defaultStateAlpha(i:Number):void
		{
			_defaultStateAlpha = i;
		}
		
		public function get defaultStateAlpha():Number
		{
			return _defaultStateAlpha;
		}
		
		//----------------
		// downStateAlpha
		
		public function set downStateAlpha(i:Number):void
		{
			_downStateAlpha = i;
		}
		
		public function get downStateAlpha():Number
		{
			return _downStateAlpha;
		}
		
		//----------------
		// overStateAlpha
		
		public function set overStateAlpha(i:Number):void
		{
			_overStateAlpha = i;
		}
		
		public function get overStateAlpha():Number
		{
			return _overStateAlpha;
		}
		
		//----------------
		// tintAlpha
		
		public function set tintAlpha(i:Number):void
		{
			_tintAlpha = i;
		}
		
		public function get tintAlpha():Number
		{
			return _tintAlpha;
		}
		
		//----------------
		// tintColor
		
		public function set tintColor(i:Number):void
		{
			_tintColor = i;
			addedToStageHandler();
		}
		
		public function get tintColor():Number
		{
			return _tintColor;
		}
	}
}