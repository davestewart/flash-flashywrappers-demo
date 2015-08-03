package app.media.video 
{
	import app.display.Element;
	import fl.controls.Button;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	
	/**
	 * On-screen video rectangle and simple record / save buttons
	 * 
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends Element 
	{
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// video
			public var bg				:Shape;
			public var video			:Video;
			
			// properties
			protected var _width		:int;
			protected var _height		:int;
			
			// connection
			protected var connection	:NetConnection;
			
			
			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function VideoPlayer(parent:DisplayObjectContainer = null, width:int = 400, height:int = 300) 
			{
				// super
				super(parent);
				
				// dimensions
				_width		= width;
				_height		= height;
				
				// build
				build();
				
			}
			
			public function build():void
			{
				// bg
				bg						= new Shape();
				bg.graphics.beginFill(0xEEEEEE);
				bg.graphics.drawRect(0, 0, _width, _height);
				addChild(bg);
					
				// video
				video					= new Video(_width, _height);
				addChild(video);
				
				// connection
				connection = new NetConnection();
				connection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatusHandler, false, 0, true);		
				connection.connect(null);

			}
			
			public function loadUrl(url:String):void
			{
				var stream:NetStream = new NetStream(connection);
				stream.client = { };	
				video.attachNetStream(stream);
				stream.play(url);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function netConnectionStatusHandler(event:NetStatusEvent):void
			{
				switch(event.info.code)
				{
					case 'NetConnection.Connect.Success':
						trace('connected');
						break;
				}
			}
			
		
	}

}