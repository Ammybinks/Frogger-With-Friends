package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class InputManager {
		var anyHeld:Boolean = false;
		var leftHeld:Boolean = false;
		var rightHeld:Boolean = false;
		var upHeld:Boolean = false;
		var downHeld:Boolean = false;
		var undoHeld:Boolean = false;
		var restartHeld:Boolean = false;
		
		var anyPressed:Boolean = false;
		var leftPressed:Boolean = false;
		var rightPressed:Boolean = false;
		var upPressed:Boolean = false;
		var downPressed:Boolean = false;
		var undoPressed:Boolean = false;
		var restartPressed:Boolean = false;
		
		var anyReleased:Boolean = false;
		var leftReleased:Boolean = false;
		var rightReleased:Boolean = false;
		var upReleased:Boolean = false;
		var downReleased:Boolean = false;
		var undoReleased:Boolean = false;
		var restartReleased:Boolean = false;
		
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
			// Set all Pressed values to false, to ensure they've only been active for a single frame
			anyPressed = false;
			leftPressed = false;
			rightPressed = false;
			upPressed = false;
			downPressed = false;
			undoPressed = false;
			restartPressed = false;
			
			anyTapped = false;
			leftTapped = false;
			rightTapped = false;
			upTapped = false;
			downTapped = false;
			undoTapped = false;
			restartTapped = false;
		}
		
		private function KeyPressed(e:KeyboardEvent):void {
			anyPressed = true;
			
			switch (e.keyCode) {
				case 65:
					leftPressed = true;
					if(!leftHeld)
					{
						anyTapped = true;
						leftTapped = true;
						leftHeld = true;
					}
					break;
				case 68:
					rightPressed = true;
					if(!rightHeld)
					{
						anyTapped = true;
						rightTapped = true;
						rightHeld = true;
					}
					break;
				case 87:
					upPressed = true;
					if(!upHeld)
					{
						anyTapped = true;
						upTapped = true;
						upHeld = true;
					}
					break;
				case 83:
					downPressed = true;
					if(!downHeld)
					{
						anyTapped = true;
						downTapped = true;
						downHeld = true;
					}
					break;
				case 90:
					undoPressed = true;
					if(!undoHeld)
					{
						anyTapped = true;
						undoTapped = true;
						undoHeld = true;
					}
					break;
				case 82:
					restartPressed = true;
					if(!restartHeld)
					{
						anyTapped = true;
						restartTapped = true;
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
