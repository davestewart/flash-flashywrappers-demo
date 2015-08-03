package app.display 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Element extends Sprite 
	{
		
		public function Element(parent:DisplayObjectContainer = null, x:int = 0, y:int = 0) 
		{
			if (parent)
			{
				parent.addChild(this);
			}
			moveTo(x, y);
		}
		
		public function moveTo(x:int = 0, y:int = 0):Element
		{
			this.x = x;
			this.y = y;
			return this;
		}
		
	}

}

