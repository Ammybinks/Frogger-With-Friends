﻿package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	
	public class InputManager {
		var body:MovieClip;
		
		var leftHeld:Boolean = false;
		var rightHeld:Boolean = false;
		var upHeld:Boolean = false;
		var downHeld:Boolean = false;
		
		// Boolean values that store the current state of each key
		var leftTapped:Boolean = false;
		var rightTapped:Boolean = false;
		var upTapped:Boolean = false;
		var downTapped:Boolean = false;
		var undoTapped:Boolean = false;
		var restartTapped:Boolean = false;
		
		var currentKey:int = 0;
		
		public function InputManager(kernel:MovieClip):void {
			kernel.stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed);
			kernel.stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleased);
		}

		public function Update():void {
			// Traces the keyCode of the most recently held key, for debugging purposes
			/*			
			if(currentKey != 0)
			{
				trace(currentKey);
			}
			*/
			
			leftTapped = false;
			rightTapped = false;
			upTapped = false;
			downTapped = false;
			undoTapped = false;
			restartTapped = false;
		}
		
		// Store the state of any key that's pressed
		private function KeyPressed(e:KeyboardEvent):void {
			currentKey = e.keyCode;
			
			trace(currentKey);
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
					break;
				case 82:
					restartTapped = true;
					break;
			}
		}
		
		// upTappeddate the state of any key that's no longer being pressed
		private function KeyReleased(e:KeyboardEvent):void {
			currentKey = 0;
			
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
			}
		}
		
	}
	
}