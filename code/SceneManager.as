package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	
	public class SceneManager extends MovieClip {
		// The global input manager, which is passed to each scene
		private var input:InputManager;
		
		private var stageRef:Object; // Stores a reference to the kernel's stageRef, to pass to each scene as necessary

		private var entities:Vector.<Object> = new Vector.<Object>(); //entity list
		
		private var current:IScene = null; // Scene currently being used
		public function set Current(value:IScene):void { current = value }
		
		public function SceneManager(stage:Object)
		{
			input = new InputManager(stage, this);

			stageRef = stage;
			
			current = new StartMenuScene(input);
			
			NewScene();
		}
			
		public function Update():void
		{
			current.Update();
			
			// Update input listener
			input.Update();
			
			// If scene has changed
			if(current.Next != null && !current.Unloading)
			{
				// Begin unloading content and switching scenes
				UnloadContent();
			}
		}
			
		// Calls both functions required to initialise a new scene in order
		public function NewScene():void
		{
			Initialise();
			LoadContent();
		}
			
		private function Initialise():void
		{
			current.Entities = entities;
			current.Initialise(stageRef);
		}

		private function LoadContent():void
		{
			current.LoadContent(stageRef);
		}
		
		// Unloads all content from the current scene before initialising the new one
		private function UnloadContent():void
		{
			current = current.UnloadContent(stageRef);
				
			NewScene();
		}

	}
	
}
