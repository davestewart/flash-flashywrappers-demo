package core.media.video 
{
	import core.display.Element;
	import core.media.video.VideoPlayer;
	import fl.controls.Button;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;

	
	/**
	 * On-screen video rectangle and simple record / save buttons
	 * 
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends VideoPlayer 
	{
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// video
			protected var camera		:Camera;
			
			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function VideoRecorder(width:int = 400, height:int = 300) 
			{
				super(width, height);
			}
			
			override protected function initialize():void 
			{
				camera		= Camera.getCamera();
				camera.setMode(_width, _height, 25);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function initCamera():void
			{
				video.attachCamera(camera);
			}
			
	}

}