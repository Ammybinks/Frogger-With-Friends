package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PartyFrog extends Frog {
		var next:INext;
		var oldNextPosition:Vector3D = new Vector3D(0, 0, 0);
		var pastNextPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		// How far away the lead can be before the frog starts moving towards it
		private var leashRadius = 95;
		// How far away the lead can be before the frog is moving at maximum speed
		private var maxDistance = 120;
		
		public function PartyFrog(kernel:Kernel, gridPosition:Vector3D, colour:String, next:INext):void {
			super(kernel, gridPosition, colour);
			
			this.next = next;
			oldNextPosition.x = next.GridPosition.x;
			oldNextPosition.y = next.GridPosition.y;
			
			UpdateRotation();
			
			kernel.addEventListener(StateEvent.PUZZLE_SOLVED, OnSolved);
			next.addEventListener(UpdateEvent.PLAYER_TURN, BeginTurn);
		}
		
		internal override function Update(e:UpdateEvent):void {
			if(kernel.solved)
			{
				physicsBody.Update();

				var direction:Vector3D = new Vector3D(next.x - x, next.y - y);
				
				// If the collider's support point is inside of the collision's radius
				if(direction.clone().normalize() >= leashRadius)
				{	
					var percent = (direction.clone().normalize() - leashRadius) / (maxDistance - leashRadius);
					
					direction.normalize();
					
					// Add force pushing away from the collision at a speed according to how much the two bodies were colliding and the current bodies' elasticity
					physicsBody.Accelerate(direction.x * (physicsSpeed * percent), direction.y * (physicsSpeed * percent));
					trace(physicsSpeed * percent);
				}
				
				
				// Reflect changes on main b
				rotation = Math.atan2(direction.y, direction.x) * (180 / Math.PI) - 90;
			}
			else
			{
				if(distanceToMove != null)
				{
					Move();
				}
				else if(moving)
				{
					UpdateRotation();
					
					moving = false;
					kernel.movingCount--;
				}
			}
		}
		
		private function BeginTurn(e:UpdateEvent):void
		{
			kernel.addEventListener(UpdateEvent.UPDATE, Update);
			kernel.addEventListener(UpdateEvent.ENEMY_COLLISIONS, EndTurn);
			
			pastPositions.push(gridPosition.clone());
			pastNextPositions.push(oldNextPosition.clone());
			pastRotations.push(rotation);
			pastLife.push(visible);
				
			if(oldNextPosition.x != next.GridPosition.x || oldNextPosition.y != next.GridPosition.y)
			{
				kernel.MoveActor(gridPosition, oldNextPosition);
				
				gridPosition = oldNextPosition;
				
				oldNextPosition = next.GridPosition;
				
				moving = true;
				kernel.movingCount++;
				
				StartMove();
				
				turnTimer.start();
			}
			else
			{
				TakeTurn(null);
			}
		}

		private function EndTurn(e:UpdateEvent):void
		{
			kernel.removeEventListener(UpdateEvent.UPDATE, Update);
			kernel.removeEventListener(UpdateEvent.ENEMY_COLLISIONS, EndTurn);
		}
		
		private function OnSolved(e:StateEvent):void
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
				kernel.actors[gridPosition.x][gridPosition.y] = this;
			}
			
			UpdatePosition();
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
