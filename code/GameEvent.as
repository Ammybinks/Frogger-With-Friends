package  {
	import flash.events.Event;
	
	public class GameEvent extends Event {
		public static const START_GAME = "startGame";
		public static const END_GAME = "endGame";

		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
	
}
