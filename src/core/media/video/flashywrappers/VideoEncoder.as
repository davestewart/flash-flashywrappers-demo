package core.media.video.flashywrappers
{
	
	import com.rainbowcreatures.*;
	import com.rainbowcreatures.swf.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends EventDispatcher 
	{

		// --------------------------------------------------------------------------------------------------------
		// constants
		
			public static const PHASE_UNLOADED		:String		= 'VideoEncoder.UNLOADED';
			public static const PHASE_LOADED		:String		= 'VideoEncoder.LOADED';
			public static const PHASE_READY			:String		= 'VideoEncoder.READY';
			public static const PHASE_CAPTURING		:String		= 'VideoEncoder.CAPTURING';
			public static const PHASE_ENCODING		:String		= 'VideoEncoder.ENCODING';
			public static const PHASE_FINISHED		:String		= 'VideoEncoder.FINISHED';
		
			
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// statics
			protected static var _path		:String;
			public static function get path():String { return _path; }
			
			protected static var _loaded	:Boolean;
			public static function get loaded():Boolean { return _loaded; }
		
			protected static var _instance	:VideoEncoder;
		
			// objects
			protected var target			:Sprite;
			protected var encoder			:FWVideoEncoder;
			protected var data				:ByteArray;
			
			// properties 
			protected var _fps				:int;
			protected var _bitrate			:int;
			protected var _realtime			:Boolean;
			protected var _format			:String;
			
			// variables
			protected var _frames			:int;
			protected var _phase			:String				= PHASE_UNLOADED;
			protected var _timeStart		:Number;
			protected var _bytes			:ByteArray;

			
		// --------------------------------------------------------------------------------------------------------
		// static instantiation
		
			public static function load(root:Sprite, onLoad:Function, path:String = ''):void
			{
				// function
				function onStatus(event:StatusEvent):void
				{
					if (event.code === 'ready')
					{
						VideoEncoder._loaded = true;
						encoder.removeEventListener(StatusEvent.STATUS, onStatus);
						if (onLoad is Function)
						{
							onLoad(new VideoEncoderEvent(VideoEncoderEvent.LOADED));
						}
					}
				}
				
				// set the path for later
				_path = path;
				
				// create and load a stub encoder, just to get ffmpeg loaded
				var encoder:FWVideoEncoder = FWVideoEncoder.getInstance(root);
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				encoder.load(path);
			}
			
			public static function get instance():VideoEncoder { return _instance; }

		
		// --------------------------------------------------------------------------------------------------------
		// private constructor
		
			public function VideoEncoder(target:Sprite, fps:int = 25, format:String = 'mp4') 
			{
				// test for loaded
				if ( ! VideoEncoder._loaded )
				{
					throw new UninitializedError('The VideoEncoder ffmpeg library has not yet loaded. Load the library using VideoEncoder.load(onLoaded) before instantiating VideoEncoder instances');
				}
				
				// properties
				this.target				= target;
				
				// encoder properties
				_format					= format;
				_fps					= fps;
				_bitrate				= 1000000;
				_realtime				= false;
				
				// set up encoder
				encoder					= FWVideoEncoder.getInstance(target);
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				
				// re-load cached ffmpeg library
				encoder.load(VideoEncoder.path);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			/**
			 * Call in advance of recording
			 */
			public function initialize():void 
			{
				// set up encoder
				trace('start ' + getTimer());
				encoder.start(fps, 'audioOff', true, target.width, target.height, bitrate);
				trace('end ' + getTimer());				trace(getTimer());
				
				// phase
				_phase = PHASE_READY;
				
				// dispatch
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.READY));
			}
		
			/**
			 * Start recording
			 */
			public function start():void 
			{
				if (phase !== PHASE_READY)
				{
					trace('WARNING! Did not pre-initialize VideoEncoder. Reinitializing (there will be a delay) ...');
					initialize();
				}
				
				_frames = 0;
				target.addEventListener(Event.ENTER_FRAME, onCapture);
			}
			
			/**
			 * Stop recording
			 */
			public function stop():void
			{
				_timeStart	= getTimer();
				_phase		= PHASE_ENCODING;
				target.removeEventListener(Event.ENTER_FRAME, onCapture);
				target.addEventListener(Event.ENTER_FRAME, onEncode);
				encoder.finish();
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// accessors
			
			public function get fps():int { return _fps; }
			public function set fps(value:int):void 
			{
				_fps = value;
			}
			
			public function get bitrate():int { return _bitrate; }
			public function set bitrate(value:int):void 
			{
				_bitrate = value;
			}
			
			public function get realtime():Boolean { return _realtime; }
			public function set realtime(value:Boolean):void 
			{
				_realtime = value;
			}
			
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				_format = value;
			}
						
			public function get frames():int { return _frames; }
			
			public function get phase():String { return _phase; }
			
			public function get encodingProgress():Number { return encoder.getEncodingProgress(); }
			
			public function get duration():Number { return (getTimer() - _timeStart) / 1000; }
			
			public function get bytes():ByteArray { return _bytes; }
			
			
		// --------------------------------------------------------------------------------------------------------
		// protected functions
			
			protected function finish():void 
			{
				// ensure that a final ENCODING event is dispatched 
				onEncode(null);
				
				// update properties
				_phase	= PHASE_FINISHED;
				_bytes	= new ByteArray();
				_bytes.writeBytes(encoder.getVideo());
				
				// dispatch
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.FINISHED));
				target.removeEventListener(Event.ENTER_FRAME, onEncode);
			}

		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			protected function onStatus(event:StatusEvent):void 
			{
				// debug
				// trace('status: ' + event.code);
				
				// code
				switch(event.code)
				{
					case 'ready':
						initialize();
						break;
						
					case 'encoded':
						finish();
						break;
				}
			}
			
			protected function onCapture(event:Event):void 
			{
				_phase = PHASE_CAPTURING;
				encoder.capture(target);
				_frames++
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.CAPTURED));
			}
			
			protected function onEncode(event:Event):void 
			{
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.ENCODING));
			}
			
	}

}

class Lock
{
	
}