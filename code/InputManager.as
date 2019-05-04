package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class InputManager {
		var leftHeld:Boolean = false;
		var rightHeld:Boolean = false;
		var upHeld:Boolean = false;
		var downHeld:Boolean = false;
		var undoHeld:Boolean = false;
		var restartHeld:Boolean = false;
		
		var anyTapped:Boolean = false;
		var leftTapped:Boolean = false;
		var rightTapped:Boolean = false;
		var upTapped:Boolean = false;
		var downTapped:Boolean = false;
		var undoTapped:Boolean = false;
		var restartTapped:Boolean = false;
		
		public function InputManager(stage:Object):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleased);
		}

		public function Update():void {
			// Set all tapped values to false, to ensure they've only been active for a single frame
			anyTapped = false;
			leftTapped = false;
			rightTapped = false;
			upTapped = false;
			downTapped = false;
			undoTapped = false;
			restartTapped = false;
		}
		
		private function KeyPressed(e:KeyboardEvent):void {
			anyTapped = true;
			
			switch (e.keyCode) {
				case 65:
					leftTapped = true;
					if(!leftHeld)
					{
						leftHeld = true;
					}
					break;
				case 68:
					rightTapped = true;
					if(!rightHeld)
					{
						rightHeld = true;
					}
					break;
				case 87:
					upTapped = true;
					if(!upHeld)
					{
						upHeld = true;
					}
					break;
				case 83:
					downTapped = true;
					if(!downHeld)
					{
						downHeld = true;
					}
					break;
				case 90:
					undoTapped = true;
					if(!undoHeld)
					{
						undoHeld = true;
					}
					break;
				case 82:
					restartTapped = true;
					if(!restartHeld)
					{
						restartHeld = true;
					}
					break;
			}
		}
		
		private function KeyReleased(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 65:
					leftHeld = false;
					break;
				case 68:
					rightHeld = false;
					break;
				case 87:
					upHeld = false;
					break;
				case 83:
					downHeld = false;
					break;
				case 90:
					undoHeld = false;
					break;
				case 82:
					restartHeld = false;
					break;
			}
		}
		
	}
	
}
