package core.media.video.flashywrappers
{
	
	import com.rainbowcreatures.*;
	import com.rainbowcreatures.swf.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends Sprite 
	{

		// --------------------------------------------------------------------------------------------------------
		// constants
		
			public static const PHASE_UNLOADED		:String		= 'VideoEncoder.UNLOADED';
			public static const PHASE_LOADED		:String		= 'VideoEncoder.LOADED';
			public static const PHASE_INITIALIZING	:String		= 'VideoEncoder.INITIALIZING';
			public static const PHASE_READY			:String		= 'VideoEncoder.READY';			// note that this is different from the core FW status event! in this case, ready means "ready" not "loaded"
			public static const PHASE_CAPTURING		:String		= 'VideoEncoder.CAPTURING';
			public static const PHASE_ENCODING		:String		= 'VideoEncoder.ENCODING';
			public static const PHASE_FINISHED		:String		= 'VideoEncoder.FINISHED';
		
			
		// --------------------------------------------------------------------------------------------------------
		// variables
		
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
			protected var _totalFrames		:int;
			protected var _currentFrame		:int;
			protected var _phase			:String				= PHASE_UNLOADED;
			protected var _timeStart		:Number;

			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function VideoEncoder(target:Sprite, totalFrames:int = 50, fps:int = 25, format:String = 'mp4') 
			{
				// properties
				this.target				= target;
				
				// encoder properties
				_format					= format;
				_totalFrames			= totalFrames;
				_fps					= fps;
				_bitrate				= 1000000;
				_realtime				= false;
				
				// set up encoder
				encoder					= FWVideoEncoder.getInstance(target);
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				
				// these don't seem to work currently
				//encoder.setDimensions(target.width, target.height);
				//encoder.setFps(25);
				//encoder.setTotalFrames(totalFrames);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function load(path:String = ''):void
			{
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.LOADING));
				encoder.load(); // custom paths don't seem to load properly
			}
		
			public function initialize():void
			{
				_phase = PHASE_INITIALIZING;
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.INITIALIZING));
				encoder.start(fps, 'audioOff', true, target.width, target.height, bitrate);
				
				_phase = PHASE_READY;
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.READY));
			}
		
			public function start():void 
			{
				_currentFrame = 0;
				addEventListener(Event.ENTER_FRAME, onCapture);
			}
			
			public function stop():void
			{
				_timeStart	= getTimer();
				_phase		= PHASE_ENCODING;
				removeEventListener(Event.ENTER_FRAME, onCapture);
				addEventListener(Event.ENTER_FRAME, onEncode);
				encoder.finish();
			}
			
			public function getVideo():ByteArray
			{
				return encoder.getVideo();
			}
			
			public function getEncodingProgress():Number 
			{
				return encoder.getEncodingProgress();
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
						
			public function get totalFrames():int { return _totalFrames; }
			public function set totalFrames(value:int):void 
			{
				_totalFrames = value;
			}
			
			public function get currentFrame():int { return _currentFrame; }
			
			public function get phase():String { return _phase; }
			
			public function get duration():Number { return (getTimer() - _timeStart) / 1000; }
			
			
		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			protected function onStatus(event:StatusEvent):void 
			{
				// debug
				trace('status: ' + event.code);
				
				// code
				switch(event.code)
				{
					case 'ready':
						_phase = PHASE_LOADED;
						dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.LOADED));
						initialize();
						break;
						
					// need the encoder to dispatch a status event, so we know it's ready!
					case 'initialized':
						_phase = PHASE_READY;
						dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.READY));
						break;
						
					case 'encoded':
						_phase = PHASE_FINISHED;
						dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.FINISHED));
						removeEventListener(Event.ENTER_FRAME, onEncode);
						break;
				}
			}
			
			protected function onCapture(event:Event):void 
			{
				_phase = PHASE_CAPTURING;
				encoder.capture(target);
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.CAPTURED));
				if (_currentFrame++ == _totalFrames)
				{
					stop();
				}
			}
			
			protected function onEncode(event:Event):void 
			{
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.ENCODING));
			}
			
	}

}