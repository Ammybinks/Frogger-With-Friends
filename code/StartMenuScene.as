package  
	{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	public class StartMenuScene extends Scene
	{
		public function StartMenuScene(input:InputManager) 
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
			
			//// Create all text to write to screen
			
			var format:TextFormat = new TextFormat();
			format.size = 100;
			format.color = 0x000000;
			format.font = "Verdana";
			format.align = "center";
			
			var text = new TextField();
			text.type = "dynamic";
			text.text = "Frogger With Friends!";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width / 2;
			text.y = 85;

			entities.push(text);
			
			format.size = 30;
			
			text = new TextField();
			text.type = "dynamic";
			text.text = "A colour-matching puzzle game\nby Nye Blythe, Mariana Roque, Attila Gyor and Kacper Sliwinski";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width / 2;
			text.y = 200;

			entities.push(text);
			
			//// Create all buttons and add them to the scene
			
			var startButton:SceneButton = new SceneButton(CentreX, 400, "Start Game", new Level1Scene(input));
			// Add event listener to change the scene when the button has been pressed
			startButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(startButton);
			
			var instructionButton:SceneButton = new SceneButton(CentreX, 500, "Select Level", new LevelSelectScene(input));
			// Add event listener to change the scene when the button has been pressed
			instructionButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(instructionButton);
			
			var settingsButton:SceneButton = new SceneButton(CentreX, 600, "Input Settings", new SettingsScene(input, stage));
			// Add event listener to change the scene when the button has been pressed
			settingsButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(settingsButton);
		}
	}
	
}
