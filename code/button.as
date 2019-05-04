package  
{
	import flash.events.Event; //Import Events
	import flash.events.MouseEvent; //Import mouse event
	import flash.display.MovieClip; //Import Movie clip	
	
	public class Button extends MovieClip
	{
		//data members
		var clicked = false;
		var SceneLink:Object;
		var ParentMenu:Object;
			
		// constructor code
		public function Button(pY:int, pX:int, pMenu:Object, pText:String) // Constructor passing y, x, menu, text parameters
		{
			y = pY;
			x = pX;
			ParentMenu = pMenu;
			
			addEventListener(MouseEvent.CLICK,ClickEvent);
			this.bText.text = pText;
			
		}

		public function ClickEvent(e:Event)
		{
			ParentMenu.Next = SceneLink; 
		}
	}
	
}
