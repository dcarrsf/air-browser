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
	import com.dancarrdesign.events.AIRMenuEvent;
	import flash.desktop.*;
	import flash.display.*;    
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	/**********************************
	 * The AIRNativeMenu class extends the AIRComponent class
	 * and creates an XML-driven wrapper around the AIR NativeMenu
	 * ActionScript API...
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRNativeMenu extends AIRComponent
	{
		//*****************************
		// Properties:
		
		protected var _baseMenu:NativeMenu;
		protected var _checkItems:Object = new Object();
		protected var _menus:Object = new Object();
		protected var _source:XML;
		
		//*****************************
		// Constructor:
		
		public function AIRNativeMenu():void
		{
			// On Mac we need a path to the stage
			// so we need to monitor whether we're
			// on the display list or not to avoid errors...
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//*****************************
		// Events:
		
		public function addedToStageHandler(event:Event):void 
		{
			// Create base menu. This menu is
			// invisible. It's used to create a
			// menubar anchor for the top level
			// of visible menus...
			_baseMenu = new NativeMenu();
			_baseMenu.addEventListener(Event.SELECT, selectionHandler);
				
			// We're ready to add submenus and menu 
			// items at this point...
			// Assign menu to Windows
			if( NativeApplication.supportsMenu ){
				NativeApplication.nativeApplication.menu = _baseMenu;
			}
			// Assign menu to Mac
			if( NativeWindow.supportsMenu ){
				stage.nativeWindow.menu = _baseMenu;
			}
			// If we have XML queued and waiting to 
			// be drawn to the screen, then draw it now...
			if( source != null ) {
				setSource(_source);
			}
		}
		
		protected function selectionHandler(event:Event):void 
		{
			var item:NativeMenuItem = event.target as NativeMenuItem;
			
			// Handle check toggles
			if( checkItems[item.name] != null ){
				item.checked = !item.checked;
			}
			// Dispatch a custom event with a reference to
			// the NativeMenuItem...
			dispatchEvent(new AIRMenuEvent(item));
		}
		
		//*****************************
		// Private Methods:
		
		protected function setSource(src:XML):void
		{
			if( stage != null )
			{
				var menuArr:XMLList = src.menu;
				var len:uint = menuArr.length();
				
				// Build menu...
				for(var n:uint = 0; n < len; n++){
					addMenu(_baseMenu, menuArr[n]);
				}
			}
			_source = src;
		}
		
		//*****************************
		// Public Methods:
		
		public function addMenu(anchor:NativeMenu, src:XML):void 
		{
			// Create menu
			var menu:NativeMenu = new NativeMenu();
			var menuItems:XMLList = src.items.item;
			var len:uint = menuItems.length();
			
			// Save reference
			_menus[src.name] = menu;
			
			// Add items...
			for(var i:uint = 0; i < len; i++){
				addMenuItem(menu, menuItems[i]);
			}
			anchor.addSubmenu(menu, src.label.text());
		}
		
		public function addMenuItem(menu:NativeMenu, src:XML):void 
		{
			var item:NativeMenuItem;
			
			// 1. Add seperator
			if( src.hasOwnProperty("isSeparator") ){
				item = new NativeMenuItem("", true);
				menu.addItem(item);
			}
			// 2. Add submenu
			else if ( src.hasOwnProperty("menu") ){
				addMenu(menu, new XML(src.menu));
			}
			// 3. Add item
			else {
				item = new NativeMenuItem();
				item.name = src.name.text();
				item.label = src.label.text();
				item.enabled = (src.enabled.text() == "1");
				item.checked = (src.checked.text() == "1");
				item.keyEquivalent = src.keyEquivalent.text();
				item.data = src.data;
				
				// Cache checks
				if( src.checked.text() == "0" || 
					src.checked.text() == "1" ) {
					checkItems[src.name.text()] = true;
				}
				// Set key modifiers
				if( src.keyEquivalentModifiers == undefined )
				{
					// Don't use key modifiers
					item.keyEquivalentModifiers = new Array();
				}
				else{
					// Add key modifiers...
					var modArr:Array = String(src.keyEquivalentModifiers).split(",");
					var keyArr:Array = new Array();
					var len:uint = modArr.length;
					for(var n:uint = 0; n < len; n++){
						switch( modArr[n] )
						{
							case "ALTERNATE":
								keyArr.push(Keyboard.ALTERNATE);
								break;
							case "COMMAND":
								keyArr.push(Keyboard.COMMAND);
								break;
							case "CONTROL":
								keyArr.push(Keyboard.CONTROL);
								break;
						}
					}
					item.keyEquivalentModifiers = keyArr;
				}
				menu.addItem(item);
			}
		}
		
		public function getMenuByName(mName:String)
		{
			return _menus[mName];
		}
		
		public function toggleCheck(menu:String, menuItem:String, b:Boolean):void
		{
			var target:NativeMenu = getMenuByName(menu);
			var item:NativeMenuItem = target.getItemByName(menuItem);
			item.checked = b;
		}
		
		public function toggleState(menu:String, menuItem:String, b:Boolean):void
		{
			var target:NativeMenu = getMenuByName(menu);
			var item:NativeMenuItem = target.getItemByName(menuItem);
			item.enabled = b;
		}
		
		//*****************************
		// Public API:
		
		//-------------------
		// checkItems
		
		public function set checkItems(ckArr:Object):void 
		{
			_checkItems = ckArr;
		}
		
		public function get checkItems():Object
		{
			return _checkItems;
		}
		
		//-------------------
		// source
		
		[Inspectable(defaultValue="")]
		public function set source(xmlSrc:XML):void 
		{
			setSource(xmlSrc);
		}
		
		public function get source():XML
		{
			return _source;
		}
		
		// READ-ONLY
		//-------------------
		// baseMenu
		
		public function get menus():Object
		{
			return _menus;
		}
		
		public function get baseMenu():NativeMenu
		{
			return _baseMenu;
		}
	}
}