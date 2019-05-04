package  {
	
	import flash.events.Event; //Import Events
	import flash.events.MouseEvent; //Import mouse event
	import flash.display.MovieClip; //Import Movie clip	
	
	public class ExitButton extends Button {
		// constructor code
		public function ExitButton(pY:int, pX:int, pMenu:Object, pText:String) // Constructor passing y, x, menu, text parameters
		{
			super(pY, pX, pMenu, pText);
		}

		public override function ClickEvent(e:Event)
		{
		}

	}
	
}
