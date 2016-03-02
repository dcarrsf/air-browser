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
	import flash.display.*;    
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.html.*;
	
	/**********************************
	 * The HTMLCustomHost class extends HTMLHost
	 * to create custom behavior for the HTMLLoader
	 * instance in the HTMLPane component. 
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class HTMLCustomHost extends HTMLHost
	{ 
		//***************************
		// Properties:
		
		private var _defaultWindowX:Number = 0;
		private var _defaultWindowY:Number = 0;
		private var _defaultWindowWidth:Number = 800;
		private var _defaultWindowHeight:Number = 600;
		
		//*****************************
		// Constructor:
		
		public function HTMLCustomHost(defaultBehaviors:Boolean=true) 
        { 
            super(defaultBehaviors); 
        } 
		
		//*****************************
		// Overrides:
		
        override public function windowClose():void 
        { 
            htmlLoader.stage.nativeWindow.close(); 
        } 
		
        override public function createWindow( windowCreateOptions:HTMLWindowCreateOptions ):HTMLLoader 
        { 
            var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions(); 
			var bounds:Rectangle = new Rectangle(windowCreateOptions.x, windowCreateOptions.y, windowCreateOptions.width, windowCreateOptions.height); 
            var htmlControl:HTMLLoader = HTMLLoader.createRootWindow(true, initOptions, windowCreateOptions.scrollBarsVisible, bounds); 
            htmlControl.htmlHost = new HTMLCustomHost(); 
            if( windowCreateOptions.fullscreen ){ 
                htmlControl.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
            } 
            return htmlControl; 
        } 
		
        override public function updateLocation(locationURL:String):void 
        { 
            // add functionality here...
        } 
		
        override public function set windowRect(value:Rectangle):void 
        { 
            htmlLoader.stage.nativeWindow.bounds = value; 
        } 
		
        override public function updateStatus(status:String):void 
        { 
            // add functionality here...
        } 
		
        override public function updateTitle(title:String):void 
        { 
            htmlLoader.stage.nativeWindow.title = title; 
        } 
		
        override public function windowBlur():void 
        { 
            htmlLoader.alpha = 0.75; 
        } 
		
        override public function windowFocus():void 
        { 
            htmlLoader.alpha = 1; 
        } 
	}
}