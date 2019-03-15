package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Goal extends GridObject implements IPhysicsCollidable {
		private var collider:CircleCollider;
		public function get Collider():ICollider { return collider };
		
		private var radius:Number;
		public function get Radius():Number { return radius }
		
		// Trigger objects will collide with others, but won't create pushback force, meaning they can be moved through freely
		private var isTrigger:Boolean = true;
		public function get IsTrigger():Boolean { return isTrigger }
		
		// A descriptor of the type of object the object is, used by other objects to determine what specific collision behaviour to enact
		private var collisionType:String = "";
		public function get CollisionType():String { return collisionType }
		
		public function Goal(kernel:Kernel, gridPosition:Vector3D) {
			super(kernel, gridPosition);

			radius = (width / 2) * 0.1;
			
			collider = new CircleCollider(this, new <Vector3D>[new Vector3D(x - radius, y - radius, 0), new Vector3D(x + radius, y + radius, 0)]);
			
			// Prevent the image from constantly animating between frames
			stop();
			
			kernel.Collidables.push(this);
			kernel.addEventListener(StateEvent.PUZZLE_SOLVED, OnSolved);
		}

		// Ends the game if the collision is a player frog
		public function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void
		{
			if(collisionType == PlayerFrog.PLAYER_COLLISION)
			{
				kernel.EndGame();
			}
		}
		
		// Switches the goal to its active state
		private function OnSolved(e:StateEvent)
		{
			gotoAndStop(2);

			kernel.addEventListener(UndoEvent.UNDO, OnUnsolved);
			kernel.addEventListener(UndoEvent.RESTART, OnUnsolved);
		}
		
		// Switches the goal to its inactive state
		private function OnUnsolved(e:UndoEvent)
		{
			gotoAndStop(1);

			kernel.removeEventListener(UndoEvent.UNDO, OnUnsolved);
			kernel.removeEventListener(UndoEvent.RESTART, OnUnsolved);
		}
	}
	
}
