package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	
	// PlayerFrog is the unique class used by the primary player token, containing behaviour to move the frog according to input, rather than any other entities or paths
	public class PlayerFrog extends Actor implements IPhysicsCollidable, IPhysicsBody, INext, IEventListener {
		public static var PLAYER_COLLISION:String = "player";
		
		var physicsBody:PhysicsManager;
		var collider:CircleCollider;
		var input:InputManager;
		
		var facing:Vector3D = new Vector3D();
		
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
		
		private var friction:Number = 0.8;
		public function get Friction():Number { return friction }
		public function set Friction(value:Number):void { friction = value }
		
		private var radius:Number;
		public function get Radius():Number { return radius }
		public function set Radius(value:Number):void { radius = value }
		
		private var isTrigger:Boolean = false;
		public function get IsTrigger():Boolean { return isTrigger }
		public function set IsTrigger(value:Boolean):void { isTrigger = value }
		
		private var collisionType:String = "";
		public function get CollisionType():String { return collisionType }
		public function set CollisionType(value:String):void { collisionType = value }
		
		private var maxSpeed:Number = 100;
		public function get MaxSpeed():Number { return maxSpeed }
		public function set MaxSpeed(value:Number):void { maxSpeed = value }
		
		private var minSpeed:Number = 0.1;
		public function get MinSpeed():Number { return minSpeed }
		public function set MinSpeed(value:Number):void { minSpeed = value }
		
		var speed:Number = 2;
		
		var turnSpeed:Number = 15;
		
		var pastRotations:Vector.<int> = new Vector.<int>();
		
		var active:Boolean = true;
		
		public function PlayerFrog(kernel:Kernel, gridPosition:Vector3D, colour:String):void {
			super(kernel, gridPosition, colour);
			
			input = kernel.input;
			
			actorType = FROG_TYPE;
			collisionType = PLAYER_COLLISION;

			radius = (width / 2) * 0.75;
			
			kernel.addEventListener(UpdateEvent.UPDATE, Update);
			// Create new manager for physics interactions
			physicsBody = new PhysicsManager(this);
			collider = new CircleCollider(this, kernel.stageBounds);
			
			kernel.AddCollider(this, collider.CheckCollision);
			kernel.addEventListener(CollisionEvent.CHECK_COLLISION, collider.CheckCollision);
			kernel.addEventListener(UpdateEvent.BEGIN_TURN, Activate);
		}

		public function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void
		{
				trace("Player Collide");
				
				A.x -= direction.x * depth * Elasticity;
				A.y -= direction.y * depth * Elasticity;
		}

		private function Activate(e:UpdateEvent):void
		{
			active = true;
		}
		
		internal override function Update(e:UpdateEvent):void {
			if(firstUpdate)
			{
				TakeTurn();
				
				firstUpdate = false;
			}
			
			if(moving && !fighting)
			{
				moving = false;
				kernel.movingCount--;
			}
			
			if(kernel.solved)
			{
				PhysicsMove();
			}
			else
			{
				GridMove();
			}
		}

		private function TakeTurn()
		{
			if(hasEventListener(UpdateEvent.PLAYER_TURN))
			{
				dispatchEvent(new UpdateEvent(UpdateEvent.PLAYER_TURN));
			}
		}
		
		private function GridMove()
		{
			if(!visible)
			{
				pastRotations.push(rotation);
				pastPositions.push(gridPosition.clone());
				pastLife.push(visible);
			}
			else if((input.leftTapped || input.rightTapped || input.upTapped || input.downTapped) && active)
			{
				var destination:Vector3D;
		
				pastRotations.push(rotation);
				pastPositions.push(gridPosition.clone());
				pastLife.push(visible);
				
				// Moves the frog along the grid
				if(input.leftTapped)
				{
					if(gridPosition.x - 1 >= 0)
					{
						destination = new Vector3D(gridPosition.x - 1, gridPosition.y, 0);
					}
					
					rotation = 90;
				}
				else if(input.rightTapped)
				{
					if(gridPosition.x + 1 < kernel.stageSize)
					{
						destination = new Vector3D(gridPosition.x + 1, gridPosition.y, 0);
					}
					
					rotation = 270;
				}
				else if(input.upTapped)
				{
					if(gridPosition.y - 1 >= 0)
					{
						destination = new Vector3D(gridPosition.x, gridPosition.y - 1, 0);
					}
					
					rotation = 180;
				}
				else if(input.downTapped)
				{
					if(gridPosition.y + 1 < kernel.stageSize)
					{
						destination = new Vector3D(gridPosition.x, gridPosition.y + 1, 0);
					}
					
					rotation = 0;
				}
			}
			
			if(destination != null)
			{
				var collision:IGridCollidable = kernel.actors[destination.x][destination.y];
				
				if(collision != null)
				{
					if(collision.ActorType == Actor.SNAKE_TYPE)
					{
						var fight:Fight = new Fight(this as IFighter, collision as IFighter);
					}
				}
				else
				{
					kernel.MoveActor(gridPosition, destination);
					
					gridPosition = destination;
				}

				active = false;
				
				moving = true;
				kernel.movingCount++;

				TakeTurn();
			}
		}
		
		private function PhysicsMove()
		{
			physicsBody.Update();
			
			// Limits how fast the frog turns by only reducing the relative weighting of each rotation to a certain amount
			if(Math.abs(facing.x) > 15 || Math.abs(facing.y) > 15)
			{
				facing.x *= Friction;
				facing.y *= Friction;
			}			
			
			// Accelerate the frog in the direction of the key held, adding weight to facing to turn the frog in that direction
			if(kernel.input.leftHeld)
			{
				physicsBody.Accelerate(-speed, 0);
				facing.x -= speed;
			}
			if(kernel.input.rightHeld)
			{
				physicsBody.Accelerate(speed, 0);
				facing.x += speed;
			}
			if(kernel.input.upHeld)
			{
				physicsBody.Accelerate(0, -speed);
				facing.y -= speed;
			}
			if(kernel.input.downHeld)
			{
				physicsBody.Accelerate(0, speed);
				facing.y += speed;
			}
			
			rotation = Math.atan2(facing.y, facing.x) * (180 / Math.PI) - 90;
		}
		
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastRotations = new <int>[pastRotations[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
		
		internal override function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			rotation = pastRotations.pop();
			visible = pastLife.pop();
			
			if(visible)
			{
				kernel.actors[gridPosition.x][gridPosition.y] = this;
			}
		}
	}
	
}
