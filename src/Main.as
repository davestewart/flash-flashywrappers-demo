package
{
	import core.media.video.flashywrappers.VideoPlayer;
	import app.display.VideoControls;
	import core.media.video.flashywrappers.VideoPlayer;
	import core.media.video.VideoRecorder;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import core.media.video.flashywrappers.VideoEncoderEvent;
	import core.media.video.flashywrappers.VideoEncoder;
	import app.net.FileRef;
	import app.net.Uploader;

	/**
	 * Main class
	 * 
	 * @author Dave Stewart
	 */
	public class Main extends Sprite
	{
		
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// elements
			public var player			:VideoPlayer;
			public var recorder			:VideoRecorder;
			public var controls			:VideoControls;
			
			// objects
			protected var encoder		:VideoEncoder;
			protected var uploader		:Uploader;
			protected var fileref		:FileRef;
			
			// variables
			protected var totalFrames	:int;
			
			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function Main() 
			{
				initialize();
				build();
			}
			
			protected function initialize():void 
			{
				totalFrames = 25 * 15;
				VideoEncoder.load(this, onEncoderEvent);
			}
			
			protected function build():void 
			{
				// video recorder
				recorder			= new VideoRecorder(this, 400, 400);
				
				// video player
				player				= new VideoPlayer(this, 400, 400);
				player.x			= 400;
				
				// controls
				controls			= new VideoControls(this, recorder);
				controls.btnRecord.addEventListener(MouseEvent.CLICK, onRecordClick);
				controls.btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
				controls.btnSave.addEventListener(MouseEvent.CLICK, onSaveClick);
				controls.btnUpload.addEventListener(MouseEvent.CLICK, onUploadClick);
				controls.btnLoad.addEventListener(MouseEvent.CLICK, onLoadClick);
				
				// uploader
				uploader			= new Uploader();
				uploader.addEventListener(Event.COMPLETE, onUploadComplete);
				
				// file
				fileref				= new FileRef();
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// protected functions
		
			protected function start():void 
			{
				// encoder
				encoder = new VideoEncoder(recorder, 12.5, 'mp4');
				encoder.addEventListener(VideoEncoderEvent.READY, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.CAPTURED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.ENCODING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.FINISHED, onEncoderEvent);
				
				// controls
				controls.btnRecord.enabled = true;
				recorder.initCamera();
			}
			
			protected function load():void 
			{
				player.loadBytes(encoder.bytes);
			}
			
			protected function preview():void 
			{
				player.play();
				
			}
			
			protected function upload():void
			{
				uploader.upload(encoder.bytes);
			}
			
			protected function setStatus(message:String):void 
			{
				controls.setStatus(message);
				//trace(message);
			}
			
 			
		// --------------------------------------------------------------------------------------------------------
		// handlers - ui
		
			protected function onRecordClick(event:MouseEvent):void
			{
				trace(encoder.phase);
				if (encoder.phase !== VideoEncoder.PHASE_CAPTURING)
				{
					encoder.start();
				}
			}

			protected function onPlayClick(event:MouseEvent):void
			{
				if (encoder.phase == VideoEncoder.PHASE_FINISHED)
				{
					setStatus('Playing bytearray...');
					preview();
				}
			}
			
			protected function onSaveClick(event:MouseEvent):void
			{
				if (encoder.phase == VideoEncoder.PHASE_FINISHED)
				{
					setStatus('Saving flv...');
					fileref.save(encoder.bytes);
				}
			}
			
			protected function onUploadClick(e:MouseEvent):void 
			{
				if (encoder.phase == VideoEncoder.PHASE_FINISHED)
				{
					upload();
				}
			}
			
			protected function onLoadClick(event:MouseEvent):void 
			{
				if (encoder.phase == VideoEncoder.PHASE_FINISHED)
				{
					setStatus('Playing mp4 stream...');
					player.loadUrl(uploader.response.url);
				}
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// handlers - objects
		
			private function onEncoderEvent(event:VideoEncoderEvent):void 
			{
				// debug
				var type:String = event.type.replace('VideoEncoderEvent.', '').toLowerCase();
				
				// update controls
				setStatus('Encoder: ' + type);
				
				// special cases
				switch (event.type) 
				{
					case VideoEncoderEvent.LOADED:
						trace('Video encoder has loaded');
						start();
						break;
						
					case VideoEncoderEvent.READY:
						trace('Video encoder is ready');
						break;
						
					case VideoEncoderEvent.CAPTURED:
						onCapture();
						break;
						
					case VideoEncoderEvent.ENCODING:
						onEncode();
						break;
						
					case VideoEncoderEvent.FINISHED:
						onEncodeComplete();
						break;
						
					default:
				}
				
			}
			
			protected function onCapture():void 
			{
				controls.setProgress(encoder.frames / totalFrames);
				if (encoder.frames == totalFrames)
				{
					encoder.stop();
				}
			}
			
			protected function onEncode():void 
			{
				controls.setProgress(encoder.encodingProgress);
			}
			
			protected function onEncodeComplete():void 
			{
				setStatus('Video encoded in % seconds'.replace('%', encoder.duration.toFixed(2)));
				controls.btnPlay.enabled = true;
				controls.btnSave.enabled = true;
				controls.btnUpload.enabled = true;
				load();
				preview();
			}
			
			protected function onUploadComplete(event:Event):void 
			{
				navigateToURL(new URLRequest(uploader.response.url), 'video');
				setStatus('Video uploaded to: ' + uploader.response.url);
				controls.btnLoad.enabled = true;
			}
			
		
	}

}