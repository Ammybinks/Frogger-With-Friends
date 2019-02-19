package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	// Contains all variables and calculations to determine how an object should respond under various forces, before reflecting those changes onto its attatched body
	public class PhysicsManager {
		var body:MovieClip;
		
		var mass:Number = 1;
		
		// Current velocity
		var v:Vector3D = new Vector3D(0, 0, 0);
		// Object mass
		var m:Vector3D = new Vector3D(0, 0, 0);
		
		var elasticity:Number = 0.85;
		var gravity:Number = 1;
		var friction:Number = 0.99;
		
		// Maximum speed the object can move
		var cap:Number = 25;
		
		public function PhysicsManager(pBody:MovieClip) {
			// Store a reference to the game object that should be moved
			body = pBody;
		}

		public function Update()
		{
			// Reduce object speed with current friction value
			v.x *= friction;
			v.y *= friction;
			
			// Get current speed the object is moving at
			var mag:Number = GetMagnitude(v);
			
			// Limit speed by reducing the magnitude of v
			if(mag > cap)
			{
				v.x = v.x * cap / mag;
				v.y = v.y * cap / mag;
			}
			
			// Reflect changes on main body
			body.x += v.x;
			body.y += v.y;
				
			CheckPosition();
		}
		
		// Checks if the object has reached the edge of the screen, keeping it within screen bounds at all times
		private function CheckPosition()
		{
			if(body.x > body.stage.stageWidth)
			{
				body.x = body.stage.stageWidth;
				
				v.x = HitEdge(v.x);
			}
			if(body.x < 0)
			{
				body.x = 0;

				v.x = HitEdge(v.x);
			}
			
			if(body.y > body.stage.stageHeight)
			{
				body.y = body.stage.stageHeight;
				
				v.y = HitEdge(v.y);
			}
			if(body.y < 0)
			{
				body.y = 0;
				
				v.y = HitEdge(v.y);
			}
		}

		// Returns the magnitude of the given vector
		private function GetMagnitude(pV:Vector3D):Number
		{
			return Math.sqrt(v.x * v.x + v.y * v.y);
		}
		
		private function HitEdge(pV:Number):Number
		{
			pV *= elasticity;
			pV *= -1;
			
			return pV;
		}
		
		// Called externally to change the velocity of the object
		public function AddSpeed(pX:Number, pY:Number) {
			var p:Vector3D = new Vector3D(pX, pY, 0);
			
			v.x += p.x;
			v.y += p.y;
			v.z += p.z;
		}
	}
	
}
