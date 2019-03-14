package  {
	import flash.geom.Vector3D;
	
	public class CircleCollider implements ICollider {
		var b:IPhysicsCollidable;
		var bounds:Vector.<Vector3D>;
		
		public function CircleCollider(b:IPhysicsCollidable, bounds:Vector.<Vector3D>) {
			this.b = b;
			this.bounds = bounds;
		}

		public function CheckCollision(collidables:Vector.<IPhysicsCollidable>):void
		{
			// Store the current position of the collider's body
			var bPosition:Vector3D = new Vector3D(b.x, b.y, 0);
			var bSupport:Vector3D;
			var cPosition:Vector3D;
			var bC:Vector3D;
			var depth:Number;
			
			for(var i:int = 0; i < collidables.length; i++)
			{
				if(collidables[i] != b)
				{
					// Store the current position of the collision's collider's body
					cPosition = new Vector3D(collidables[i].x, collidables[i].y, 0);
					
					// Calculate and store the vector from B -> C
					bC = new Vector3D(cPosition.x - bPosition.x, cPosition.y - bPosition.y, 0);
					
					// If the collider's support point is inside of the collision's radius
					if(bC.clone().normalize() - b.Radius <= collidables[i].Radius)
					{
						// Calculate the depth of the collision
						depth = collidables[i].Radius - bC.clone().normalize() + b.Radius;

						bC.normalize();
						
						// Add force pushing away from the collision at a speed according to how much the two bodies were colliding and the current bodies' elasticity
						b.OnPhysicsCollide(bC, depth, collidables[i].IsTrigger, collidables[i].CollisionType);
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
