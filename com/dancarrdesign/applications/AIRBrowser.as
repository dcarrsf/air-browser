/**************************************
 * Copyright © 2009. Dan Carr Design. 
 * Written by Dan Carr and Dave Gonzalez
 * email: info@dancarrdesign.com
 * 
 * Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * THE WORK IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS 
 * PUBLIC LICENSE ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY 
 * COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF THE WORK OTHER 
 * THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.
 * 
 * BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND 
 * AGREE TO BE BOUND BY THE TERMS OF THIS LICENSE. TO THE EXTENT THIS 
 * LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS YOU 
 * THE RIGHTS CONTAINED HERE IN CONSIDERATION OF YOUR ACCEPTANCE OF SUCH 
 * TERMS AND CONDITIONS.
 * 
 * THE SOFTWARE IS PROVIDED "AS-IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRENTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRIDGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR AN 
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * tORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OF OTHER DEALINGS IN THE SOFTWARE.
 */
package com.dancarrdesign.applications 
{
	import com.dancarrdesign.core.AIRComponent;
	import com.dancarrdesign.events.*;
	import com.dancarrdesign.events.types.*;
	import com.dancarrdesign.utils.*;
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.html.HTMLHistoryItem;
	import flash.printing.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.ui.Keyboard;
	
	/**********************************
	 * The AIRBrowser class extends the AIRComponent class and
	 * creates the controller class which binds the components
	 * and handles the event and data flow. The AIRBrowser class
	 * is assigned as the document class to the FLA implementing
	 * the AIR Components extensions.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 * @author Dave Gonzalez (dave@mindsteinmedia.com)
	 */
	public class AIRBrowser extends AIRComponent
	{
		//*****************************
		// Properties:
		
		protected var _historyItem:HTMLHistoryItem;
		protected var _fileManager:AIRFileManager;
		protected var _aboutWindow:AIRNativeWindow;
		protected var _helpWindow:AIRNativeWindow;
		protected var _nativeMenu:AIRNativeMenu;
		
		// Data:
		protected var _bookmarks:XML;
		protected var _catalog:XML;
		protected var _settings:XML;
		
		// Configuration:
		protected var _fileSettings:String = "app-storage/config/settings.xml";
		protected var _fileMenu:String = "app-storage/config/menu.xml";
		protected var _fileCatalog:String = "app-storage/config/catalog.xml";
		protected var _fileBookmarks:String = "app-storage/config/bookmarks.xml";
		protected var _fileContextMenu:String = "app-storage/config/contextMenu.xml";
		
		//*****************************
		// Constructor:
		
		public function AIRBrowser():void
		{
			// Create file loader
			_fileManager = new AIRFileManager();
			
			// Load settings data...
			_fileManager.load(_fileSettings, 1);
			
			// Cache settings...
			_settings = _fileManager.fileData;
			
			// Load menu data...
			_fileManager.load(_fileMenu, 1);
			
			// Build menubar
			_nativeMenu = new AIRNativeMenu();
			_nativeMenu.source = _fileManager.fileData;
			_nativeMenu.addEventListener(AIRMenuEvent.SELECT, menuSelectHandler);
			addChild(_nativeMenu);
			
			// Load catalog data...
			var tmp:File = _fileManager.resolvePath(_fileCatalog, 0);
			if( tmp.exists ) {
				_catalog = installMenuItems(_fileCatalog, "goto", 0); // User saved (load if available)
			}else{
				_catalog = installMenuItems(_fileCatalog, "goto", 1); // Default installation
			}
			// Load bookmark data...
			tmp = _fileManager.resolvePath(_fileBookmarks, 0);
			if( tmp.exists ) {
				_bookmarks = installMenuItems(_fileBookmarks, "bookmarks", 0); // User saved (load if available)
			}else{
				_bookmarks = installMenuItems(_fileBookmarks, "bookmarks", 1); // Default installation
			}
			
			// Events
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		//*****************************
		// Events:
		
		protected function addedToStageHandler(event:Event):void
		{
			// Stage settings
			stage.focus = this;
            stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			// Update header bar...
			if( _settings.location.show.text() == "0" ){
				_nativeMenu.toggleCheck("view", "view_location", false);
				html_header.visible = false;
			}
			html_header.settings = _settings;
			html_header.setButtonState("back", false);
			html_header.setButtonState("forward", false);
			html_header.contextMenuSource = _fileContextMenu;
			html_header.addEventListener(AIRLocationEventType.BACK, headerEventHandler);
			html_header.addEventListener(AIRLocationEventType.FORWARD, headerEventHandler);
			html_header.addEventListener(AIRLocationEventType.RELOAD, headerEventHandler);
			html_header.addEventListener(AIRLocationEventType.CANCEL, headerEventHandler);
			html_header.addEventListener(AIRLocationEventType.BOOKMARK, headerEventHandler);
			html_header.addEventListener(AIRLocationEventType.HOME, headerEventHandler);
			html_header.addEventListener(AIRLocationEventType.CHANGE, headerMenuClickHandler);
			html_header.addEventListener(AIRMenuEvent.SELECT, headerContextClickHandler);

			// Update status bar...
			if( _settings.status.show.text() == "0" ){
				_nativeMenu.toggleCheck("view", "view_status", false);
				html_footer.visible = false;
			}
			html_footer.clearStatus();
			html_footer.settings = _settings;
			html_footer.contextMenuSource = _fileContextMenu;
			html_footer.addEventListener(AIRMenuEvent.SELECT, footerContextClickHandler);
			
			// Update HTML Pane...
			html_pane.scaleX = 1;
			html_pane.scaleY = 1;
			html_pane.timeoutLimit = Number(_settings.timeOutLimit)*1000;
			html_pane.addEventListener(AIRLocationEventType.COMPLETE, htmlChangeHandler);
			html_pane.addEventListener(AIRLocationEventType.LOCATION_CHANGE, htmlChangeHandler);
			html_pane.addEventListener(AIRErrorEventType.TIME_OUT, htmlTimeoutHandler);
			html_pane.addEventListener(AIRErrorEventType.UNHANDLED_EXCEPTION, htmlExceptionHandler);
			html_pane.load(_settings.startPage); 
		}
		
		protected function htmlTimeoutHandler(event:AIRErrorEvent):void 
		{
			html_footer.setStatus(2, event.info);
			
			// Load error page...
			html_pane.load(_settings.errorPage);
		}
		
		protected function htmlExceptionHandler(event:AIRErrorEvent):void 
		{
			// Show error status...
			html_footer.setStatus(2, event.info);
		}
		
		protected function htmlChangeHandler(event:AIRLocationEvent):void 
		{
			switch( event.type )
			{
				case "complete":
				
					// Show done status...
					html_footer.setStatus(1);
					html_footer.showLoadingAnimation(false);
					
					// Cache history item
					_historyItem = html_pane.getHistoryAt(html_pane.historyPosition);
					
					// Update navigation buttons
					if( html_pane.historyPosition == html_pane.historyLength - 1) {
						_nativeMenu.toggleState("goto", "catalog_forward", false);
						html_header.setButtonState("forward", false);
					}else {
						_nativeMenu.toggleState("goto", "catalog_forward", true);
						html_header.setButtonState("forward", true);
					}
					if( html_pane.historyPosition == 0 ) {
						_nativeMenu.toggleState("goto", "catalog_back", false);
						html_header.setButtonState("back", false);
					}else {
						_nativeMenu.toggleState("goto", "catalog_back", true);
						html_header.setButtonState("back", true);
					}
					// Update layout when page loads...
					layout();
					
					// Set title...
					setTitle(_historyItem.title);
					
					// Update header menu location...
					var formattedURL:Array = _historyItem.url.split("app:/app-storage/");
					html_header.setLocation(formattedURL[formattedURL.length-1]);
					break;
					
				case "locationChange":
					
					// Show waiting status...
					html_footer.setStatus(0, html_pane.location);
					html_footer.showLoadingAnimation(true);
					break;
			}
		}
		
		protected function openFileHandler(event:Event):void
		{
			var fileStr:String = event.target.nativePath;
			if( fileStr.indexOf("html") != -1 ||
				fileStr.indexOf(".xml") != -1 ||
				fileStr.indexOf(".swf") != -1 ||
				fileStr.indexOf(".pdf") != -1 )
			{
				// Load file...
				html_pane.load(fileStr);
			}
			else{
				// Error...
				html_pane.load(_settings.errorPageType);
			}
		}
		
		protected function importBookmarksHandler(event:Event):void
		{
			var fileStr:String = event.target.nativePath;
			if( fileStr.indexOf(".xml") != -1 )// check XML format
			{
				// Instal new goto links into menu
				var tmp:XML = installMenuItems(fileStr, "bookmarks");
				if( tmp.item.length() > 0 )
				{
					// Remove all link items from menu
					var target:NativeMenu = _nativeMenu.getMenuByName("bookmarks");
					var n:uint = target.numItems;
					for(n; n > 0; n--) {
						if( target.getItemAt(n-1).isSeparator ) {
							break;// Remove items in reverse until we hit a separator
						}else{
							target.removeItemAt(n-1);
						}
					}
					_bookmarks = tmp;
					
					// Save reference...
					_fileManager.save(_bookmarks, _fileBookmarks, 0);
				}else{
					// Error...
					html_pane.load(_settings.errorPageType);
				}
			}else{
				// Error...
				html_pane.load(_settings.errorPageType);
			}
		}
		
		protected function importCatalogHandler(event:Event):void
		{
			var fileStr:String = event.target.nativePath;
			if( fileStr.indexOf(".xml") != -1 )// check XML format
			{
				// Instal new goto links into menu
				var tmp:XML = installMenuItems(fileStr, "goto");
				if( tmp.item.length() > 0 )
				{
					// Remove all link items from the menu
					var target:NativeMenu = _nativeMenu.getMenuByName("goto");
					var n:uint = target.numItems;
					for(n; n > 0; n--) {
						if( target.getItemAt(n-1).isSeparator ) {
							break;// Remove items in reverse until we hit a separator
						}else{
							target.removeItemAt(n-1);
						}
					}
					_catalog = tmp;
					
					// Save reference...
					_fileManager.save(_catalog, _fileCatalog, 0);
				}else{
					// Error...
					html_pane.load(_settings.errorPageType);
				}
			}else{
				// Error...
				html_pane.load(_settings.errorPageType);
			}
		}
		
		protected function exportBookmarksHandler(event:Event):void
		{
			var fileStr:String = event.target.nativePath;
			
			// Save new bookmarks file
			_fileManager.saveAbsolute(_bookmarks.toXMLString(), fileStr);
		}
		
		protected function exportCatalogHandler(event:Event):void
		{
			var fileStr:String = event.target.nativePath;
			
			// Save new catalog file...
			_fileManager.saveAbsolute(_catalog.toXMLString(), fileStr);
		}
		
		protected function menuSelectHandler(event:AIRMenuEvent):void
		{
			var item:NativeMenuItem = event.item;
			var idArr:Array = String(item.name).split("_");
			var file:File;
			
			switch( idArr[0] )
			{
				case "file":
					
					// Handle file commands
					switch( idArr[1] )
					{
						case "open":
							
							// Allow the user to browse for a file to open...
							open();
							break;
							
						case "close":
							
							// Close current page and show default (local) page...
							close();
							break;
							
						case "print":
							
							// Print current page...
							print();
							break;
							
						case "exit":
							
							// Close application (close all windows)...
							exit();
							break;
					}
					break;
					
				case "import":
					
					// Import XML (launch browse for file dialog)...
					switch( idArr[1] )
					{
						case "bookmarks":
							
							// Import bookmarks...
							file = new File();
							file.addEventListener(Event.SELECT, importBookmarksHandler);
							file.browseForOpen("Select a File");
							
							// Event handler: save file to local storage...
							break;
							
						case "catalog":
							
							// Import URL catalog...
							file = new File();
							file.addEventListener(Event.SELECT, importCatalogHandler);
							file.browseForOpen("Select a File");
							
							// Event handler: save file to local storage...
							break;
					}
					break;
					
				case "export":
					
					// Export XML (launch save to directory dialog)...
					switch( idArr[1] )
					{
						case "bookmarks":
							
							// Export bookmarks...
							file = new File();
							file.addEventListener(Event.SELECT, exportBookmarksHandler);
							file.browseForSave("Save As");
							
							// Event handler: save file to destination...
							break;
							
						case "catalog":
							
							// Export URL catalog...
							file = new File();
							file.addEventListener(Event.SELECT, exportCatalogHandler);
							file.browseForSave("Save As");
							
							// Event handler: save file to destination...
							break;
					}
					break;
				
				case "bookmarks":
					
					// Handle bookmarks commands
					switch( idArr[1] )
					{
						case "add":
						
							// Add current page to bookmarks...
							addBookmark();
							break;
							
						case "delete":
							
							// Delete current page from bookmarks...
							deleteBookmark();
							break;
							
						default:
							
							// Load page from 'bookmark' history...
							html_pane.load(item.data.url);
							break;
					}
					break;
				
				case "view":
					
					// Handle view commands
					switch( idArr[1] )
					{
						case "location":
							
							// Toggle visibility and layout of location bar...
							html_header.visible = !html_header.visible;
							layout();
							break;
							
						case "status":
							
							// Toggle visibility and layout of status bar...
							html_footer.visible = !html_footer.visible;
							layout();
							break;
							
						case "stop":
							
							// Stop loading in HTMLPane...
							html_pane.cancel();
							html_footer.setStatus(1);
							break;
							
						case "refresh":
							
							// Refresh HTMLPane...
							html_pane.refresh();
							break;
							
						case "full":
							
							// Toggle fullscreen mode...
							toggleFullScreen();
							break;
					}
					break;
				
				case "catalog":
					
					// Handle catalog navigation commands
					switch( idArr[1] )
					{
						case "forward":
							
							// Show the next page in the catalog list...
							html_pane.historyForward();
							break;
							
						case "back":
							
							// Show the prev page in the catalog list...
							html_pane.historyBack();
							break;
							
						case "home":
							
							// Show the first page (home) in the catalog list...
							html_pane.load(_catalog.item[0].data.url);
							break;
							
						default:
							
							// Show specified page in catalog list...
							html_pane.load(item.data.url.text());
							break;
					}
					break;
				
				case "help":
					
					// Handle help commands
					switch( idArr[1] )
					{
						case "contents":
							
							// Show the help popup...
							openHelpWindow();
							break;
							
						case "about":
							
							// Show the about us popup...
							openAboutWindow();
							break;
					}
					break;
			}
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if((event.commandKey || event.controlKey) && event.keyCode == Keyboard.O ) {
				// Open
				open();
			}
			else if((event.commandKey || event.controlKey) && event.keyCode == Keyboard.W ) {
				// Close	
				close();
			}
			else if((event.commandKey || event.controlKey) && event.keyCode == Keyboard.P ) {
				// Print
				print();
			}
			else if((event.commandKey || event.controlKey) && event.keyCode == Keyboard.Q ) {
				// Exit
				exit();
			}
			else if((event.commandKey || event.controlKey) && event.keyCode == Keyboard.B ) {
				// Add Bookmark
				addBookmark();
			}
			else if((event.commandKey || event.controlKey) && event.keyCode == Keyboard.D ) {
				// Remove Bookmark
				deleteBookmark();
			}
			else if( event.keyCode == Keyboard.LEFT ) {
				// Back
				html_pane.historyBack();
			}
			else if( event.keyCode == Keyboard.RIGHT ) {
				// Forward
				html_pane.historyForward();
			}
			else if( event.keyCode == Keyboard.HOME ) {
				// Home
				html_pane.historyGo(0);
			}
			else if( event.keyCode == Keyboard.ESCAPE ) {
				// Stop
				html_pane.cancel();
				html_footer.setStatus(1);
			}
			else if( event.keyCode == Keyboard.F1 ) {
				// Help
				openHelpWindow();
			}
			else if( event.keyCode == Keyboard.F11 ) {
				// Fullscreen
				toggleFullScreen();
			}
			else if( event.keyCode == Keyboard.F5 ) {
				// Refresh
				html_pane.refresh();
			}
		}
		
		protected function headerEventHandler(event:AIRLocationEvent):void 
		{
			switch( event.type )
			{
				case "back":
				
					// Navigate back...
					html_pane.historyBack();
					break;
					
				case "forward":
				
					// Navigate forward...
					html_pane.historyForward();
					break;
					
				case "reload":
				
					// Refresh current page...
					html_pane.refresh();
					break;
					
				case "cancel":
				
					// Cancel current page load...
					html_pane.cancel();
					break;
					
				case "bookmark":
				
					// Save bookmark...
					addBookmark();
					break;
					
				case "home":
					
					// Load home page...
					html_pane.load(_catalog.item[0].data.url);
					break;
			}
		}
		
		protected function headerMenuClickHandler(event:AIRLocationEvent):void 
		{
			html_pane.load(event.item.url);
		}
		
		protected function headerContextClickHandler(event:AIRMenuEvent):void
		{
			html_header.visible = false;
			html_pane.refresh();
			
			// Uncheck view location menu item
			_nativeMenu.toggleCheck("view", "view_location", false);
		}
		
		protected function footerContextClickHandler(event:AIRMenuEvent):void
		{
			html_footer.visible = false;
			html_pane.refresh();
			
			// Uncheck view status menu item
			_nativeMenu.toggleCheck("view", "view_status", false);
		}
		
		protected function resizeHandler(event:Event=null):void
		{
			layout();
		}
		
		protected function enterFrameHandler(event:Event=null):void
		{
			// Forcing the layout to redraw every frame produces 
			// better rendering while resizing, but it's CPU intensive
			// so I'm disabling it by default. Redrawing when the stage 
			// resizes works sufficiently well.
			// layout();
		}
		
		//*****************************
		// Private Methods:
		
		protected function installMenuItems(path:String, name:String, dir:uint=1):XML
		{
			// Load XML file...
			_fileManager.load(path, dir);
			
			// Install data into menu...
			var target:NativeMenu = _nativeMenu.getMenuByName(name);
			for each(var item in _fileManager.fileData.item){
				_nativeMenu.addMenuItem(target, item);
			}
			
			// Return XML reference...
			return _fileManager.fileData;
		}
		
		protected function layout():void
		{
			html_chrome.setSize(stage.stageWidth, stage.stageHeight);
			html_header.setSize(stage.stageWidth, html_header.height);
			html_footer.setSize(stage.stageWidth, html_footer.height);
			html_footer.y = stage.stageHeight - html_footer.height;
		
			var paneHeight:Number;
			if( html_header.visible && html_footer.visible ){
				html_pane.y = html_header.height;
				paneHeight = stage.stageHeight - html_header.height - html_footer.height + 2;
			}
			else if( html_header.visible ){
				html_pane.y = html_header.height;
				paneHeight = stage.stageHeight - html_chrome.innerY - html_header.height + 2;
			}
			else if( html_footer.visible ){
				html_pane.y = html_chrome.innerY;
				paneHeight = stage.stageHeight - html_chrome.innerY - html_footer.height + 2;
			}
			else{
				html_pane.y = html_chrome.innerY;
				paneHeight = html_chrome.innerHeight;
			}
			html_pane.x = html_chrome.innerX;
			html_pane.setSize(html_chrome.innerWidth, paneHeight);
		}
		
		//*****************************
		// Public Methods:
		
		public function setTitle(str:String):void
		{
			if( Boolean(_settings.useTitleOnChrome) ) {
				str += " - " + _settings.title.text();
			}
			stage.nativeWindow.title = str;
		}
		
		public function open():void
		{
			var file:File = new File();
			file.addEventListener(Event.SELECT, openFileHandler);
			file.browseForOpen("Select a File");
		}
		
		public function close():void
		{
			var file:File = File.applicationDirectory.resolvePath(_settings.startPage);
			html_pane.load(file.nativePath);
		}
		
		public function print():void
		{
			var my_pj:PrintJob = new PrintJob();
			if( my_pj.start() ){
				try{
					my_pj.addPage(html_pane);
					my_pj.send();
				}catch(e) {
					// Handle print error here...
				}
			}
		}
		
		public function exit():void
		{
			var winLen:uint = NativeApplication.nativeApplication.openedWindows.length;
			for(var n:Number = 0; n < winLen; n++) {
				var closeWin:NativeWindow = NativeApplication.nativeApplication.openedWindows[n] as NativeWindow;
				closeWin.close();
			}
		}
		
		public function addBookmark():void 
		{	
			// Create a bookmark node
			var item:XML = 
			<item>
				<name>{"bookmarks_" + _bookmarks.item.length()}</name>
				<label>{_historyItem.title}</label>
				<enabled>1</enabled>
				<checked/>
				<data>
					<url>{_historyItem.url}</url>
				</data>
			</item>;
			
			// Add new node to bookmarks XML
			_bookmarks.appendChild(item);
			
			// Add item to bookmarks native window
			var target:NativeMenu = _nativeMenu.getMenuByName("bookmarks");
			_nativeMenu.addMenuItem(target, item);

			// Write XML to bookmarks file
			_fileManager.save(_bookmarks, _fileBookmarks, 0);
		}
		
		public function deleteBookmark():void
		{
			// Find the bookmark that matches the url loaded in the html_pane
			for each(var item in _bookmarks.item)
			{
				if( item.data.url == _historyItem.url )
				{
					// Remove item from bookmarks native menu
					var target:NativeMenu = _nativeMenu.getMenuByName("bookmarks");
					var menuItem:NativeMenuItem = target.getItemByName(item.name);
					target.removeItem(menuItem);
					
					// Delete item from local bookmarks XML
					delete _bookmarks.item[item.childIndex()];
					
					// Save new bookmarks file
					_fileManager.save(_bookmarks, _fileBookmarks, 0);
					break;
				}
			}
		}
		
		public function openHelpWindow():void
		{
			if(!_helpWindow)
			{
				// Create an instance 
				_helpWindow = new AIRNativeWindow();
				_helpWindow.title = _settings.help.title.text();
				_helpWindow.source = _settings.help.source.text();
				_helpWindow.layout(_settings.help.width, _settings.help.height, AIRNativeWindowAlign.MIDDLE_CENTER);
				_helpWindow.activate();
			}else{
				_helpWindow.activate();
			}
		}
		
		public function openAboutWindow():void
		{
			if(!_aboutWindow)
			{
				// Set new window options
				var options:NativeWindowInitOptions = new NativeWindowInitOptions();
				options.systemChrome = NativeWindowSystemChrome.STANDARD;
				options.type = NativeWindowType.UTILITY;
				options.resizable = false;
								
				// Create an instance 
				_aboutWindow = new AIRNativeWindow();
				_aboutWindow.title = _settings.about.title.text();
				_aboutWindow.source = _settings.about.source.text();
				_aboutWindow.windowOptions = options;
				_aboutWindow.useHTMLLoader = false;
				_aboutWindow.layout(_settings.about.width, _settings.about.height, AIRNativeWindowAlign.MIDDLE_CENTER);
				_aboutWindow.activate();
			}else{
				_aboutWindow.activate();
			}
		}
		
		public function toggleFullScreen():void
		{
			if( stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED ){
				stage.nativeWindow.restore();
			}else{
				stage.nativeWindow.maximize();
			}
		}
	}
}