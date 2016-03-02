/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed unde the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.utils
{
	import com.dancarrdesign.core.AIRComponent;
	import com.dancarrdesign.html.HTMLPane;
	import com.dancarrdesign.utils.AIRNativeWindowAlign;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindow;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
    import flash.net.URLRequest;
	import flash.system.Capabilities;
		
	/**********************************
	 * The AIRNativeWindow class extends the AIRComponent class
	 * and creates a simple control for spawning native windows
	 * filled with content.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRNativeWindow extends AIRComponent
	{
		//*****************************
		// Properties:
		
		private var _htmlLoader:HTMLLoader;
		private var _loader:Loader;
		private var _source:String;
		private var _title:String;
		private var _useHTMLLoader:Boolean = true;
		
		// Layout:
		private var _popupAlign:String = AIRNativeWindowAlign.MIDDLE_CENTER;
		private var _popupHeight:Number = 10;
		private var _popupWidth:Number = 10;
		private var _popupX:Number = 0;
		private var _popupY:Number = 0;
		
		// Window:
		private var _window:NativeWindow;
		private var _windowOptions:NativeWindowInitOptions;
		
		//*****************************
		// Constructor:
		
		public function AIRNativeWindow():void
		{
			// Set window options
			_windowOptions = new NativeWindowInitOptions();
			_windowOptions.systemChrome = NativeWindowSystemChrome.STANDARD;
			_windowOptions.type = NativeWindowType.NORMAL;
		}
		
		//*****************************
		// Events:
		
		protected function onResizeHandler(event:Event):void
		{
			if( _window.stage ){
				_popupWidth = _window.stage.stageWidth;
				_popupHeight = _window.stage.stageHeight;
				
				if( useHTMLLoader && _htmlLoader ){
					_htmlLoader.width = _popupWidth;
					_htmlLoader.height = _popupHeight;
				}
			}
		}
		
		protected function onHttpCompleteHandler(event:Event):void
		{
			// Relay event...
			dispatchEvent(event.clone());
		}
		
		//*****************************
		// Private Methods:
		
		protected function createWindow():void 
		{
			// Create a new window, set its options, set its size, and activate it
			_window = new NativeWindow(_windowOptions);
			_window.stage.scaleMode = StageScaleMode.NO_SCALE;
			_window.stage.align = StageAlign.TOP_LEFT;
			_window.stage.addEventListener(Event.RESIZE, onResizeHandler);
			_window.bounds = new Rectangle(_popupX, _popupY, _popupWidth, _popupHeight);
			_window.title = _title;
			_window.activate();
			
			if( useHTMLLoader ){
				loadHTTP(_source);
			}else {
				loadFile(_source);
			}
		}
		
		protected function setAlignment():void 
		{
			var screenWidth = Capabilities.screenResolutionX;
            var screenHeight = Capabilities.screenResolutionY;
			var YCenter = (screenHeight/2) - (_popupHeight/2);
			var YBottom = screenHeight - _popupHeight;
			var XCenter = (screenWidth/2) - (_popupWidth/2);
			var XRight = screenWidth - _popupWidth;
			var YTop 	= 0;
			var XLeft 	= 0
			
			switch(_popupAlign)
			{
				case AIRNativeWindowAlign.TOP_LEFT:
					_popupY = YTop
					_popupX = XLeft;
					break;
					
				case AIRNativeWindowAlign.TOP_CENTER:
					_popupY = YTop;
					_popupX = XCenter;
					break;
					
				case AIRNativeWindowAlign.TOP_RIGHT:
					_popupY = YTop;
					_popupX = XRight;
					break;
				
				case AIRNativeWindowAlign.MIDDLE_LEFT:
					_popupY = YCenter;			
					_popupX = XLeft;
					break;
					
				case AIRNativeWindowAlign.MIDDLE_CENTER:
					_popupY = YCenter;			
					_popupX = XCenter;
					break;
					
				case AIRNativeWindowAlign.MIDDLE_RIGHT:
					_popupY = YCenter;								
					_popupX = XRight;
					break;
				
				case AIRNativeWindowAlign.BOTTOM_LEFT:
					_popupY = YBottom;			
					_popupX = XLeft;
					break;
					
				case AIRNativeWindowAlign.BOTTOM_CENTER:
					_popupY = YBottom;			
					_popupX = XCenter;
					break;
					
				case AIRNativeWindowAlign.BOTTOM_RIGHT:
					_popupY = YBottom;								
					_popupX = XRight;
					break;
			}
		}
		
		//*****************************
		// Public Methods:
		
		// Public method to set the layout. Pass in
		// a width, height and PopupAlign static const
		
		public function layout(width:Number, height:Number, align:String):void
		{
			_popupWidth = width;
			_popupHeight = height;
			_popupAlign = align;
			
			// Draw...
			setAlignment();
		}
		
		// Public method for showing the popup
		
		public function activate():void 
		{
			// if no window create one
			if(!_window){
				createWindow();
			}else{
				// If we have a window check to see if it is closed
				if(_window.closed){
					createWindow();
				}else{
					// Activate if it is not closed
					_window.activate();
				}
			}
		}
		
		public function loadHTTP(path:String):void
		{
			_htmlLoader = new HTMLLoader();
			_htmlLoader.width = _popupWidth;
			_htmlLoader.height = _popupHeight;
			_htmlLoader.addEventListener(Event.COMPLETE, onHttpCompleteHandler);
            _htmlLoader.load(new URLRequest(path)); 
			
			// If popup is used as a common container make
			// sure there is only one child loaded at a time
			if( _window.stage.numChildren == 1 ){
				_window.stage.removeChildAt(0);
			}else{
           		_window.stage.addChild(_htmlLoader);
			}
		}
		
		public function loadFile(file:String):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onHttpCompleteHandler);
            _loader.load(new URLRequest(file));
			
			// If popup is used as a common container make
			// sure there is only one child loaded at a time
			if( _window.stage.numChildren == 1 ){
				_window.stage.removeChildAt(0);
			}else{
				_window.stage.addChild(_loader);
			}
		}
		
		public function close():void
		{
			if( _window ){
				_window.close();
			}
		}
		
		//*****************************
		// Public Properties:
		
		//--------------
		// title
		
		public function get title(): String 
		{ 
			return _title; 
		}
		
		[Inspectable(defaultValue="My Window")]
		public function set title(val: String): void 
		{
			if( _window ){
				_window.title = val;
			}
			_title = val; 
		}
		
		//--------------
		// source
		
		public function get source():* 
		{ 
			return _source; 
		}
		
		[Inspectable(defaultValue="")]
		public function set source(val:*):void 
		{ 
			if( _window){
				loadHTTP(val)
			}
			_source = val;
		}
		
		//--------------
		// windowOptions
		
		public function get windowOptions():* 
		{ 
			return _windowOptions; 
		}
		
		public function set windowOptions(val:NativeWindowInitOptions): void 
		{ 
			if( _window ){
				_window.close();
				createWindow();
			}
			_windowOptions = val;
		}
		
		//--------------
		// popupX
		
		// These are provided for further functionality
		// all can be set with the public Layout method.
		
		public function get popupX():Number 
		{ 
			return _popupX; 
		}
		
		[Inspectable(defaultValue=0)]
		public function set popupX(val: Number):void 
		{
			if( _window ){
				_window.x = val;
			}
			_popupX = val; 
		}
		
		//--------------
		// popupY
		
		public function get popupY():Number 
		{ 
			return _popupY; 
		}
		
		[Inspectable(defaultValue=0)]
		public function set popupY(val:Number): void 
		{
			if( _window ){
				_window.y = val;
			}
			_popupY = val; 
		}
		
		//--------------
		// popupWidth
		
		[Inspectable(defaultValue=400)]
		public function get popupWidth():Number 
		{ 
			return _popupWidth; 
		}
		
		public function set popupWidth(val: Number): void 
		{
			if( _window ){
				_window.width = val;
			}
			_popupWidth = val; 
		}
		
		//--------------
		// popupHeight
		
		public function get popupHeight():Number 
		{ 
			return _popupHeight; 
		}
		
		[Inspectable(defaultValue=300)]
		public function set popupHeight(val:Number): void 
		{
			if( _window ){
				_window.height = val;
			}
			_popupHeight = val; 
		}
		
		//--------------
		// popupAlign
		
		public function get popupAlign():String 
		{ 
			return _popupAlign; 
		}
			
		[Inspectable(defaultValue="middleMiddle", type="list", enumeration="topLeft","topCenter","topRight","middleLeft","middleCenter","middleRight","bottomLeft","bottomCenter","bottomRight")]
		public function set popupAlign(val: String): void 
		{
			if( _window ){
				setAlignment();
			}
			_popupAlign = val; 
		}
		
		//--------------
		// useHTMLLoader
		
		public function get useHTMLLoader():Boolean 
		{ 
			return _useHTMLLoader; 
		}
			
		[Inspectable(defaultValue=true)]
		public function set useHTMLLoader(b:Boolean): void 
		{
			_useHTMLLoader = b; 
		}
	}
}