package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class Snake extends Actor {
		var path:Vector.<Vector3D>;
		var line:int = 0;
		var pastLines:Vector.<int> = new Vector.<int>();
		var pastForwards:Vector.<Boolean> = new Vector.<Boolean>();
		var forwards:Boolean = true;
		
		var destination:Vector3D = null;
		
		public function Snake(kernel:Kernel, gridPosition:Vector3D, colour:String, playerFrog:IEventListener) {
			super(kernel, gridPosition, colour);
			
			actorType = SNAKE_TYPE;

			scaleX = scaleX * 0.8;
			scaleY = scaleY * 0.8;

			kernel.AddSnake();
			
			kernel.addEventListener(UpdateEvent.ENEMY_TURN, BeginTurn);
			kernel.addEventListener(UpdateEvent.ENEMY_COLLISIONS, CheckGridCollision);
		}

		internal override function Update(e:UpdateEvent):void {
			if(distanceToMove != null)
			{
				Move();
			}
			else if(moving && !fighting)
			{
				moving = false;
				kernel.movingCount--;
			}
		}

		private function BeginTurn(e:UpdateEvent):void
		{
			kernel.addEventListener(UpdateEvent.UPDATE, Update);
			kernel.addEventListener(UpdateEvent.BEGIN_TURN, EndTurn);
			
			pastPositions.push(gridPosition.clone());
			pastLines.push(line);
			pastForwards.push(forwards);
			pastLife.push(visible);
			
			if(visible)
			{
				kernel.MoveActor(gridPosition, destination);
				
				gridPosition = destination;
				
				destination = null;

				StartMove();
				
				moving = true;
				kernel.movingCount++;
			}
		}

		private function EndTurn(e:UpdateEvent):void
		{
			kernel.removeEventListener(UpdateEvent.UPDATE, Update);
			kernel.removeEventListener(UpdateEvent.BEGIN_TURN, EndTurn);
		}
		
		private function CheckGridCollision(e:UpdateEvent):void
		{
			if(path != null && visible)
			{
				var direction:Vector3D = new Vector3D(gridPosition.x - path[line].x, gridPosition.y - path[line].y, 0);
				direction = new Vector3D(direction.x / direction.normalize(), direction.y / direction.normalize(), 0);
				
				var tempPosition:Vector3D = new Vector3D(gridPosition.x - direction.x, gridPosition.y - direction.y, 0);
				
				var collision:IGridCollidable = kernel.actors[tempPosition.x][tempPosition.y];
				
				if(collision == null)
				{
					destination = tempPosition;
				}
				else
				{
					if(collision.ActorType == Actor.FROG_TYPE)
					{
						var fight:Fight = new Fight(this as IFighter, collision as IFighter, new Vector3D(collision.x, collision.y, 0), new Vector3D(width, height, 0));
						
						stage.addChild(fight);
					
						destination = tempPosition;
					}
					else if(collision.ActorType == Actor.SNAKE_TYPE)
					{
						SwitchLine();
						
						CheckGridCollision(null);
					}
				}
				
				if(destination != null)
				{
					if(destination.x == path[line].x && destination.y == path[line].y)
					{
						SwitchLine();
					}
				}
			}
		}
		
		/*internal override function OnGridCollide(collision:Actor):Boolean
		{
			trace((colour.charAt() + actorType.charAt()).toUpperCase() + " has collided with a " + (collision.colour.charAt() + collision.actorType.charAt()).toUpperCase());
			
			if(collision.actorType != actorType)
			{
				if(collision.colour == weakness || collision.colour == colour)
				{
					kernel.actors[gridPosition.x][gridPosition.y] = null;
					
					visible = false;
				}
				
				return true;
			}
			else
			{
				forwards = !forwards;
				
				SwitchLine();
				
				return false;
			}
		}*/
		
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
		
			if(line >= 2)
			{
				trace("I am more than two!");
			}
			line = tempLine;
		}
		
		internal override function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			line = pastLines.pop();
			forwards = pastForwards.pop();
			
			var tempVisible:Boolean = pastLife.pop();
			
			if(tempVisible != visible)
			{
				kernel.AddSnake();
			}
			
			visible = tempVisible;
			
			if(visible)
			{
				kernel.actors[gridPosition.x][gridPosition.y] = this;
			}
			
			UpdatePosition();
		}
		
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastLines = new <int>[pastLines[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
	}
	
}
