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
	 * The HTMLChrome class extends the AIRUIComponent class
	 * to create a scalable frame around the edge of the window...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class HTMLChrome extends AIRUIComponent
	{
		//***************************
		// Properties:
		
		private var _innerX:Number = 0;
		private var _innerY:Number = 0;
		private var _innerWidth:Number = 0;
		private var _innerHeight:Number = 0;
		
		//***************************
		// Constructor:
		
		public function HTMLChrome() 
		{
			// Size ourselves
			setSize(_preferredWidth, _preferredHeight);
		}
		
		//*****************************
		// Public Methods:
		
		public function setSize(w:Number, h:Number):void
		{
			// Update properties...
			_innerWidth = w - (chrome_left.width + chrome_right.width);
			_innerHeight = h - (chrome_top.height + chrome_bottom.height);
			_innerX = chrome_left.width;
			_innerY = chrome_top.height;
			
			// Size skins...
			line_mc.width = w;
			chrome_top.width = w;
			chrome_left.height = _innerHeight;
			chrome_right.height = _innerHeight;
			chrome_right.x = w - chrome_right.width;
			chrome_bottom.y = h - chrome_bottom.height;
			chrome_bottom.width = w;
		}
		
		//*****************************
		// Public Properties:
		
		//----------------
		// innerWidth
		
		public function get innerWidth():Number
		{
			return _innerWidth;
		}
		
		//----------------
		// innerHeight
		
		public function get innerHeight():Number
		{
			return _innerHeight;
		}
		
		//----------------
		// innerX
		
		public function get innerX():Number
		{
			return _innerX;
		}
		
		//----------------
		// innerY
		
		public function get innerY():Number
		{
			return _innerY;
		}
		
		//----------------
		// innerBounds
		
		public function get innerBounds():Rectangle
		{
			return new Rectangle(innerX, innerY, innerWidth, innerHeight);
		}
	}
}