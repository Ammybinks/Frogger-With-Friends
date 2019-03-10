package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Frog extends Actor implements IPhysicsBody, INext {
		var physicsBody:PhysicsManager;
		var collider:CircleCollider;
		var next:INext;
		var oldNextPosition:Vector3D = new Vector3D(0, 0, 0);
		var pastNextPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		var pastRotations:Vector.<int> = new Vector.<int>();
		
		// Current velocity
		private var v:Vector3D = new Vector3D(0, 0, 0);
		public function get V():Vector3D { return v }
		public function set V(value:Vector3D):void { v = value }
		// Object mass
		private var m:Vector3D = new Vector3D(0, 0, 0);
		public function get M():Vector3D { return m }
		public function set M(value:Vector3D):void { m = value }
		// Acceleration
		private var a:Vector3D = new Vector3D(0, 0, 0);
		public function get A():Vector3D { return a }
		public function set A(value:Vector3D):void { a = value }
		
		private var elasticity:Number = 0.85;
		public function get Elasticity():Number { return elasticity }
		public function set Elasticity(value:Number):void { elasticity = value }
		
		private var friction:Number = 0.7;
		public function get Friction():Number { return friction }
		public function set Friction(value:Number):void { friction = value }
		
		private var radius:Number;
		public function get Radius():Number { return radius }
		public function set Radius(value:Number):void { radius = value }
		
		private var maxSpeed:Number = 100;
		public function get MaxSpeed():Number { return maxSpeed }
		public function set MaxSpeed(value:Number):void { maxSpeed = value }

		private var minSpeed:Number = 0.1;
		public function get MinSpeed():Number { return minSpeed }
		public function set MinSpeed(value:Number):void { minSpeed = value }
		
		var speed:Number = 4;
		
		// How far away the lead can be before the frog starts moving towards it
		private var leashRadius = 120;
		
		public function Frog(kernel:Kernel, gridPosition:Vector3D, next:INext, lead:Actor):void {
			super(kernel, gridPosition);
			
			this.next = next;
			oldNextPosition.x = next.GridPosition.x;
			oldNextPosition.y = next.GridPosition.y;
			
			UpdateRotation();
			
			actorType = FROG_TYPE;

			radius = width / 2;
			
			physicsBody = new PhysicsManager(this);
			collider = new CircleCollider(this, kernel.stageBounds);
			kernel.addEventListener(CollisionEvent.CHECK_COLLISION, collider.CheckCollision);
			kernel.addEventListener(UpdateEvent.PUZZLE_SOLVED, OnSolved);
			lead.addEventListener(UpdateEvent.PLAYER_TURN, Update);
		}
		

		internal override function Update(e:UpdateEvent):void {
			if(kernel.solved)
			{
				physicsBody.Update();

				var direction:Vector3D = new Vector3D(next.x - x, next.y - y);
				
				// If the collider's support point is inside of the collision's radius
				if(direction.clone().normalize() >= leashRadius)
				{	
					// Calculate the distance needed to move to be outside of a collision
					var distance:Number = next.Radius - direction.clone().normalize() + radius;

					direction.normalize();
					
					// Add force pushing away from the collision at a speed according to how much the two bodies were colliding and the current bodies' elasticity
					physicsBody.Accelerate(direction.x * speed, direction.y * speed);
				}
				
				
				// Reflect changes on main b
				rotation = Math.atan2(direction.y, direction.x) * (180 / Math.PI) - 90;
				
			}
			else
			{
				pastPositions.push(gridPosition.clone());
				pastNextPositions.push(oldNextPosition.clone());
				pastRotations.push(rotation);
				pastLife.push(visible);
					
				if(oldNextPosition.x != next.GridPosition.x || oldNextPosition.y != next.GridPosition.y)
				{
					kernel.MoveActor(gridPosition, oldNextPosition);
					
					gridPosition.x = oldNextPosition.x;
					gridPosition.y = oldNextPosition.y;
					
					oldNextPosition.x = next.GridPosition.x;
					oldNextPosition.y = next.GridPosition.y;
					
					UpdateRotation();
				}
			}
		}

		private function OnSolved(e:UpdateEvent):void
		{
			kernel.addEventListener(UpdateEvent.UPDATE, Update);
		}
		
		private function UpdateRotation():void
		{
			if(oldNextPosition.x < gridPosition.x)
			{
				rotation = 90;
			}
			if(oldNextPosition.x > gridPosition.x)
			{
				rotation = 270;
			}
			if(oldNextPosition.y < gridPosition.y)
			{
				rotation = 180;
			}
			if(oldNextPosition.y > gridPosition.y)
			{
				rotation = 0;
			}
		}
		
		internal override function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			oldNextPosition = pastNextPositions.pop();
			rotation = pastRotations.pop();
			
			if(!kernel.solved)
			{
				kernel.removeEventListener(UpdateEvent.UPDATE, Update);
			}

			visible = pastLife.pop();
			
			if(visible)
			{
				kernel.AddActor(this);
			}
		}
		
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastNextPositions = new <Vector3D>[pastNextPositions[0]];
			pastRotations = new <int>[pastRotations[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
	}
	
}
