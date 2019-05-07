package  {
	import flash.geom.Vector3D;
	
	public class CircleCollider implements ICircleCollider {
		// The body this is attached to, will check collisions for and will return collision data to
		private var b:IPhysicsCollidable;
		
		// The outer bounds of the area to keep the body inside of
		private var bounds:Vector.<Vector3D>;
		
		internal var radius:Number;
		public function get Radius():Number { return radius }
		
		public function CircleCollider(b:IPhysicsCollidable, radius:Number, bounds:Vector.<Vector3D>) {
			this.b = b;
			this.radius = radius;
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
					if (collidables[i].Collider is ICircleCollider)
					{
						var collider:ICircleCollider = (collidables[i].Collider as ICircleCollider)
						
						// Store the current position of the collision's collider's body
						cPosition = new Vector3D(collidables[i].x, collidables[i].y, 0);
						
						// Calculate and store the vector from bPosition -> cPosition
						bC = new Vector3D(cPosition.x - bPosition.x, cPosition.y - bPosition.y, 0);
						
						// If the collider is overlapping with the collision's collider
						if(bC.clone().normalize() - radius <= collider.Radius)
						{
							// Calculate the depth of the collision
							depth = collider.Radius - bC.clone().normalize() + radius;

							bC.normalize();
							
							// Return all necessary details of the collision to b
							b.OnPhysicsCollide(bC, depth, collidables[i].IsTrigger, collidables[i].CollisionType);
						}
					}
					else if (collidables[i].Collider is IRectCollider)
					{
						var ul:Vector3D = (collidables[i].Collider as IRectCollider).UpperLeft;
						var br:Vector3D = (collidables[i].Collider as IRectCollider).BottomRight;
						
						if(b.x + radius > ul.x && b.x - radius < br.x && b.y + radius > ul.y && b.y - radius < br.y)
						{
							// Store the current position of the collision's collider's body
							cPosition = new Vector3D(collidables[i].x, collidables[i].y, 0);
							
							// Calculate and store the vector from bPosition -> cPosition
							bC = new Vector3D(cPosition.x - bPosition.x, cPosition.y - bPosition.y, 0);

							var temp:Number = bC.clone().normalize();

							if(Math.abs(bC.x) > Math.abs(bC.y))
							{
								bC.y = 0;
								// Calculate the depth of the collision
								depth = ((br.x - ul.x) / 2) - bC.clone().normalize() + radius;
								bC.normalize();
								bC.x = temp * bC.x;
							}
							else
							{
								bC.x = 0;
								// Calculate the depth of the collision
								depth = ((br.y - ul.y) / 2) - bC.clone().normalize() + radius;
								bC.normalize();
								bC.y = temp * bC.y;
							}
							
							
							bC.normalize();
							
							b.OnPhysicsCollide(bC, depth, collidables[i].IsTrigger, collidables[i].CollisionType);
						}
					}
				}
			}	
				
			// Keep the body within the bounds of the stage
			if(b.x < bounds[0].x + radius)
			{
				b.x = bounds[0].x + radius;
			}
			else if(b.x > bounds[1].x - radius)
			{
				b.x = bounds[1].x - radius;
			}
			
			if(b.y < bounds[0].y + radius)
			{
				b.y = bounds[0].y + radius;
			}
			else if(b.y > bounds[1].y - radius)
			{
				b.y = bounds[1].y - radius;
			}
		}
	}
	
}
