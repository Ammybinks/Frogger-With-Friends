package  {
	import flash.geom.Vector3D;
	
	public class RectCollider implements IRectCollider {
		// Upper left corner of the rectangle
		private var ul:Vector3D;
		public function get UpperLeft():Vector3D { return ul; }
		
		// Lower right corner of the rectangle
		private var br:Vector3D;
		public function get BottomRight():Vector3D { return br; }
		
		public function RectCollider(ul:Vector3D, br:Vector3D) {
			this.ul = ul;
			this.br = br;
		}

		public function CheckCollision(collidables:Vector.<IPhysicsCollidable>):void {
			
		}
	}
	
}
