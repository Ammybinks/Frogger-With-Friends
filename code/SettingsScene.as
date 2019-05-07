package  {
	import flash.display.MovieClip; //Import Movie clip
	import flash.events.Event; //Import Events
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	public class SettingsScene extends Scene implements ISettingsScene {
		// Stores a reference to the stage
		private var stageRef:Object;
		
		// Stores which button has been clicked and is waiting for a response
		private var listening:KeyButton;
		public function get Listening():KeyButton { return listening; }
		
		public function SettingsScene(input:InputManager, stageRef:Object) 
		{
			super(input);
			
			this.stageRef = stageRef;
		}

		// Initialise all values and objects to be added to the screen
		public override function Initialise(stage:Object):void
		{
			// Return the program's focus to the stage, if it wasn't there already.
			// Solves problems with inputs not registering after a button has been pressed
			stage.focus = stage;
			
			//// Initialise set buttons and text
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.color = 0x333333;
			format.font = "Verdana";
			format.align = "right";
			
			var CentreX = stage.stageWidth / 2;
			
			var setLeftButton:KeyButton = new KeyButton(CentreX + 50, 100, input.LeftCode.toString(), input.SetLeftCode, this);
			entities.push(setLeftButton);
			
			var text = new TextField();
			text.type = "dynamic";
			text.text = "Left:";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width;
			text.y = 85;

			entities.push(text);
			
			
			var setRightButton:KeyButton = new KeyButton(CentreX + 50, 150, input.RightCode.toString(), input.SetRightCode, this);
			entities.push(setRightButton);
			
			text = new TextField();
			text.type = "dynamic";
			text.text = "Right:";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width;
			text.y = 135;

			entities.push(text);
			
			
			var setUpButton:KeyButton = new KeyButton(CentreX + 50, 200, input.UpCode.toString(), input.SetUpCode, this);
			entities.push(setUpButton);
			
			text = new TextField();
			text.type = "dynamic";
			text.text = "Up:";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width;
			text.y = 185;

			entities.push(text);
			
			
			var setDownButton:KeyButton = new KeyButton(CentreX + 50, 250, input.DownCode.toString(), input.SetDownCode, this);
			entities.push(setDownButton);
			
			text = new TextField();
			text.type = "dynamic";
			text.text = "Down:";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width;
			text.y = 235;

			entities.push(text);
			
			
			var setUndoButton:KeyButton = new KeyButton(CentreX + 50, 300, input.UndoCode.toString(), input.SetUndoCode, this);
			entities.push(setUndoButton);
			
			text = new TextField();
			text.type = "dynamic";
			text.text = "Undo:";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width;
			text.y = 285;

			entities.push(text);
			
			
			var setRestartButton:KeyButton = new KeyButton(CentreX + 50, 350, input.RestartCode.toString(), input.SetRestartCode, this);
			entities.push(setRestartButton);
			
			text = new TextField();
			text.type = "dynamic";
			text.text = "Restart:";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			text.setTextFormat(format);
			
			text.x = CentreX - text.width;
			text.y = 335;

			entities.push(text);
			
			
			// Initialise button to return to the main menu
			var quitButton:SceneButton = new SceneButton(CentreX, 600, "Back", new StartMenuScene(input));
			quitButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(quitButton);
		}

		
		public override function Update():void
		{
			// If an option has been selected and the user has pressed a button
			if(listening && input.AnyPressed)
			{
				// As long as that button is unique and not esc
				if(input.CheckUnique(input.CurrentCode) && input.CurrentCode != input.EscapeCode)
				{
					// Change the current code for this key to the key pressed
					listening.setTarget.call(listening, input.CurrentCode);
					// Return the button to its original state, maintaining its updated text
					listening.Deactivate(input.CurrentCode.toString());
				}
				else
				{
					// Return the button to its original state, with its original text
					listening.Deactivate(listening.oldText);
				}
				
				listening = null;
			}
		}
		
		public function BeginListen(button:KeyButton):void
		{
			listening = button;
			stageRef.focus = stageRef;
		}
	}
	
}
