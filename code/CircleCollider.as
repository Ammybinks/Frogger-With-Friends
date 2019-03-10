package  {
	import flash.geom.Vector3D;
	
	public class CircleCollider {
		var b:ICollidable;
		var bounds:Vector.<Vector3D>;
		
		public function CircleCollider(b:ICollidable, bounds:Vector.<Vector3D>) {
			this.b = b;
			this.bounds = bounds;
		}

		public function CheckCollision(e:CollisionEvent)
		{
			// Store the current position of the collider's body
			var bPosition:Vector3D = new Vector3D(b.x, b.y, 0);
			var bSupport:Vector3D;
			var cPosition:Vector3D;
			var bC:Vector3D;
			var depth:Number;
			
			for(var i:int = 0; i < e.collidables.length; i++)
			{
				if(e.collidables[i] != b)
				{
					// Store the current position of the collision's collider's body
					cPosition = new Vector3D(e.collidables[i].x, e.collidables[i].y, 0);
					
					// Calculate and store the vector from B -> C
					bC = new Vector3D(cPosition.x - bPosition.x, cPosition.y - bPosition.y, 0);
					
					// If the collider's support point is inside of the collision's radius
					if(bC.clone().normalize() - b.Radius <= e.collidables[i].Radius)
					{
						// Trigger collision
						trace("Collision!");
						
						// Calculate the distance needed to move to be outside of a collision
						depth = e.collidables[i].Radius - bC.clone().normalize() + b.Radius;

						bC.normalize();
						
						// Add force pushing away from the collision at a speed according to how much the two bodies were colliding and the current bodies' elasticity
						b.A.x -= bC.x * depth * b.Elasticity;
						b.A.y -= bC.y * depth * b.Elasticity;
					}
				}
			}
				
				
			// Keep the collider within the bounds of the stage
			if(b.x < bounds[0].x + b.Radius)
			{
				b.x = bounds[0].x + b.Radius;
			}
			else if(b.x > bounds[1].x - b.Radius)
			{
				b.x = bounds[1].x - b.Radius;
			}
			
			if(b.y < bounds[0].y + b.Radius)
			{
				b.y = bounds[0].y + b.Radius;
			}
			else if(b.y > bounds[1].y - b.Radius)
			{
				b.y = bounds[1].y - b.Radius;
			}
		}
	}
	
}
