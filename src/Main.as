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
		
			// video
			protected var player		:VideoPlayer;
			protected var recorder		:VideoRecorder;
			protected var encoder		:VideoEncoder;
			
			// objects
			protected var uploader		:Uploader;
			protected var fileref		:FileRef;
			
			// elements
			public var controls			:VideoControls;
			
			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function Main() 
			{
				build();
				start();
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
				
				// encoder
				encoder				= new VideoEncoder(recorder, 5 * 25, 12.5, 'mp4');
				encoder.addEventListener(VideoEncoderEvent.LOADING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.LOADED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.INITIALIZING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.READY, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.CAPTURED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.ENCODING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.FINISHED, onEncoderEvent);
				
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
				encoder.load(); // 'lib/FW_SWFBridge_ffmpeg.swf'
			}
			
			protected function load():void 
			{
				player.loadBytes(encoder.getVideo());
			}
			
			protected function preview():void 
			{
				player.play();
				
			}
			
			protected function upload():void
			{
				uploader.upload(encoder.getVideo());
			}
			
			protected function setStatus(message:String):void 
			{
				controls.setStatus(message);
				trace(message);
			}
			
 			
		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			// UI
		
			protected function onRecordClick(event:MouseEvent):void
			{
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
					fileref.save(encoder.getVideo());
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
			
			// Encoder
			
			private function onEncoderEvent(event:VideoEncoderEvent):void 
			{
				// debug
				trace('event:', event.type);
				
				// update controls
				setStatus('Encoder: ' + encoder.phase);
				
				// special cases
				switch (event.type) 
				{
					case VideoEncoderEvent.READY:
						trace('Video encoder is ready!');
						recorder.initCamera();
						controls.btnRecord.enabled = true;
						break;
						
					case VideoEncoderEvent.ENCODING:
						controls.setProgress(encoder.getEncodingProgress());
						break;
						
					case VideoEncoderEvent.CAPTURED:
						controls.setProgress(encoder.currentFrame / encoder.totalFrames);
						break;
						
					case VideoEncoderEvent.FINISHED:
						setStatus('Video encoded in % seconds'.replace('%', encoder.duration.toFixed(2)));
						controls.btnPlay.enabled = true;
						controls.btnSave.enabled = true;
						controls.btnUpload.enabled = true;
						load();
						preview();
						break;
						
					default:
				}
				
			}
			
			// Uploader
			
			protected function onUploadComplete(event:Event):void 
			{
				navigateToURL(new URLRequest(uploader.response.url), 'video');
				setStatus('Video uploaded to: ' + uploader.response.url);
				controls.btnLoad.enabled = true;
			}
			
		
	}

}