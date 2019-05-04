package  
	{
	import flash.display.MovieClip; //Import Movie clip
	import flash.events.Event; //Import Events
	
	//Class
	public class StartMenuScene extends MovieClip implements IScene
	{
		// List of objects to update every frame
		private var entities:Vector.<Object> = new Vector.<Object>();
		public function get Entities():Vector.<Object> { return entities; }
		public function set Entities(value:Vector.<Object>):void { entities = value; }
		
		private var next:IScene;
		public function get Next():IScene { return next; }
		public function set Next(value:IScene):void { next = value; }
		
		private var unloading:Boolean = false;
		public function get Unloading():Boolean { return unloading; }
		
		// constructor 
		public function StartMenuScene() 
		{
			
		}
		
		public function Initialise(stage:Object):void //Initialise Method
		{
			var scene = new GameScene();
			
			var CentreX = stage.width / 2;
			
			var StartButton:button = new button(100, CentreX, this, "Start Game");
			StartButton.SceneLink = new Level1Scene();
			entities.push(StartButton);
			
			var InstructionButton:button = new button(200, CentreX, this, "Start Game");
			InstructionButton.SceneLink = new Level2Scene;
			entities.push(InstructionButton);
			
			var ExitButton:button = new button(300, CentreX, this, "Start Game");
			ExitButton.SceneLink = new Level3Scene;
			entities.push(ExitButton);
		}

		public function LoadContent(stage:Object):void // Load content Method
		{
			for(var i:int = 0; i < entities.length; i++)
			{
				stage.addChild(entities[i]);
			}
		}
		
		public function UnloadContent(stage:Object):IScene//Unload content method
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
		
		public function Update():void //Update method
		{
			
				
		}

	}
	
}
