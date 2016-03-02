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
	import com.dancarrdesign.controls.ToolTip;
	import com.dancarrdesign.core.AIRComponent;
	import com.dancarrdesign.events.AIRMenuEvent;
	import com.dancarrdesign.utils.AIRContextMenu;
	import com.dancarrdesign.utils.AIRFileManager;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**********************************
	 * The AIRUIComponent class extends the AIRComponent class
	 * by adding common functionality for visual components in
	 * the framework.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 */
	public class AIRUIComponent extends AIRComponent
	{
		//*****************************
		// Properties:
		
		protected var _contextMenuSource:String;
		protected var _contextMenuLoader:AIRFileManager;
		protected var _contextMenu:AIRContextMenu;
		
		// Layout:
		protected var _preferredWidth:Number = 0;
		protected var _preferredHeight:Number = 0;
		
		// Assets:
		protected var _toolTip:ToolTip;
		
		//*****************************
		// Constructor:
		
		public function AIRUIComponent():void
		{
			// Create file loader...
			_contextMenuLoader = new AIRFileManager();
			
			// Save authortime size
			_preferredWidth = width;
			_preferredHeight = height;
			
			// Reset scale
			scaleX = 1;
			scaleY = 1;
			
			// Events
			addEventListener(MouseEvent.MOUSE_OVER, showToolTip);
			addEventListener(MouseEvent.MOUSE_OUT, hideToolTip);
		}
		
		//*****************************
		// Events:
		
		protected function onContextClickHandler(event:AIRMenuEvent):void
		{
			// Relay event...
			dispatchEvent(event.clone());
		}
		
		protected function showToolTip(event:Event):void
		{
			if(_toolTip)
			{
				// Adjust x if toolTip will display off stage horizontally
				if( root.mouseX > stage.stageWidth - 100 ){
					_toolTip.x = root.mouseX - _toolTip.width;
				}else{
					_toolTip.x = root.mouseX + 5;
				}
				// Adjust y if toolTip will display off stage verticaly
			/*	if( root.mouseY > stage.stageHeight - 100){
					_toolTip.y = root.mouseY - 20;
				}else{
					_toolTip.y = root.mouseY + 20;
				}*/
				root.stage.addChild(_toolTip);
			}
		}
		
		protected function hideToolTip(event:Event):void
		{
			if(_toolTip){
				root.stage.removeChild(_toolTip);
			}
		}
		
		//*****************************
		// Private Methods:
		
		protected function setContextMenu(src:String):void
		{
			_contextMenuLoader.load(src, 1);
			_contextMenuSource = src;
			
			// Build Context menu...
			_contextMenu = new AIRContextMenu();
			_contextMenu.source = _contextMenuLoader.fileData;
			_contextMenu.addEventListener(AIRMenuEvent.SELECT, onContextClickHandler);
			
			addChild(_contextMenu);
			
			// Assign menu to background...
			contextMenu = _contextMenu.baseMenu;
		}
		
		//*****************************
		// Public API:
		
		[Inspectable(defaultValue="")]
		public function set contextMenuSource(src:String):void
		{
			setContextMenu(src);
		}
		
		public function get contextMenuSource():String
		{
			return _contextMenuSource;
		}
		
		//---------------
		// preferredWidth
		
		public function set preferredWidth(n:Number):void
		{
			_preferredWidth = n;
		}
		
		public function get preferredWidth():Number
		{
			return _preferredWidth;
		}
		
		//---------------
		// preferredHeight
		
		public function set preferredHeight(n:Number):void
		{
			_preferredHeight = n;
		}
		
		public function get preferredHeight():Number
		{
			return _preferredHeight;
		}
		
		//---------------
		// toolTip
		
		[Inspectable(defaultValue="")]
		public function set toolTipText(val:String):void
		{
			if(!_toolTip){
				_toolTip = new ToolTip();
			}
			_toolTip.label = val;
		}
		
		public function get toolTipText():String
		{
			return _toolTip.label;
		}
	}
}