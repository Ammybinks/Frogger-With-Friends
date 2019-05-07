package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LevelSelectScene extends Scene
	{
		public function LevelSelectScene(input:InputManager) 
		{
			super(input);
		}

		// Initialise all values and objects to be added to the screen
		public override function Initialise(stage:Object):void
		{
			// Return the program's focus to the stage, if it wasn't there already.
			// Solves problems with inputs not registering after a button has been pressed
			stage.focus = stage;
			
			var CentreX = stage.stageWidth / 2;

			//// Initialise buttons to each level
			
			var levelOneButton:SceneButton = new SceneButton(CentreX, 100, "Level 1", new Level1Scene(input));
			levelOneButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(levelOneButton);
			
			var levelTwoButton:SceneButton = new SceneButton(CentreX, 200, "Level 2", new Level2Scene(input));
			levelTwoButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(levelTwoButton);
			
			var levelThreeButton:SceneButton = new SceneButton(CentreX, 300, "Level 3", new Level3Scene(input));
			levelThreeButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(levelThreeButton);
			
			// Initialise button linked to the main menu
			var quitButton:SceneButton = new SceneButton(CentreX, 600, "Back", new StartMenuScene(input));
			quitButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(quitButton);
		}
	}
	
}
