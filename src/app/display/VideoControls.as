package app.display 
{
	import core.display.Element;
	import core.media.video.VideoRecorder;
	import fl.controls.Button;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoControls extends Element 
	{

		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// objects
			private var recorder		:VideoRecorder;
			
			// ui
			public var btnRecord		:Button;
			public var btnPlay			:Button;
			public var btnSave			:Button;
			public var btnUpload		:Button;
			public var btnLoad			:Button;

			// status
			public var status			:TextField;
			public var progress			:Shape;
		
			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function VideoControls(parent:DisplayObjectContainer, recorder:VideoRecorder) 
			{
				super(parent);
				this.recorder			= recorder;
				y						= recorder.height + 10;
				build();
			}
		
			public function build():void
			{
				// UI
				btnRecord				= makeButton('Record');
				btnPlay					= makeButton('Play');
				btnSave					= makeButton('Save');
				btnUpload				= makeButton('Upload');
				btnLoad					= makeButton('Load');
				
				// status
				status					= new TextField();
				status.autoSize			= TextFieldAutoSize.LEFT;
				status.defaultTextFormat	= new TextFormat('_sans', 12);
				status.x				= 5;
				status.y				= 30;
				addChild(status);
				
				// encoding
				progress				= new Shape();
				progress.graphics.beginFill(0xFF0000);
				progress.graphics.drawRect(0, 0, recorder.width, 5);
				progress.scaleX			= 0;
				progress.y				= -10;
				addChild(progress);
			}
			
			protected function makeButton(label:String, enabled:Boolean = false):Button 
			{
				var button:Button		= new Button();
				button.label			= label;
				button.width			= 100;
				button.x				= (numChildren * 110);
				button.enabled			= enabled;
				return addChild(button) as Button;
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function setStatus(value:String):void 
			{
				status.text = value.replace('VideoEncoder.', '');
			}
			
			public function setProgress(value:Number):void 
			{
				progress.scaleX = value;
			}
		

		
	}

}