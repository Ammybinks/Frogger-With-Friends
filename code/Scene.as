package  {
	import flash.display.MovieClip; //Import Movie clip
	import flash.events.Event; //Import Events
	
	
	public class Scene extends MovieClip implements IScene {
		// Stores a reference to the global input manager
		internal var input:InputManager;
		
		// List of objects to update every frame
		internal var entities:Vector.<Object> = new Vector.<Object>();
		public function get Entities():Vector.<Object> { return entities; }
		public function set Entities(value:Vector.<Object>):void { entities = value; }
		
		// The scene this one is currently switching to, null while the scene is running
		internal var next:IScene;
		public function get Next():IScene { return next; }
		public function set Next(value:IScene):void { next = value; }
		
		// Stores whether the scene has begun unloading
		internal var unloading:Boolean = false;
		public function get Unloading():Boolean { return unloading; }
		
		public function Scene(input:InputManager)
		{
			this.input = input;
		}
		
		// Initialise all values and objects to be added to the screen
		public function Initialise(stage:Object):void
		{
			stage.focus = stage;
		}

		// Place every entity on the stage
		public function LoadContent(stage:Object):void
		{
			for(var i:int = 0; i < entities.length; i++)
			{
				stage.addChild(entities[i]);
			}
		}
		
		// Removes every entity from the stage to prepare for the next scene to load
		public function UnloadContent(stage:Object):IScene
		{
			unloading = true;

			Next.Entities = entities;
			
			for(var i:int = 0; i < entities.length; i++)
			{
				stage.removeChild(entities[i]);
			}
			
			entities.length = 0;
			
			return next;
		}
		
		public function Update():void
		{
		}

		// Event called by SceneButtons to change the scene when they're clicked
		public function ChangeScene(e:SceneChangeEvent)
		{
			next = e.sceneLink;
		}
	}
	
}
