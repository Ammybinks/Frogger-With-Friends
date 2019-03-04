package  {
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	public class UndoEvent extends Event {
		public static const UNDO = "undo";
		public static const RESTART = "restart";
		
		public function UndoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
	
}