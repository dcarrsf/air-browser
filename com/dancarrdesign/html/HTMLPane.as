/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.html 
{
	import com.dancarrdesign.core.AIRUIComponent;
	import com.dancarrdesign.events.*;
	import com.dancarrdesign.events.types.*;
	import com.dancarrdesign.html.HTMLCustomHost;
	import flash.desktop.*;
	import flash.display.*;    
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.html.*;
	import flash.utils.*;
	
	/**********************************
	 * The HTMLPane class extends the AIRUIComponent class
	 * to create a scrollable HTML window...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class HTMLPane extends AIRUIComponent
	{
		//***************************
		// Properties:
		
		private var _html:HTMLLoader;
		private var _htmlCustomHost:HTMLCustomHost;
		private var _margin:Number = 15;
		private var _scrollH:int = 0;
		private var _scrollV:int = 0;
		private var _scrollArea:Rectangle;
		private var _scrollActivated:Boolean = true;
		private var _source:String = "";
		private var _timeoutMonitor:uint;
		private var _timeoutLimit:uint = 30000;
		
		//*****************************
		// Constructor:
		
		public function HTMLPane():void
		{
			// Vertical scrollbar
			vScroll.visible = false;
			vScroll.vertical = true;
			vScroll.addEventListener(Event.CHANGE, scrollBarHandler);
			
			// Horizontal scrollbar
			hScroll.visible = false;
			hScroll.vertical = false;
			hScroll.addEventListener(Event.CHANGE, scrollBarHandler);
		}
		
		//*****************************
		// Events:
		
		protected function htmlEventHandler(event:Event):void
		{
			// Populate info object with properties if needed...
			var info:XML = <info/>;
			
			// Process and relay events...
			switch( event.type )
			{
				case "complete":
				
					// Page has loaded...
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.COMPLETE, info));
					break;
				
				case "htmlDOMInitialize":
				
					// Clear timeout interval
					clearTimeout(_timeoutMonitor);
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.DOM_INITIALIZE, info));
					break;
				
				case "htmlBoundsChange":
				
					// Bounds area changed...
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.BOUNDS_CHANGE, info));
					break;
				
				case "locationChange":
				
					// Page location change...
					dispatchEvent(new AIRLocationEvent(AIRLocationEventType.LOCATION_CHANGE, info));
					break;
			}
		}
		
		protected function htmlScriptExceptionHandler(event:HTMLUncaughtScriptExceptionEvent):void
		{
			event.preventDefault(); 
			
			// Relay event...
			dispatchEvent(new AIRErrorEvent("unhandledException", event.exceptionValue));
		}
		
		protected function scrollBarHandler(event:Event):void
		{
			var scrollHeight:Number = _html.contentHeight - _html.height;
			var scrollWidth:Number = _html.contentWidth - _html.width;
			
			// Update html position...
			_html.scrollV = scrollHeight * (vScroll.percent / 100);
			_html.scrollH = scrollWidth * (hScroll.percent / 100);
		}
		
		protected function scrollHandler(event:Event):void
		{
			var scrollHeight:Number = _html.contentHeight - _html.height;
			var scrollWidth:Number = _html.contentWidth - _html.width;
			
			// Update scrollbar positions...
			vScroll.percent = (_html.scrollV / scrollHeight) * 100;
			hScroll.percent = (_html.scrollH / scrollWidth) * 100;
		}
		
		//*****************************
		// Public Methods:
		
		public function setSize(w:Number, h:Number):void
		{
			if( _html && vScroll && hScroll ) 
			{
				// With scrollbars...
				if( w <= _html.contentWidth - (_margin*2) || 
					h <= _html.contentHeight - (_margin*2) )
				{
					_scrollActivated = true;
					_scrollArea = new Rectangle(0, 0, w-_margin, h-_margin);
				}
				// Without scrollbars...
				else {
					_scrollActivated = false;
					_scrollArea = new Rectangle(0, 0, w, h);
				}
				// HTMLLoader
				_html.width =  _scrollArea.width + 1;
				_html.height = _scrollArea.height - 1;
				
				// Vertical scrollbar
				vScroll.x = _html.width;
				vScroll.y = _html.y - 1;
				vScroll.scrollMin = _html.height;
				vScroll.scrollMax = _html.contentHeight;
				vScroll.visible = _scrollActivated;
				vScroll.mouseEnabled = _scrollActivated;
				vScroll.setSize(_margin, _html.height+1);
				
				// Horizontal scrollbar
				hScroll.y = _html.height - 1;
				hScroll.scrollMin = _html.width;
				hScroll.scrollMax = _html.contentWidth;
				hScroll.visible = _scrollActivated;
				hScroll.mouseEnabled = _scrollActivated;
				hScroll.setSize(_html.width+1, _margin);
				
				// Corner
				corner.x = hScroll.width;
				corner.y = vScroll.height;
				
				// Update scrollbar positions...
				vScroll.percent = (_html.scrollV / _html.contentHeight) * 100;
				hScroll.percent = (_html.scrollH / _html.contentWidth) * 100;
				
				// Update internal size values
				_preferredWidth = w;
				_preferredHeight = h;
			}
		}
		
		//----------------
		// URL Loading:
		
		private function timeoutHandler( pane:HTMLPane ):void
		{
			with( pane ) {
				// Cancel request...
				cancel();
				dispatchEvent(new AIRErrorEvent("timeOut", ""));
			}
		}
		
		public function load(url:String):void
		{
			if( _html == null )
			{
				// Eevnts...
				_htmlCustomHost = new HTMLCustomHost();
				_html = new HTMLLoader();
				_html.htmlHost = _htmlCustomHost;
				_html.addEventListener(Event.SCROLL, scrollHandler);
				_html.addEventListener(Event.COMPLETE, htmlEventHandler);
				_html.addEventListener(Event.LOCATION_CHANGE, htmlEventHandler);
				_html.addEventListener(Event.HTML_BOUNDS_CHANGE, htmlEventHandler);
				_html.addEventListener(Event.HTML_DOM_INITIALIZE, htmlEventHandler);
				_html.addEventListener(HTMLUncaughtScriptExceptionEvent.UNCAUGHT_SCRIPT_EXCEPTION, htmlScriptExceptionHandler);
				
				addChild(_html);
			}
			_html.load(new URLRequest(url));
			
			// Error if not loaded in timeout limit...
			_timeoutMonitor = setTimeout(timeoutHandler, _timeoutLimit, this);
			
			// Set size to layout ourselves
			setSize(_preferredWidth, _preferredHeight);
		}
		
		public function refresh():void
		{
			_html.reload();
		}
		
		public function cancel():void
		{
			_html.cancelLoad();
		}
		
		//----------------
		// History:
		
		public function getHistoryAt(i:uint):HTMLHistoryItem
		{
			return _html.getHistoryAt(i);
		}
		
		public function historyBack():void
		{
			_html.historyBack();
		}
		
		public function historyForward():void
		{
			_html.historyForward();
		}
		
		public function historyGo(i:uint):void
		{
			_html.historyGo(i);
		}
		
		//*****************************
		// Public Properties:
		
		//----------------
		// scrollArea
		
		public function set scrollArea(r:Rectangle):void
		{
			_scrollArea = r;
		}
		
		public function get scrollArea():Rectangle
		{
			return _scrollArea;
		}
		
		//----------------
		// source
		
		[Inspectable(defaultValue="")]
		public function set source(src:String):void
		{
			_source = src;
			load(src);
		}
		
		public function get source():String
		{
			return _source;
		}
		
		//----------------
		// _timeoutLimit
		
		public function set timeoutLimit(i:Number):void
		{
			_timeoutLimit = i;
		}
		
		[Inspectable(defaultValue=30)]
		public function get timeoutLimit():Number
		{
			return _timeoutLimit;
		}
		
		//----------------
		// READ-ONLY:

		public function get historyLength():uint
		{
			return _html.historyLength;
		}
		
		public function get historyPosition():uint
		{
			return _html.historyPosition;
		}
		
		public function get host():HTMLLoader
		{
			return _html;
		}
		
		public function get loaded():Boolean
		{
			return _html.loaded;
		}
		
		public function get location():String
		{
			return _html.location;
		}
		
		public function get scrollActivated():Boolean
		{
			return _scrollActivated;
		}
	}
}