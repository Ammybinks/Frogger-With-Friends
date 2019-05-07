package  
{

	import flash.display.MovieClip; //Import Movie clip
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
	
	public class StarScene extends Scene
	{
		// Stores the complete string to display during the scene
		private var winText:String; 
		
		// Linked scene passed from the previous level, determines what scene to switch to after this one is complete
		private var link:IScene;
	
		// constructor code
		public function StarScene(starCount:int, turnCount:int, link:IScene, input:InputManager) 
		{		
			super(input)
			
			this.link = link;

			// Determine how many stars to add to the string
			var totalStars:String = "*";

			for (var i:int; i < starCount - 1; i++)
			{
				totalStars = "*  " + totalStars;
			}
			
			// Create final string to be displayed
			winText = "Congratulations!\n\n" + totalStars + "\nYou won in " + turnCount + " turns.\n\nPress any key to continue!";
		}
			
		// Initialise all values and objects to be added to the screen
		public override function Initialise(stage:Object):void
		{
			// Initialise text field to print text to screen
			
			var format:TextFormat = new TextFormat();
			format.size = 40;
			format.color = 0x000000;
			format.font = "Verdana";
			format.align = "center";
			
			var text = new TextField();
			text.text = winText;
			text.type = "dynamic";
			text.border = false;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;

			text.setTextFormat(format);
			
			text.x = (stage.stageWidth / 2) - (text.width / 2);
			text.y = (stage.stageHeight / 2) - (text.height / 2);
			entities.push(text);
		}
		
		public override function Update():void
		{
			// If the user has pressed any key
			if (input.AnyTapped)
			{
				// Switch to the next scene
				next = link
			}	
		}
	}
	
}
