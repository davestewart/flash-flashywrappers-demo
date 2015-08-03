package app.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import app.net.FileRef;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class FileRef extends EventDispatcher 
	{
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function FileRef() 
			{
				
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function save(bytes:ByteArray, format:String = 'mp4'):void
			{
					// variables
					var file	:FileReference	= new FileReference();
					
					// debug
					//trace(bytes);
					
					// save file
					file.addEventListener(Event.COMPLETE, onSaveComplete);
					file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
					file.save(bytes, 'video.' + format);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// handlers
			
			protected function onSaveComplete(event:Event):void 
			{
				trace('the file was saved successfully');
			}
			
			protected function onSaveError(event:IOErrorEvent):void 
			{
				trace('there was a problem saving the file');
			}
			

		
		
	}

}