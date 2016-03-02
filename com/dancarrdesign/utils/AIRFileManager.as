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
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.net.*;
	
	/**********************************
	 * The AIRFileManager class extends the AIRComponent class
	 * and provides a simple API for reading and writing XML files
	 * to the local file system.
	 * --------------------------------
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 * @author Dan Carr (dan@dancarrdesign.com)
	 */
	public class AIRFileManager extends AIRComponent	
	{
		//*****************************
		// File:
		
		protected var _file:File;
		protected var _fileStream:FileStream;
		protected var _fileData:XML;
		
		//*****************************
		// Constructor:
		
		public function AIRFileManager():void
		{
			// Initialize...
		}
		
		//*****************************
		// Events:
		
		protected function fileCompleteHandler(event:Event):void 
		{
			_fileData = new XML(_fileStream.readUTFBytes(_fileStream.bytesAvailable));
			_fileStream.close();
			
			// Relay event
			dispatchEvent(event.clone());
		}
		
		//*****************************
		// Public Methods:
		
		//---------------------
		// Local requests:
		
		public function resolvePath(path:String, folder:int=0):File
		{
			switch( folder ) {
				case 0:
					return File.applicationStorageDirectory.resolvePath(path);
				case 1:
					return File.applicationDirectory.resolvePath(path);
				case 2:
					return File.desktopDirectory.resolvePath(path);
				case 3:						
					return File.documentsDirectory.resolvePath(path);
				case 4:
					return File.userDirectory.resolvePath(path);
			}
			return new File();
		}
		
		public function load(path:String, folder:uint=0, async:Boolean=false):void 
		{
			_file = resolvePath(path, folder); // Use a relative path
			_fileStream = new FileStream();
				
			// Load local file
			if ( async ) {
				_fileStream.addEventListener(Event.COMPLETE, fileCompleteHandler);
				_fileStream.openAsync(_file, FileMode.READ);
			}else{
				_fileStream.open(_file, FileMode.READ);
				_fileData = new XML(_fileStream.readUTFBytes(_fileStream.bytesAvailable));
				_fileStream.close();
			}
		}
		
		public function save(src:*, path:String, folder:uint=0, async:Boolean=false):void 
		{
			_file = resolvePath(path, folder); // Use a relative path
			_fileStream = new FileStream();
				
			// Save local XML file
			if ( async ) {
				_fileStream.addEventListener(Event.COMPLETE, fileCompleteHandler);
				_fileStream.openAsync(_file, FileMode.WRITE);
				_fileStream.writeUTFBytes(src);
			}else{
				_fileStream.open(_file, FileMode.WRITE);
				_fileStream.writeUTFBytes(src);
				_fileStream.close();
			}
		}
		
		public function saveAbsolute(src:*, path:String, async:Boolean=false):void 
		{
			_file = new File(path); // Use an absolute supplied path
			_fileStream = new FileStream();
				
			// Save local XML file
			if ( async ) {
				_fileStream.addEventListener(Event.COMPLETE, fileCompleteHandler);
				_fileStream.openAsync(_file, FileMode.WRITE);
				_fileStream.writeUTFBytes(src);
			}else{
				_fileStream.open(_file, FileMode.WRITE);
				_fileStream.writeUTFBytes(src);
				_fileStream.close();
			}
		}
		
		//*****************************
		// Public Properties:
		
		public function set fileData(d:XML):void
		{
			_fileData = d;
		}
		
		public function get fileData():XML
		{
			return _fileData;
		}
	}
}