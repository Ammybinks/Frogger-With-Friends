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
		private var input:InputManager;
		
		private var stageRef:Object; // Stores a reference to the kernel's stageRef, to pass to each scene as necessary

		private var entities:Vector.<Object> = new Vector.<Object>(); //entity list
		
		private var current:IScene = null; //Current scene
		public function set Current(value:IScene):void { current = value }
		
		public function SceneManager(stage:Object)
		{
			input = new InputManager(stage, this);

			stageRef = stage;
			
			current = new StartMenuScene(input);
			
			NewScene();
		}
			
		private function StartGame(e:Event) //Start game Method
		{

		}
		
		public function Update():void //Update method
		{
			current.Update();
			
			// Update input listener
			input.Update();
			
			if(current.Next != null && !current.Unloading)
			{
				UnloadContent();
			}
		}
			
		public function NewScene():void //New scene Method
		{
			Initialise(); //Call Initialise Method
			LoadContent(); //Call Loadcontent Method
		}
			
		private function Initialise():void //Initialise Method
		{
			current.Entities = entities;
			current.Initialise(stageRef);
		}

		private function LoadContent():void //Load content method
		{
			current.LoadContent(stageRef);
		}
		
		private function UnloadContent():void //Unload content method
		{
			current = current.UnloadContent(stageRef);
				
			NewScene();
		}

	}
	
}
