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
	import com.dancarrdesign.controls.ScrollHandle;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**********************************
	 * The ScrollBar class extends the AIRUIComponent class
	 * to create a vertical or horizontal scrollbar...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class ScrollBar extends AIRUIComponent
	{
		//***************************
		// Properties:
		
		private var _direction:Boolean = true;
		private var _dragging:Boolean = false;
		private var _margin:Number = 15;
		private var _percent:Number = 0;
		private var _scrollH:int = 0;
		private var _scrollV:int = 0;
		private var _scrollMin:Number = 0;
		private var _scrollMax:Number = 0;
		private var _scrolling:Boolean = false;
		private var _vertical:Boolean = true;
		
		// Assets
		private var handleBtn:ScrollHandle;
		
		//*****************************
		// Constructor:
		
		public function ScrollBar():void
		{
			// Initialize...
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//*****************************
		// Events:
		
		protected function addedToStageHandler(event:Event):void
		{
			// Setup events...
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnPressHandler);
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnPressHandler);
			track_mc.addEventListener(MouseEvent.MOUSE_DOWN, trackPressHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			if( _scrolling ){
				if( _dragging ){
					if( vertical ){
						_percent = Math.round(((handleBtn.y - upBtn.height) / (getScrolLArea() - handleBtn.height)) * 100);
					}else{
						_percent = Math.round(((handleBtn.x - upBtn.width) / (getScrolLArea() - handleBtn.width)) * 100);
					}
				}else{
					if( _direction ){
						percent = Math.min(100,(percent+2));
					}else{
						percent = Math.max(0,(percent-2));
					}
				}
				dispatchEvent(new Event("change"));
			}
		}
		
		protected function btnPressHandler(event:MouseEvent):void
		{
			_direction = !( event.currentTarget == upBtn );
			setScroll(true);
		}
		
		protected function trackPressHandler(event:MouseEvent):void
		{
			if( vertical ){
				_direction = !( root.mouseY < handleBtn.y );
			}else{
				_direction = !( root.mouseX < handleBtn.x );
			}
			setScroll(true);
		}
		
		protected function releaseHandler(event:MouseEvent):void
		{
			dragReleaseHandler();
		}
		
		protected function dragPressHandler(event:MouseEvent):void
		{
			var rx:Number = 0;
			var ry:Number = 0;
			var rw:Number = 0;
			var rh:Number = 0;
			
			// Constrain area
			if( _vertical )
			{
				rx = handleBtn.x;
				ry = upBtn.height;
				rh = getScrolLArea() - handleBtn.height;
			}
			else{
				rx = upBtn.width;
				ry = handleBtn.y;
				rw = getScrolLArea() - handleBtn.width;
			}
			var rect:Rectangle = new Rectangle(rx, ry, rw, rh);
			
			// Drag it!
			_dragging = true;
			setScroll(true);
			handleBtn.startDrag(false, rect);
		}
		
		protected function dragReleaseHandler(event:MouseEvent=null):void
		{
			if( _scrolling ){
				_dragging = false;
				setScroll(false);
				handleBtn.stopDrag();
			}
		}
		
		//*****************************
		// Public Methods:
		
		public function getScrolLArea():Number
		{
			if( _vertical ){
				return (track_mc.height - upBtn.height - downBtn.height);
			}else{
				return (track_mc.width - upBtn.width - downBtn.width);
			}
		}
		
		public function setScroll(b:Boolean):void
		{
			if( _scrolling != b ){
				if( b ) {
					addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}else {
					removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
				_scrolling = b;
			}
		}
		
		public function setHandle():void
		{
			// Create button if needed...
			if ( handleBtn == null ) {
				if( vertical ){
					handleBtn = new vScrollHandle();
				}else{
					handleBtn = new hScrollHandle();
				}
				handleBtn.vertical = vertical;
				handleBtn.x = vertical ? 1 : _margin;
				handleBtn.y = vertical ? _margin : 0;
				handleBtn.addEventListener(MouseEvent.MOUSE_DOWN, dragPressHandler);
				handleBtn.addEventListener(MouseEvent.MOUSE_UP, dragReleaseHandler);
				
				addChild(handleBtn);
			}
			
			// Size and layout...
			var area:Number = getScrolLArea();
			var size:Number = Math.max(15, (area * (_scrollMin / _scrollMax)));
			if( vertical ){
				handleBtn.setSize(handleBtn.width, size);
				handleBtn.visible = ( handleBtn.height < area );
			}else{
				handleBtn.setSize(size, handleBtn.height);
				handleBtn.visible = ( handleBtn.width < area );
			}
			// Redraw
			percent = _percent;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if ( _vertical ) {
				downBtn.y = h - downBtn.height;
			}else{
				downBtn.x = w - downBtn.width;
			}
			track_mc.width = w;
			track_mc.height = h;
			
			// Update handle...
			setHandle();
		}
		
		//*****************************
		// Public Properties:
		
		//----------------
		// percent
		
		public function set percent(i:Number):void
		{
			if( handleBtn )
			{
				if( _vertical ){
					handleBtn.y = upBtn.height + ((getScrolLArea() - handleBtn.height) * (i / 100));
				}else{
					handleBtn.x = upBtn.width + ((getScrolLArea() - handleBtn.width) * (i / 100));
				}
			}
			_percent = i;
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		//----------------
		// scrollMin
		
		public function set scrollMin(i:Number):void
		{
			_scrollMin = i;
		}
		
		public function get scrollMin():Number
		{
			return _scrollMin;
		}
		
		//----------------
		// scrollMax
		
		public function set scrollMax(i:Number):void
		{
			_scrollMax = i;
		}
		
		public function get scrollMax():Number
		{
			return _scrollMax;
		}
		
		//----------------
		// vertical
		
		public function set vertical(b:Boolean):void
		{
			if( handleBtn ){
				handleBtn.vertical = b;
			}
			_vertical = b;
		}
		
		public function get vertical():Boolean
		{
			return _vertical;
		}
		
		//----------------
		// READ-ONLY:
		
		public function get direction():Boolean
		{
			return _direction;
		}
		
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		public function get scrolling():Boolean
		{
			return _scrolling;
		}
	}
}