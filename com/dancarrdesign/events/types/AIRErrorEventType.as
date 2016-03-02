/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed unde the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 */
package com.dancarrdesign.events.types
{
	/**********************************
	 * The AIRErrorEventType class extends the Object class
	 * to create a list of error type constants...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRErrorEventType extends Object
	{
		//*****************************
		// Constants:
		
		public static const TIME_OUT:String = "timeOut";
		public static const UNHANDLED_EXCEPTION:String = "unhandledException";
		
		//*****************************
		// Constructor:
		
		public function AIRErrorEventType(){}
	}
}