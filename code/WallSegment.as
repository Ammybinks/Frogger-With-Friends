package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class WallSegment extends MovieClip implements IPhysicsCollidable {
		static var WALL_SEGMENT_TYPE:String = "wallSegmentType";
		
		// The type of the actor, used to determine actions on collisions with other actors
		internal var collisionType:String = WALL_SEGMENT_TYPE;
		public function get CollisionType():String { return collisionType };
		
		internal var collider:RectCollider;
		public function get Collider():ICollider { return collider };

		// Trigger objects will collide with others, but won't create pushback force, meaning they can be moved through freely
		internal var isTrigger:Boolean = false;
		public function get IsTrigger():Boolean { return isTrigger }
		

		public function WallSegment(rectUL:Vector3D, rectBR:Vector3D) {
			x = rectUL.x + ((rectBR.x - rectUL.x) / 2);
			y = rectUL.y + ((rectBR.y - rectUL.y) / 2);
			
			collider = new RectCollider(rectUL, rectBR); 
		}
		
		public function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void
		{
		}
		
	}
	
}
