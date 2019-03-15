package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	public class PhysicsManager {
		// The body this is attached to, and will reflect changes onto
		private var b:IPhysicsBody;
		
		// Stores the time at each update
		private var timer:int;
		
		public function PhysicsManager(b:IPhysicsBody):void {
			this.b = b;
			
			timer = getTimer();
		}

		public function Update():void
		{
			// Compare current time to the time of last update, converting the difference into deltaTime and calculating how much more or less that time is than the regular update interval 
			var newTimer:int = getTimer();
			var deltaTime:Number = newTimer - timer;
			var frameLength:Number = deltaTime * (0.001 * 60);
			
			timer = newTimer;
			
			// Add b's total acceleration to its velocity
			b.V.x += b.A.x;
			b.V.y += b.A.y;
			
			// Reduce b's velocity by its friction
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
			// Stop the object if its speed is below MinSpeed
			else if (mag < b.MinSpeed)
			{
				b.V.x = 0;
				b.V.y = 0;
			}

			// Reflect changes on main b
			b.x += (b.V.x * frameLength);
			b.y += (b.V.y * frameLength);
			
			// Reset A to 0
			b.A = new Vector3D();
		}
	}
	
}
