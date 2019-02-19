package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	public class Kernel extends MovieClip {
		var input:InputManager;
		
		var updateables:Array = new Array();
		
		var frog:MovieClip;

		public function Kernel() {
			addEventListener(Event.ADDED_TO_STAGE, Loaded);
			addEventListener(Event.ENTER_FRAME, Update);
		}

		public function Loaded(e:Event) {
			trace("Hello World!");
			
			frog = new PlayerFrog(this);
			
			frog.x = stage.stageWidth / 2;
			frog.y = stage.stageHeight / 2;
			
			updateables.push(frog);
			stage.addChild(frog);
			
			input = new InputManager(this);
			
			removeEventListener(Event.ADDED_TO_STAGE, Loaded);
		}
		
		public function Update(e:Event) {
			input.Update();
			
			for(var i:int = 0; i < updateables.length; i++)
			{
				updateables[i].Update();
			}
		}
	}
	
}
