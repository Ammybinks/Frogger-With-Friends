package  {
	import flash.events.Event;
	
	public class CollisionEvent extends Event {
		public static const CHECK_COLLISION = "checkCollision";

		public var collidables:Vector.<IPhysicsCollidable>;
		
		public function CollisionEvent(type:String, collidables:Vector.<IPhysicsCollidable>, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.collidables = collidables;
		}
		
	}
	
}
