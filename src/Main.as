package
{
	import app.display.video.VideoControls;
	import app.display.video.VideoRecorder;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import core.media.encoder.VideoEncoderEvent;
	import core.media.encoder.VideoEncoder;
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
				
				// controls
				controls			= new VideoControls(this, recorder);
				controls.btnRecord.addEventListener(MouseEvent.CLICK, onRecordClick);
				controls.btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
				controls.btnSave.addEventListener(MouseEvent.CLICK, onSaveClick);
				controls.btnUpload.addEventListener(MouseEvent.CLICK, onUploadClick);
				
				// encoder
				encoder				= new VideoEncoder(recorder, 5 * 25, 12.5);
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
				encoder.load('lib/FW_SWFBridge_ffmpeg.swf');
			}
			
			protected function preview():void 
			{
				// connection
				var connection	:NetConnection	= new NetConnection();
				connection.connect(null);
				
				// stream + bytes
				var stream		:NetStream		= new NetStream(connection);
				var bytes		:ByteArray		= encoder.getVideo();
				
				// set up netstream
				stream.play(null);
				stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN); 
				stream.appendBytes(bytes);
				
				// attach to video
				recorder.video.attachNetStream(stream);
				stream.seek(1);
			}
			
			protected function upload():void
			{
				uploader.upload(encoder.getVideo());
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
					preview();
				}
			}
			
			protected function onSaveClick(event:MouseEvent):void
			{
				if (encoder.phase == VideoEncoder.PHASE_FINISHED)
				{
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
			
			// Encoder
			
			private function onEncoderEvent(event:VideoEncoderEvent):void 
			{
				// debug
				trace('event:', event.type);
				
				// update controls
				controls.setStatus(encoder.phase);
				
				// special cases
				switch (event.type) 
				{
					case VideoEncoderEvent.READY:
						trace('Video encoder is ready!');
						break;
						
					case VideoEncoderEvent.ENCODING:
						controls.setProgress(encoder.getEncodingProgress());
						break;
						
					case VideoEncoderEvent.CAPTURED:
						controls.setProgress(encoder.currentFrame / encoder.totalFrames);
						break;
						
					case VideoEncoderEvent.FINISHED:
						trace('Video encoded in % seconds'.replace('%', encoder.duration.toFixed(2)));
						preview();
						break;
						
					default:
				}
				
			}
			
			// Uploader
			
			protected function onUploadComplete(event:Event):void 
			{
				navigateToURL(new URLRequest(uploader.response.url), 'video');
			}
			
		
	}

}