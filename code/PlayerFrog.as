package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PlayerFrog extends Frog implements IPhysicsCollidable {
		public static var PLAYER_COLLISION:String = "player";
		
		private var input:InputManager;
		
		// Stores information to allow the frog to turn smoothly during the physics based section
		private var facing:Vector3D = new Vector3D();
		
		// Minimum magnitude of the facing vector, or how much force is required to turn the frog from a standing position
		private var turnSpeed:Number = 15;
		
		// If the frog is currently taking inputs from the player
		private var active:Boolean = true;
		
		public function PlayerFrog(scene:IGameScene, gridPosition:Vector3D, colour:String):void {
			super(scene, gridPosition, colour);
			
			input = scene.Input;
			
			collisionType = PLAYER_COLLISION;

			// Event listener that reactivates the frog when the turn has ended
			scene.addEventListener(TurnEvent.BEGIN_TURN, Activate);
		}

		// Returns the frog to an active state
		private function Activate(e:TurnEvent):void
		{
			active = true;
		}
		
		public override function Update():void {
			if(firstUpdate)
			{
				// Begin a single turn to allow all actors to initialise correctly
				TakeTurn(null);
				
				firstUpdate = false;
			}
			
			if(distanceToMove != null)
			{
				Move();
			}
			// If there is no distance to move and the frog was moving and is not fighting
			else if(moving && !fighting)
			{
				moving = false;
				scene.MovingCount--;
			}
			
			if(!scene.GameComplete && !scene.GameOver)
			{
				if(scene.Solved)
				{
					PhysicsMove();
				}
				else
				{
					GridMove();
				}
			}
		}

		// Moves the frog along the grid, beginning a turn each time it moves
		private function GridMove()
		{
			// If any key is pressed and the frog is listening for inputs
			if((input.leftHeld || input.rightHeld || input.upHeld || input.downHeld) && active)
			{
				var destination:Vector3D;

				AddPast();
				
				// Moves the frog along the grid
				if(input.leftHeld)
				{
					// If new position is inside the stage bounds
					if(gridPosition.x - 1 >= 0)
					{
						destination = new Vector3D(gridPosition.x - 1, gridPosition.y, 0);
					}
					else
					{
						destination = gridPosition;
					}
					
					rotation = 90;
				}
				else if(input.rightHeld)
				{
					// If new position is inside the stage bounds
					if(gridPosition.x + 1 < scene.StageSize)
					{
						destination = new Vector3D(gridPosition.x + 1, gridPosition.y, 0);
					}
					else
					{
						destination = gridPosition;
					}
					
					rotation = 270;
				}
				else if(input.upHeld)
				{
					// If new position is inside the stage bounds
					if(gridPosition.y - 1 >= 0)
					{
						destination = new Vector3D(gridPosition.x, gridPosition.y - 1, 0);
					}
					else
					{
						destination = gridPosition;
					}
					
					rotation = 180;
				}
				else if(input.downHeld)
				{
					// If new position is inside the stage bounds
					if(gridPosition.y + 1 < scene.StageSize)
					{
						destination = new Vector3D(gridPosition.x, gridPosition.y + 1, 0);
					}
					else
					{
						destination = gridPosition;
					}
					
					rotation = 0;
				}
				
				// Find any object at the projected position
				var collision:IGridCollidable = scene.Actors[destination.x][destination.y];
				
				// If there is no object in the space, move the frog like normal
				if(collision == null)
				{
					scene.AbsoluteMoveActor(this, destination);
					
					gridPosition = destination;
					
					StartMove();

					turnTimer.start();
				}
				else
				{
					// If the frog has collided with a snake
					if(collision.ActorType == Actor.SNAKE_TYPE)
					{
						// Begin a fight between the frog and the snake
						var fight:Fight = new Fight(this as IFighter, collision as IFighter, new Vector3D(collision.x, collision.y, 0), new Vector3D(width, height, 0));

						stage.addChild(fight);
						
						// Move the frog into the fight
						gridPosition = destination;
					
						StartMove();

						turnTimer.start();
					}
					else
					{
						// Begin the turn without moving
						TakeTurn(null);
					}
				}

				active = false;
				
				moving = true;
				scene.MovingCount++;
			}
		}
		
		// Moves the frog by accelerating it in the direction of user input
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
			if(input.leftHeld)
			{
				A.x -= physicsSpeed;
				facing.x -= physicsSpeed;
			}
			if(input.rightHeld)
			{
				A.x += physicsSpeed;
				facing.x += physicsSpeed;
			}
			if(input.upHeld)
			{
				A.y -= physicsSpeed;
				facing.y -= physicsSpeed;
			}
			if(input.downHeld)
			{
				A.y += physicsSpeed;
				facing.y += physicsSpeed;
			}
			
			// Calculate the direction of rotation according to facing
			rotation = Math.atan2(facing.y, facing.x) * (180 / Math.PI) - 90;
		}
		
		// Removes all but the first of each past state before calling Undo()
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastRotations = new <int>[pastRotations[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
		
		// Undoes a single turn, setting the actors state to as it was at that time
		internal override function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			rotation = pastRotations.pop();
			visible = pastLife.pop();
			
			// If the actor is now alive
			if(visible)
			{
				scene.Actors[gridPosition.x][gridPosition.y] = this;
			}
			
			// Reset the frog's velocity, in case its previous state was in physics movement
			V = new Vector3D(0, 0, 0);
			A = new Vector3D(0, 0, 0);
			
			UpdatePosition();
		}
	}
	
}
