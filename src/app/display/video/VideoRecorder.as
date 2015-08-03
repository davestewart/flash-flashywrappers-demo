package app.display.video 
{
	import app.display.Element;
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
		
			public function VideoRecorder(parent:DisplayObjectContainer = null, width:int = 400, height:int = 300) 
			{
				// super
				super(parent, width, height);
				
				// camera
				camera		= Camera.getCamera();
				camera.setMode(_width, _height, 25);
				
			}
			
			public function initCamera():void
			{
				video.attachCamera(camera);
			}
			
	}

}