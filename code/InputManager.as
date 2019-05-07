package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class InputManager {
		// Key code for the most recently pressed key
		private var currentCode:int;
		public function get CurrentCode():int { return currentCode; }
		
		//// Reference codes for each key, checked against whenever a new key is pressed
		private var leftCode:int = 65;
		public function get LeftCode():int { return leftCode; }
		public function SetLeftCode(value:int):void { leftCode = value; }
		
		private var rightCode:int = 68;
		public function get RightCode():int { return rightCode; }
		public function SetRightCode(value:int):void { rightCode = value; }
		
		private var upCode:int = 87;
		public function get UpCode():int { return upCode; }
		public function SetUpCode(value:int):void { upCode = value; }
		
		private var downCode:int = 83;
		public function get DownCode():int { return downCode; }
		public function SetDownCode(value:int):void { downCode = value; }
		
		private var undoCode:int = 90;
		public function get UndoCode():int { return undoCode; }
		public function SetUndoCode(value:int):void { undoCode = value; }
		
		private var restartCode:int = 82;
		public function get RestartCode():int { return restartCode; }
		public function SetRestartCode(value:int):void { restartCode = value; }
		
		private var escapeCode:int = 27;
		public function get EscapeCode():int { return escapeCode; }
		
		
		//// Held values for each key, true for as long as said key is held down
		private var anyHeld:Boolean = false;
		public function get AnyHeld():Boolean { return anyHeld; }
		
		private var leftHeld:Boolean = false;
		public function get LeftHeld():Boolean { return leftHeld; }
		
		private var rightHeld:Boolean = false;
		public function get RightHeld():Boolean { return rightHeld; }
		
		private var upHeld:Boolean = false;
		public function get UpHeld():Boolean { return upHeld; }
		
		private var downHeld:Boolean = false;
		public function get DownHeld():Boolean { return downHeld; }
		
		private var undoHeld:Boolean = false;
		public function get UndoHeld():Boolean { return undoHeld; }
		
		private var restartHeld:Boolean = false;
		public function get RestartHeld():Boolean { return restartHeld; }
		
		private var escapeHeld:Boolean = false;
		public function get EscapeHeld():Boolean { return escapeHeld; }
		
		
		//// Pressed values for each key, true the first time a key is pressed and then repeats over time as the key remains held
		private var anyPressed:Boolean = false;
		public function get AnyPressed():Boolean { return anyPressed; }
		
		private var leftPressed:Boolean = false;
		public function get LeftPressed():Boolean { return leftPressed; }
		
		private var rightPressed:Boolean = false;
		public function get RightPressed():Boolean { return rightPressed; }
		
		private var upPressed:Boolean = false;
		public function get UpPressed():Boolean { return upPressed; }
		
		private var downPressed:Boolean = false;
		public function get DownPressed():Boolean { return downPressed; }
		
		private var undoPressed:Boolean = false;
		public function get UndoPressed():Boolean { return undoPressed; }
		
		private var restartPressed:Boolean = false;
		public function get RestartPressed():Boolean { return restartPressed; }
		
		private var escapePressed:Boolean = false;
		public function get EscapePressed():Boolean { return escapePressed; }
		
		
		//// Released values for each key, true the first frame a key is released
		private var anyReleased:Boolean = false;
		public function get AnyReleased():Boolean { return anyReleased; }
		
		private var leftReleased:Boolean = false;
		public function get LeftReleased():Boolean { return leftReleased; }
		
		private var rightReleased:Boolean = false;
		public function get RightReleased():Boolean { return rightReleased; }
		
		private var upReleased:Boolean = false;
		public function get UpReleased():Boolean { return upReleased; }
		
		private var downReleased:Boolean = false;
		public function get DownReleased():Boolean { return downReleased; }
		
		private var undoReleased:Boolean = false;
		public function get UndoReleased():Boolean { return undoReleased; }
		
		private var restartReleased:Boolean = false;
		public function get RestartReleased():Boolean { return restartReleased; }
		
		private var escapeReleased:Boolean = false;
		public function get EscapeReleased():Boolean { return escapeReleased; }
		
		
		//// Tapped values for each key, true only the first frame a key is pressed
		private var anyTapped:Boolean = false;
		public function get AnyTapped():Boolean { return anyTapped; }
		
		private var leftTapped:Boolean = false;
		public function get LeftTapped():Boolean { return leftTapped; }
		
		private var rightTapped:Boolean = false;
		public function get RightTapped():Boolean { return rightTapped; }
		
		private var upTapped:Boolean = false;
		public function get UpTapped():Boolean { return upTapped; }
		
		private var downTapped:Boolean = false;
		public function get DownTapped():Boolean { return downTapped; }
		
		private var undoTapped:Boolean = false;
		public function get UndoTapped():Boolean { return undoTapped; }
		
		private var restartTapped:Boolean = false;
		public function get RestartTapped():Boolean { return restartTapped; }
		
		private var escapeTapped:Boolean = false;
		public function get EscapeTapped():Boolean { return escapeTapped; }
		

		
		public function InputManager(stage:Object, caller:Object):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleased);
		}

		public function Update():void {
			// Set all necessary values to false, to ensure they've only been active for a single frame
			
			anyPressed = false;
			leftPressed = false;
			rightPressed = false;
			upPressed = false;
			downPressed = false;
			undoPressed = false;
			restartPressed = false;
			escapePressed = false;
			
			anyReleased = false;
			leftReleased = false;
			rightReleased = false;
			upReleased = false;
			downReleased = false;
			undoReleased = false;
			restartReleased = false;
			escapeReleased = false;
		
			anyTapped = false;
			leftTapped = false;
			rightTapped = false;
			upTapped = false;
			downTapped = false;
			undoTapped = false;
			restartTapped = false;
			escapeTapped = false;
		}
		
		// Checks if a key code is currently in use by any other key
		public function CheckUnique(keyCode:int):Boolean {
			if (keyCode != leftCode &&
				keyCode != rightCode &&
				keyCode != upCode &&
				keyCode != downCode &&
				keyCode != undoCode &&
				keyCode != restartCode)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function KeyPressed(e:KeyboardEvent):void {
			currentCode = e.keyCode;
			
			anyPressed = true;
			
			// For each action, checks if the key code of this event corresponds to that key, setting pressed, held and tapped values to true if it does
			switch (currentCode) {
				case leftCode:
					leftPressed = true;
					if(!leftHeld)
					{
						anyTapped = true;
						leftTapped = true;
						leftHeld = true;
					}
					break;
				case rightCode:
					rightPressed = true;
					if(!rightHeld)
					{
						anyTapped = true;
						rightTapped = true;
						rightHeld = true;
					}
					break;
				case upCode:
					upPressed = true;
					if(!upHeld)
					{
						anyTapped = true;
						upTapped = true;
						upHeld = true;
					}
					break;
				case downCode:
					downPressed = true;
					if(!downHeld)
					{
						anyTapped = true;
						downTapped = true;
						downHeld = true;
					}
					break;
				case undoCode:
					undoPressed = true;
					if(!undoHeld)
					{
						anyTapped = true;
						undoTapped = true;
						undoHeld = true;
					}
					break;
				case restartCode:
					restartPressed = true;
					if(!restartHeld)
					{
						anyTapped = true;
						restartTapped = true;
						restartHeld = true;
					}
					break;
				case escapeCode:
					escapePressed = true;
					if(!escapeHeld)
					{
						anyTapped = true;
						escapeTapped = true;
						escapeHeld = true;
					}
					break;
			}
		}
		
		private function KeyReleased(e:KeyboardEvent):void {
			anyReleased = true;
			
			// For each action, checks if the key code of this event corresponds to that key, setting released and unsetting held if it does
			switch (e.keyCode) {
				case leftCode:
					leftReleased = true;
					leftHeld = false;
					break;
				case rightCode:
					rightReleased = true;
					rightHeld = false;
					break;
				case upCode:
					upReleased = true;
					upHeld = false;
					break;
				case downCode:
					downReleased = true;
					downHeld = false;
					break;
				case undoCode:
					undoReleased = true;
					undoHeld = false;
					break;
				case restartCode:
					restartReleased = true;
					restartHeld = false;
					break;
				case escapeCode:
					escapeReleased = true;
					escapeHeld = false;
					break;
			}
		}
		
	}
	
}
