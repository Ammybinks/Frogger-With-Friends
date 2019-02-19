package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class PhysicsManager {
		var body:MovieClip;
		
		var mass:Number = 1;
		
		var v:Vector3D = new Vector3D(5, 0, 0);
		var s:Vector3D = new Vector3D(0.3, 1.8, 0);
		var m:Vector3D = new Vector3D(0, 0, 0);
		
		var elasticity:Number = 0.85;
		var gravity:Number = 1;
		var friction:Number = 0.99;
		var cap:Number = 5;
		
		public function PhysicsManager(pBody:MovieClip) {
			body = pBody;
		}

		public function Update()
		{
			v.x *= friction;
			v.y *= friction;
			
			if(Math.Normalise(v.x) >= cap)
			{
				v.x = cap;
			}
			if(Math.normalise(v.y) >= cap)
			{
				v.y = cap;
			}
			
			body.x += v.x;
			
			body.y += v.y;
				
			CheckPosition();
		}
		
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
		
		private function HitEdge(v:Number)
		{
			v *= elasticity;
			v *= -1;
			
			return v;
		}
		
		public function AddSpeed(pX:Number, pY:Number) {
			var p:Vector3D = new Vector3D(pX, pY, 0);
			
			v.x += p.x;
			v.y += p.y;
			v.z += p.z;
		}
	}
	
}
