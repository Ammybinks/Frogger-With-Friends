package  
{
	import flash.events.Event; //Import Events
	import flash.events.MouseEvent; //Import mouse event
	import flash.display.MovieClip; //Import Movie clip	
	
	public class Button extends MovieClip
	{
		//data members
		private var sceneLink:IScene;
		public function set SceneLink(value:IScene) { sceneLink = value; }
		
		private var parentMenu:IScene;
			
		// constructor code
		public function Button(y:int, x:int, parentMenu:IScene, text:String) // Constructor passing y, x, menu, text parameters
		{
			this.y = y;
			this.x = x;
			this.parentMenu = parentMenu;
			this.bText.text = text;
			
			addEventListener(MouseEvent.CLICK,ClickEvent);
		}

		public function ClickEvent(e:Event)
		{
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.SCENE_CHANGE, sceneLink));
		}
	}
	
}
