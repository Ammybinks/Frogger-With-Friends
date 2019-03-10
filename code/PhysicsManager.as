package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	// Contains all variables and calculations to determine how an object should respond under various forces, before reflecting those changes onto its attatched b
	public class PhysicsManager {
		var b:IPhysicsBody;
		
		public function PhysicsManager(b:IPhysicsBody):void {
			// Store a reference to the game object that should be moved
			this.b = b;
		}

		public function Update():void
		{
			b.V.x += b.A.x;
			b.V.y += b.A.y;
			
			b.V.x *= b.Friction;
			b.V.y *= b.Friction;
			
			// Get current speed the object is moving at
			var mag:Number = b.V.clone().normalize();
			
			// Limit speed by reducing the magnitude of V
			if(mag > b.MaxSpeed)
			{
				b.V.x = b.V.x * b.MaxSpeed / mag;
				b.V.y = b.V.y * b.MaxSpeed / mag;
			}
			else if (mag < b.MinSpeed)
			{
				b.V.x = 0;
				b.V.y = 0;
			}
			
			// Reflect changes on main b
			b.x += b.V.x;
			b.y += b.V.y;
			
			b.A = new Vector3D();
		}
		
		// Called externally to change the velocity of the object
		public function Accelerate(pX:Number, pY:Number):void {
			b.A.x += pX;
			b.A.y += pY;
		}
	}
	
}
