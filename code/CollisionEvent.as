package  {
	import flash.events.Event;
	
	public class CollisionEvent extends Event {
		public static const CHECK_COLLISION = "checkCollision";

		public var collidables:Vector.<ICollidable>;
		
		public function CollisionEvent(type:String, collidables:Vector.<ICollidable>, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.collidables = collidables;
		}
		
	}
	
}
