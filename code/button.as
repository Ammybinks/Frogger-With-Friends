package  
{
	import flash.events.Event; //Import Events
	import flash.events.MouseEvent; //Import mouse event
	import flash.display.MovieClip; //Import Movie clip	
	
	public class button extends MovieClip
	{
		//data members
		var clicked = false;
		var SceneLink:Object;
		var ParentMenu:Object;
			
		// constructor code
		public function button(pY:int, pX:int, pMenu:Object, pText:String) //methid passing y, x, menu, text parameters
		{
			y = pY;
			x = pX;
			ParentMenu = pMenu;
			
			addEventListener(MouseEvent.CLICK,ClickEvent)
			this.bText.text = pText;
			
		}

		public function ClickEvent(e:Event)
		{
			trace ("I have been created")
			ParentMenu.Next = SceneLink; 
		}
	}
	
}
