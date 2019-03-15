package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class Snake extends Actor {
		// Series of points constituting the path the snake travels
		private var path:Vector.<Vector3D>;
		public function get Path():Vector.<Vector3D> { return path; }
		public function set Path(value:Vector.<Vector3D>) { path = value; }

		// Whether the snake is moving backwards or forwards through the path list
		private var forwards:Boolean = true;
		
		// Which line of the path the snake is currently travelling
		private var line:int = 0;
		
		// List of previous line and forwards state, ensuring the snake continues moving in the correct direction after an undo command
		private var pastLines:Vector.<int> = new Vector.<int>();
		private var pastForwards:Vector.<Boolean> = new Vector.<Boolean>();
		
		private var destination:Vector3D = null;
		
		public function Snake(kernel:Kernel, gridPosition:Vector3D, colour:String) {
			super(kernel, gridPosition, colour);
			
			actorType = SNAKE_TYPE;

			// Reduce the default size of the snake to be smaller than the entire size of a grid square
			scaleX = scaleX * 0.8;
			scaleY = scaleY * 0.8;

			kernel.AddSnake();
			
			// Event listeners which trigger the snake's turn from kernel
			kernel.addEventListener(TurnEvent.ENEMY_TURN, BeginTurn);
			kernel.addEventListener(TurnEvent.ENEMY_COLLISIONS, CheckGridCollision);
		}

		public override function Update():void {
			if(distanceToMove != null)
			{
				Move();
			}
			else if(moving && !fighting)
			{
				moving = false;
				kernel.MovingCount--;
			}
		}

		// Begin moving the snake at the start of its turn
		private function BeginTurn(e:TurnEvent):void
		{
			AddPast();
			
			if(visible)
			{
				// Move to the next position in the sequence
				
				kernel.AbsoluteMoveActor(this, destination);
				
				gridPosition = destination;
				
				destination = null;

				StartMove();
				
				moving = true;
				kernel.MovingCount++;
			}
		}

		// Checks that the position the snake would move into is empty before moving, either triggering a fight or switching its line if it collides with something
		private function CheckGridCollision(e:TurnEvent):void
		{
			if(path != null && visible)
			{
				// Determine direction to move
				var direction:Vector3D = new Vector3D(gridPosition.x - path[line].x, gridPosition.y - path[line].y, 0);
				direction.normalize();
				
				// Determine the next position the snake will move to
				var tempPosition:Vector3D = new Vector3D(gridPosition.x - direction.x, gridPosition.y - direction.y, 0);
				
				// Find any object at the projected position
				var collision:IGridCollidable = kernel.Actors[tempPosition.x][tempPosition.y];
				
				// If there is no object in the space, move the snake like normal
				if(collision == null)
				{
					destination = tempPosition;
				}
				else
				{
					// If the snake has collided with a frog
					if(collision.ActorType == Actor.FROG_TYPE)
					{
						// Begin a fight between the snake and the frog
						var fight:Fight = new Fight(this as IFighter, collision as IFighter, new Vector3D(collision.x, collision.y, 0), new Vector3D(width, height, 0));
						
						stage.addChild(fight);
					
						// Move the snake into the fight
						destination = tempPosition;
					}
					// If the snake has collided with another snake
					else if(collision.ActorType == Actor.SNAKE_TYPE)
					{
						// Switch the direction the snake is moving in
						SwitchLine();
						
						// Check collision again, in case there is a collision on both sides
						CheckGridCollision(null);
					}
				}
				
				// If the snake is moving somewhere
				if(destination != null)
				{
					// Change the snake's direction when it reaches the end of its current line
					if(destination.x == path[line].x && destination.y == path[line].y)
					{
						SwitchLine();
					}
				}
			}
		}
		
		// Switches to the next line in the sequence
		private function SwitchLine():void
		{
			var tempLine:int;
			
			if(forwards)
			{
				if(line + 1 < path.length)
				{
					tempLine = line + 1;
				}
				else
				{
					tempLine = line - 1;
					
					forwards = false;
				}
			}
			else
			{
				if(line - 1 > 0)
				{
					tempLine = line - 1;
				}
				else
				{
					tempLine = line + 1;
					
					forwards = true;
				}
			}
			
			line = tempLine;
		}
		
		// Removes all but the first of each past state before calling Undo()
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastLines = new <int>[pastLines[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}

		// Undoes a single turn, setting the actors state to as it was at that time
		internal override function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			line = pastLines.pop();
			forwards = pastForwards.pop();
			
			var tempVisible:Boolean = pastLife.pop();
			
			// If the snake is transitioning from being destroyed to being alive
			if(tempVisible != visible)
			{
				kernel.AddSnake();
			}
			
			visible = tempVisible;
			
			// If the actor is now alive
			if(visible)
			{
				kernel.Actors[gridPosition.x][gridPosition.y] = this;
			}
			
			UpdatePosition();
		}
		
		// Adds the current state to the past turn lists
		internal override function AddPast():void
		{
			pastPositions.push(gridPosition.clone());
			pastLines.push(line);
			pastForwards.push(forwards);
			pastLife.push(visible);
		}
		
		public override function Lose():void
		{
			kernel.SnakeDied();
			
			visible = false;
		}
	}
	
}
