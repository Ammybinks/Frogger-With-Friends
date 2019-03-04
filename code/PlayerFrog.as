package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	
	// PlayerFrog is the unique class used by the primary player token, containing behaviour to move the frog according to input, rather than any other entities or paths
	public class PlayerFrog extends Actor {
		var physicsBody:PhysicsManager;
		var input:InputManager;
		
		var speed:Number = 2;
		
		var pastRotations:Vector.<int> = new Vector.<int>();
		
		public function PlayerFrog(kernel:Kernel, gridPosition:Vector3D):void {
			super(kernel, gridPosition);
			
			input = kernel.input;
			
			actorType = FROG_TYPE;
			colour = GREEN_COLOUR;
			weakness = RED_COLOUR;
			
			kernel.addEventListener(UpdateEvent.UPDATE, Update);
			// Create new manager for physics interactions
			physicsBody = new PhysicsManager(this);
		}

		internal override function Update(e:UpdateEvent):void {
			if(firstUpdate)
			{
				TakeTurn();
				
				firstUpdate = false;
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
				if(hasEventListener(UpdateEvent.ENEMY_TURN))
				{
					dispatchEvent(new UpdateEvent(UpdateEvent.ENEMY_TURN));
				}
		}
		
		private function GridMove()
		{
			var tempPosition:Vector3D;
			
			if(!visible)
			{
				pastRotations.push(rotation);
				pastPositions.push(gridPosition.clone());
				pastLife.push(visible);
			}
			else if(moving)
			{
				moving = false;
			}
			else if(input.leftTapped || input.rightTapped || input.upTapped || input.downTapped)
			{
				pastRotations.push(rotation);
				pastPositions.push(gridPosition.clone());
				pastLife.push(visible);
				
				// Moves the frog along the grid
				if(input.leftTapped)
				{
					if(gridPosition.x - 1 >= 0)
					{
						tempPosition = new Vector3D(gridPosition.x - 1, gridPosition.y, 0);
					}
					
					rotation = 90;
				}
				else if(input.rightTapped)
				{
					if(gridPosition.x + 1 < kernel.stageSize)
					{
						tempPosition = new Vector3D(gridPosition.x + 1, gridPosition.y, 0);
					}
					
					rotation = 270;
				}
				else if(input.upTapped)
				{
					if(gridPosition.y - 1 >= 0)
					{
						tempPosition = new Vector3D(gridPosition.x, gridPosition.y - 1, 0);
					}
					
					rotation = 180;
				}
				else if(input.downTapped)
				{
					if(gridPosition.y + 1 < kernel.stageSize)
					{
						tempPosition = new Vector3D(gridPosition.x, gridPosition.y + 1, 0);
					}
					
					rotation = 0;
				}
			}
			
			if(tempPosition != null)
			{
				var collision:Actor
				
				if((collision = kernel.MoveActor(gridPosition, tempPosition)) == null)
				{
					gridPosition = tempPosition;
					
					moving = true;
				}
				else
				{
					collision.Collide(this);
					if(Collide(collision))
					{
						kernel.MoveActor(gridPosition, tempPosition);
						
						gridPosition = tempPosition;
						
						moving = true;
					}
					
				}
				
				TakeTurn();
			}
		}
		
		private function PhysicsMove()
		{
			physicsBody.Update();
			
			if(kernel.input.leftHeld)
			{
				physicsBody.AddSpeed(-speed, 0);
			}
			if(kernel.input.rightHeld)
			{
				physicsBody.AddSpeed(speed, 0);
			}
			if(kernel.input.upHeld)
			{
				physicsBody.AddSpeed(0, -speed);
			}
			if(kernel.input.downHeld)
			{
				physicsBody.AddSpeed(0, speed);
			}

			rotation = Math.atan2(physicsBody.v.y, physicsBody.v.x) * (180 / Math.PI) - 90;
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
			
			kernel.AddActor(this);
		}
	}
	
}
