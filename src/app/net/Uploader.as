package app.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Uploader extends EventDispatcher
	{
		
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			private var server			:String;
			protected var _response		:Object;


		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function Uploader(server:String = 'http://localhost:8000/') 
			{
				this.server = server;
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public methods
		
			public function upload(bytes:ByteArray):void 
			{
				// request objects
				var request			:URLRequest		= new URLRequest(server + 'encode.php');
				var loader			:URLLoader		= new URLLoader();
				
				// set up request
				request.contentType	= 'application/octet-stream';
				request.method		= URLRequestMethod.POST;
				request.data		= bytes;
				
				// load request
				loader.addEventListener(Event.COMPLETE, onComplete);
				loader.load(request);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// accessors
		
			public function get response():Object { return _response; }
			
			
		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			protected function onComplete(event:Event):void 
			{
				// debug
				trace(event.target.data);
				
				// parse response
				_response = JSON.parse(event.target.data);
				
				// dispatch
				dispatchEvent(new Event(Event.COMPLETE));				
			}
			
	}

}