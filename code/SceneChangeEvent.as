package  {
	import flash.events.Event;
	
	public class SceneChangeEvent extends Event {
		public static const SCENE_CHANGE = "sceneChange";
		
		public var sceneLink:IScene;

		public function SceneChangeEvent(type:String, sceneLink:IScene, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.sceneLink = sceneLink;
		}
		
	}
	
}
