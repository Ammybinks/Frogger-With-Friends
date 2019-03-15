package  {
	import flash.geom.Vector3D;
	
	public class CircleCollider implements ICollider {
		// The body this is attached to, will check collisions for and will return collision data to
		var b:IPhysicsCollidable;
		
		// The outer bounds of the area to keep the body inside of
		var bounds:Vector.<Vector3D>;
		
		public function CircleCollider(b:IPhysicsCollidable, bounds:Vector.<Vector3D>) {
			this.b = b;
			this.bounds = bounds;
		}

		public function CheckCollision(collidables:Vector.<IPhysicsCollidable>):void
		{
			// Initialise each variable for use in the primary loop
			// Store the current position of the collider's body
			var bPosition:Vector3D = new Vector3D(b.x, b.y, 0);
			var cPosition:Vector3D;
			var bC:Vector3D;
			var depth:Number;
			
			// For every other collidable object
			for(var i:int = 0; i < collidables.length; i++)
			{
				// Check collision against the object unless it's the same as this collider's body
				if(collidables[i] != b)
				{
					// Store the current position of the collision's collider's body
					cPosition = new Vector3D(collidables[i].x, collidables[i].y, 0);
					
					// Calculate and store the vector from bPosition -> cPosition
					bC = new Vector3D(cPosition.x - bPosition.x, cPosition.y - bPosition.y, 0);
					
					// If the collider is overlapping with the collision's collider
					if(bC.clone().normalize() - b.Radius <= collidables[i].Radius)
					{
						// Calculate the depth of the collision
						depth = collidables[i].Radius - bC.clone().normalize() + b.Radius;

						bC.normalize();
						
						// Return all necessary details of the collision to b
						b.OnPhysicsCollide(bC, depth, collidables[i].IsTrigger, collidables[i].CollisionType);
					}
				}
			}	
				
			// Keep the body within the bounds of the stage
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
