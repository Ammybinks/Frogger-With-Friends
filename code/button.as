package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class Button extends MovieClip
	{
		public function Button(x:int, y:int)
		{
			this.x = x;
			this.y = y;
			
			addEventListener(MouseEvent.CLICK, Activate);
		}

		public function Activate(e:Event)
		{
		}
	}
	
}
