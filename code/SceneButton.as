package  {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class SceneButton extends Button 
	{
		// Scene this button points to, and will switch to once clicked
		private var sceneLink:IScene;

		public function SceneButton(x:int, y:int, text:String, sceneLink:IScene) {
			super(x, y);
			
			this.bText.text = text;
			
			this.sceneLink = sceneLink;
		}

		public override function Activate(e:Event)
		{
			// Triggers an event to change the scene from the scene that created this button
			dispatchEvent(new SceneChangeEvent(SceneChangeEvent.SCENE_CHANGE, sceneLink));
		}
	}
	
}
