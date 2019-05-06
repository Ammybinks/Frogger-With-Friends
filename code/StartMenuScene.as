package  
	{
	import flash.display.MovieClip; //Import Movie clip
	import flash.events.Event; //Import Events
	
	//Class
	public class StartMenuScene extends MovieClip implements IScene
	{
		private var input:InputManager;
		
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
		public function StartMenuScene(input:InputManager) 
		{
			this.input = input;
		}
		
		public function Initialise(stage:Object):void //Initialise Method
		{
			var scene = new GameScene(input);
			
			var CentreX = stage.stageWidth / 2;
			
			var startButton:Button = new Button(100, CentreX, this, "Start Game");
			startButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			startButton.SceneLink = new Level1Scene(input);
			entities.push(startButton);
			
			var instructionButton:Button = new Button(200, CentreX, this, "Select Level");
			instructionButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			instructionButton.SceneLink = new LevelSelectScene(input);
			
			entities.push(instructionButton);
			
			var settingsButton:Button = new Button(300, CentreX, this, "Input Settings");
			settingsButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			settingsButton.SceneLink = new SettingsScene(input);
			entities.push(settingsButton);
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

		public function ChangeScene(e:SceneChangeEvent)
		{
			next = e.sceneLink;
		}
	}
	
}
