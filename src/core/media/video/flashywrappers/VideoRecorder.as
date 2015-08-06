package core.media.video.flashywrappers 
{
	import core.media.video.VideoRecorder;
	import flash.display.DisplayObjectContainer;
	import core.media.video.flashywrappers.VideoEncoder;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends core.media.video.VideoRecorder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
			protected var encoder		:VideoEncoder;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(parent:DisplayObjectContainer=null, width:int=400, height:int=300) 
			{
				super(parent, width, height);
			}
			
			override protected function initialize():void 
			{
				super.initialize();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}