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
		
			private var url			:String;
			protected var _response		:Object;


		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function Uploader(url:String = 'http://davestewart.co.uk/temp/fw/encode.php') 
			{
				this.url = url;
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public methods
		
			public function upload(bytes:ByteArray):void 
			{
				// request objects
				var request			:URLRequest		= new URLRequest(url);
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
			
			public function get uploadUrl():Object { return _response.data.url; }
			
			
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