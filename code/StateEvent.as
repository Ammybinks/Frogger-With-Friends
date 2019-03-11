package  {
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	public class StateEvent extends Event {
		public static const PUZZLE_SOLVED = "puzzleSolved";
		public static const ACTOR_DIED = "actorDied";
		
		public function StateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
	
}
