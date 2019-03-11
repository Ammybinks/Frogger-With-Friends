package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Goal extends GridObject implements IPhysicsCollidable {
		var collider:CircleCollider;
		
		private var radius:Number;
		public function get Radius():Number { return radius }
		public function set Radius(value:Number):void { radius = value }
		
		private var isTrigger:Boolean = true;
		public function get IsTrigger():Boolean { return isTrigger }
		public function set IsTrigger(value:Boolean):void { isTrigger = value }
		
		private var collisionType:String = "";
		public function get CollisionType():String { return collisionType }
		public function set CollisionType(value:String):void { collisionType = value }
		
		public function Goal(kernel:Kernel, gridPosition:Vector3D) {
			super(kernel, gridPosition);

			radius = (width / 2) * 0.1;
			
			collider = new CircleCollider(this, new <Vector3D>[new Vector3D(x - radius, y - radius, 0), new Vector3D(x + radius, y + radius, 0)]);
			
			stop();
			
			kernel.AddCollider(this, collider.CheckCollision);
			kernel.addEventListener(StateEvent.PUZZLE_SOLVED, OnSolved);
		}

		public function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void
		{
			if(collisionType == PlayerFrog.PLAYER_COLLISION)
			{
				kernel.EndGame();
			}
		}
		
		private function OnSolved(e:StateEvent)
		{
			gotoAndStop(2);

			kernel.addEventListener(UndoEvent.UNDO, OnUnsolved);
			kernel.addEventListener(UndoEvent.RESTART, OnUnsolved);
		}
		
		private function OnUnsolved(e:UndoEvent)
		{
			gotoAndStop(1);

			kernel.removeEventListener(UndoEvent.UNDO, OnUnsolved);
			kernel.removeEventListener(UndoEvent.RESTART, OnUnsolved);
		}
	}
	
}
