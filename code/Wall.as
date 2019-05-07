package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Wall extends GridObject implements IGridCollidable {
		static var WALL_TYPE:String = "wallType";
		
		// The type of the actor, used to determine actions on collisions with other actors
		internal var collisionType:String = WALL_TYPE;
		public function get CollisionType():String { return collisionType };
		
		public function Wall(scene:IGameScene, gridPosition:Vector3D) {
			super(scene, gridPosition);
			
			scene.Actors[gridPosition.x][gridPosition.y] = this;
		}
	}
	
}
