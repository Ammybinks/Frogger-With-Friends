package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	// PlayerFrog is the unique class used by the primary player token, containing behaviour to move the frog according to input, rather than any other entities or paths
	public class PlayerFrog extends Frog implements IPhysicsCollidable, IEventListener {
		public static var PLAYER_COLLISION:String = "player";
		
		var input:InputManager;
		
		var facing:Vector3D = new Vector3D();
		
		var turnSpeed:Number = 15;
		
		var active:Boolean = true;
		
		public function PlayerFrog(kernel:Kernel, gridPosition:Vector3D, colour:String):void {
			super(kernel, gridPosition, colour);
			
			input = kernel.input;
			
			collisionType = PLAYER_COLLISION;

			kernel.addEventListener(UpdateEvent.UPDATE, Update);
			
			kernel.addEventListener(UpdateEvent.BEGIN_TURN, Activate);
		}

		private function Activate(e:UpdateEvent):void
		{
			active = true;
		}
		
		public override function Update():void {
			if(firstUpdate)
			{
				TakeTurn(null);
				
				firstUpdate = false;
			}
			
			if(distanceToMove != null)
			{
				Move();
			}
			else if(moving && !fighting)
			{
				moving = false;
				kernel.movingCount--;
			}
			
			if(!kernel.gameComplete && !kernel.gameOver)
			{
				if(kernel.solved)
				{
					PhysicsMove();
				}
				else
				{
					GridMove();
				}
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
			else if((input.leftHeld || input.rightHeld || input.upHeld || input.downHeld) && active)
			{
				var destination:Vector3D;
		
				pastRotations.push(rotation);
				pastPositions.push(gridPosition.clone());
				pastLife.push(visible);
				
				// Moves the frog along the grid
				if(input.leftHeld)
				{
					if(gridPosition.x - 1 >= 0)
					{
						destination = new Vector3D(gridPosition.x - 1, gridPosition.y, 0);
					}
					
					rotation = 90;
				}
				else if(input.rightHeld)
				{
					if(gridPosition.x + 1 < kernel.stageSize)
					{
						destination = new Vector3D(gridPosition.x + 1, gridPosition.y, 0);
					}
					
					rotation = 270;
				}
				else if(input.upHeld)
				{
					if(gridPosition.y - 1 >= 0)
					{
						destination = new Vector3D(gridPosition.x, gridPosition.y - 1, 0);
					}
					
					rotation = 180;
				}
				else if(input.downHeld)
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
						var fight:Fight = new Fight(this as IFighter, collision as IFighter, new Vector3D(collision.x, collision.y, 0), new Vector3D(width, height, 0));

						stage.addChild(fight);
						
						gridPosition = destination;
					
						StartMove();

						turnTimer.start();
					}
					else
					{
						TakeTurn(null);
					}
				}
				else
				{
					kernel.MoveActor(gridPosition, destination);
					
					gridPosition = destination;
					
					StartMove();

					turnTimer.start();
				}

				active = false;
				
				moving = true;
				kernel.movingCount++;
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
				A.x -= physicsSpeed;
				
				facing.x -= physicsSpeed;
			}
			if(kernel.input.rightHeld)
			{
				A.x += physicsSpeed;
				facing.x += physicsSpeed;
			}
			if(kernel.input.upHeld)
			{
				A.y -= physicsSpeed;
				facing.y -= physicsSpeed;
			}
			if(kernel.input.downHeld)
			{
				A.y += physicsSpeed;
				facing.y += physicsSpeed;
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
			
			V = new Vector3D(0, 0, 0);
			A = new Vector3D(0, 0, 0);
			
			UpdatePosition();
		}
	}
	
}
