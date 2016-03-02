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
	import com.dancarrdesign.controls.DynamicButton;
	
	/**********************************
	 * The ScrollHandle class extends the DynamicButton class
	 * to create a vertical or horizontal handle for a scrollbar...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class ScrollHandle extends DynamicButton
	{
		//***************************
		// Properties:
		
		private var _vertical:Boolean = true;
		
		//*****************************
		// Constructor:
		
		public function ScrollHandle():void
		{
			// Initialize...
		}
		
		//*****************************
		// Public Methods:
		
		public override function setSize(w:Number, h:Number):void
		{
			if ( _vertical )
			{
				corner1_skin.y = 0;
				middle_skin.height = Math.max(20, h - (corner1_skin.height + corner2_skin.height));
				middle_skin.y = corner1_skin.height - 1;
				corner2_skin.y = middle_skin.y + middle_skin.height - 1;
				icon_skin.y = Math.floor(middle_skin.y + (middle_skin.height - icon_skin.height) / 2);
			}
			else{
				corner1_skin.x = 0;
				middle_skin.width = Math.max(20, w - (corner1_skin.width + corner2_skin.width));
				middle_skin.x = corner1_skin.width - 1;
				corner2_skin.x = middle_skin.x + middle_skin.width - 1;
				icon_skin.x = Math.floor(middle_skin.x + (middle_skin.width - icon_skin.width) / 2);
			}
			// Call super...
			super.setSize(w, h);
		}
		
		//*****************************
		// Public Properties:
		
		public function set vertical(b:Boolean):void
		{
			_vertical = b;
		}
		
		public function get vertical():Boolean
		{
			return _vertical;
		}
	}
}