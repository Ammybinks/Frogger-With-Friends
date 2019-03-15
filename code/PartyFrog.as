package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PartyFrog extends Frog {
		// The next frog in the party, which this frog follows
		private var next:INext;
		
		// Position of next, used to determine if the frog should start moving
		private var oldNextPosition:Vector3D = new Vector3D(0, 0, 0);
		
		// List of previous positions next has been in, to rotate the frog correctly after an undo command
		private var pastNextPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		// How far away next can be before the frog starts moving towards it
		private var leashRadius = 95;
		// How far away next can be before the frog is moving at maximum speed
		private var maxDistance = 120;
		
		public function PartyFrog(kernel:Kernel, gridPosition:Vector3D, colour:String, next:INext):void {
			super(kernel, gridPosition, colour);
			
			this.next = next;
			
			oldNextPosition.x = next.GridPosition.x;
			oldNextPosition.y = next.GridPosition.y;
			
			UpdateRotation();
			
			// Event listener that triggers when the frog should take its turn
			next.addEventListener(TurnEvent.PLAYER_TURN, BeginTurn);
		}
		
		public override function Update():void {
			if(kernel.Solved)
			{
				physicsBody.Update();

				// Calculate the direction towards next
				var direction:Vector3D = new Vector3D(next.x - x, next.y - y);
				
				// If the frog is out of range of next
				if(direction.clone().normalize() >= leashRadius)
				{	
					// Calculate how much of the frog's total speed should be used as a percentage of the distance
					// 0% being the base from 0 distance to leashRadius, while 100% is reached when the distance is equal to maxDistance
					var percent = (direction.clone().normalize() - leashRadius) / (maxDistance - leashRadius);
					
					direction.normalize();
					
					// Accelerate towards next at a speed according to the frog's speed and distance between them
					A.x += direction.x * (physicsSpeed * percent);
					A.y += direction.y * (physicsSpeed * percent);
				}
				
				// Rotate to face next
				rotation = Math.atan2(direction.y, direction.x) * (180 / Math.PI) - 90;
			}
			else
			{
				if(distanceToMove != null)
				{
					Move();
				}
				// If there is no distance to move and the frog was moving
				else if(moving)
				{
					UpdateRotation();
					
					moving = false;
					kernel.MovingCount--;
				}
			}
		}
		
		// Begin moving the frog at the start of its turn
		private function BeginTurn(e:TurnEvent):void
		{
			AddPast();
			
			// If next has moved this turn
			if(oldNextPosition.x != next.GridPosition.x || oldNextPosition.y != next.GridPosition.y)
			{
				// Move to next's old position
				kernel.AbsoluteMoveActor(this, oldNextPosition);
				
				gridPosition = oldNextPosition;
				
				oldNextPosition = next.GridPosition;
				
				moving = true;
				kernel.MovingCount++;
				
				StartMove();
				
				turnTimer.start();
			}
			else
			{
				// Take turn without moving
				TakeTurn(null);
			}
		}
		
		// Changes the rotation of the frog to be facing next
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
		
		// Undoes a single turn, setting the actors state to as it was at that time
		internal override function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			oldNextPosition = pastNextPositions.pop();
			rotation = pastRotations.pop();
			visible = pastLife.pop();
			
			// If the actor is now alive
			if(visible)
			{
				kernel.Actors[gridPosition.x][gridPosition.y] = this;
			}
			
			// Reset the frog's velocity, in case its previous state was in physics movement
			V = new Vector3D(0, 0, 0);
			A = new Vector3D(0, 0, 0);
			
			UpdatePosition();
		}
		
		// Removes all but the first of each past state before calling Undo()
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastNextPositions = new <Vector3D>[pastNextPositions[0]];
			pastRotations = new <int>[pastRotations[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
		
		// Adds the current state to the past turn lists
		internal override function AddPast():void
		{
			pastPositions.push(gridPosition.clone());
			pastNextPositions.push(oldNextPosition.clone());
			pastRotations.push(rotation);
			pastLife.push(visible);
		}
	}
	
}
