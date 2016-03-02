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
	import com.dancarrdesign.utils.AIRNativeMenu;
	import flash.display.NativeMenu;    
	import flash.events.Event;

	/**********************************
	 * The AIRContextMenu class extends the AIRNativeMenu class
	 * to create a native menu associated with a display object's
	 * contentMenu property.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 */
	public class AIRContextMenu extends AIRNativeMenu
	{
		//*****************************
		// Constructor:
		
		public function AIRContextMenu():void
		{
			// Initialize...
		}
		
		//*****************************
		// Events:
		
		// We are on the stage.
		public override function addedToStageHandler(event:Event):void 
		{
			// Create a new base NativeMenu to add items to.
			_baseMenu = new NativeMenu();
			
			//  Listen for menu item selections.
			_baseMenu.addEventListener(Event.SELECT, selectionHandler);
		
			// Add the new NativeMenu to the contextMenu property of this component.
			this.contextMenu = _baseMenu;
			
			// If we have a source XML file set then call setSource to build the menu
			if( _source != null ) {
				setSource(_source);
			}
		}
		
		//*****************************
		// Private Methods:
		
		protected override function setSource(src:XML):void
		{
			// If we are on the stage build the menu and set the _source.
			if( stage != null ) {
				
				// Create an XMLList and get its length.
				var itemsArr:XMLList = src.item;
				var len:uint = itemsArr.length();
				
				// Build menu...
				for(var n:uint = 0; n < len; n++){
					addMenuItem(_baseMenu, itemsArr[n]);
				}
			}
			_source = src;
		}
	}
}