package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	// Contains all variables and calculations to determine how an object should respond under various forces, before reflecting those changes onto its attatched b
	public class PhysicsManager {
		var b:IPhysicsBody;
		
		var timer:int;
		
		public function PhysicsManager(b:IPhysicsBody):void {
			// Store a reference to the game object that should be moved
			this.b = b;
			
			timer = getTimer();
		}

		public function Update():void
		{
			var newTimer:int = getTimer();
			var deltaTime:Number = (newTimer - timer) * (0.001 * 60);
			timer = newTimer;
			
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

			trace(deltaTime);
			
			// Reflect changes on main b
			b.x += (b.V.x * deltaTime);
			b.y += (b.V.y * deltaTime);
			
			b.A = new Vector3D();
		}
		
		// Called externally to change the velocity of the object
		public function Accelerate(pX:Number, pY:Number):void {
			b.A.x += pX;
			b.A.y += pY;
		}
	}
	
}
