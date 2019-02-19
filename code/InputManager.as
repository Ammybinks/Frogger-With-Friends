package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	
	public class InputManager {
		var body:MovieClip;
		
		// Boolean values that store the current state of each key
		var left:Boolean = false;
		var right:Boolean = false;
		var up:Boolean = false;
		var down:Boolean = false;
		
		var currentKey:int = 0;
		
		public function InputManager(pKernel:MovieClip) {
			pKernel.stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed);
			pKernel.stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleased);
		}

		public function Update() {
			// Traces the keyCode of the most recently held key, for debugging purposes
			if(currentKey != 0)
			{
				trace(currentKey);
			}
		}
		
		// Store the state of any key that's pressed
		private function KeyPressed(e:KeyboardEvent) {
			currentKey = e.keyCode;
			
			switch (e.keyCode) {
				case 65:
					left = true;
					break;
				case 68:
					right = true;
					break;
				case 87:
					up = true;
					break;
				case 83:
					down = true;
					break;
			}
		}
		
		// Update the state of any key that's no longer being pressed
		private function KeyReleased(e:KeyboardEvent) {
			currentKey = 0;
			
			switch (e.keyCode) {
				case 65:
					left = false;
					break;
				case 68:
					right = false;
					break;
				case 87:
					up = false;
					break;
				case 83:
					down = false;
					break;
			}
		}
		
	}
	
}
