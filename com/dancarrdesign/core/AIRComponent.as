/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.core 
{
	import flash.display.MovieClip;
	
	/**********************************
	 * The AIRComponent class extends the MovieClip class
	 * and acts as a base class for all classes in the framework.
	 * Non-visual components subclass this object directly to
	 * gain the ability to integrate with movie clips and components
	 * features in a Flash CS4 library.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRComponent extends MovieClip
	{
		//*****************************
		// Constants:
		
		public static const version:String = "AIRComponent 1.0.0";
		
		//*****************************
		// Properties:
		
		protected var _id:String;
		
		//*****************************
		// Constructor:
		
		public function AIRComponent():void
		{
			//trace("INIT : " + this.name);
		}
		
		//*****************************
		// Public API:
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(str:String):void
		{
			_id = str;
		}
	}
}