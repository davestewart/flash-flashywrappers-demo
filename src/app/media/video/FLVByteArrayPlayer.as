package app.media.video 
{
	import cc.minos.codec.ICodec;
	import flash.display.DisplayObjectContainer;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.media.Video;
	import cc.minos.codec.mov.*;
	import cc.minos.codec.flv.*;	
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class FLVByteArrayPlayer extends VideoPlayer 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var stream			:NetStream;
				protected var bytes				:ByteArray;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function FLVByteArrayPlayer(parent:DisplayObjectContainer = null, width:int = 400, height:int = 300) 
			{
				// set up video
				super(parent, width, height);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			public function loadBytes(_bytes:ByteArray):void 
			{
				// setup stream
				stream = new NetStream(connection);
				stream.client = { };	
				video.attachNetStream(stream);
				stream.play(null);
				
				// create flv container
				var mp4:Mp4Codec	= new Mp4Codec();
				mp4.decode(_bytes);
				var flv:FlvCodec	= new FlvCodec()
				bytes = flv.encode(mp4);
			
				// append initial keyframe data
				var keyframes			:Array		= flv.getKeyframes();
				var ba					:ByteArray;
				
				// frame 1
				ba = new ByteArray();
				ba.writeBytes(bytes, 0, keyframes[1].position + 10240);
				stream.appendBytes(ba);
				stream.seek(keyframes[0].time - 0.01);

				// frame 0
				ba = new ByteArray();
				ba.writeBytes(bytes, keyframes[0].position);
				
				// debug
				trace(bytes.length);
				
				// append bytes to play
				stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
				stream.appendBytes(bytes);
				stream.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
			}
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}

