package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class Snake extends Actor {
		var path:Vector.<Vector3D>;
		var line:int = 0;
		var pastLines:Vector.<int> = new Vector.<int>();
		var forwards:Boolean = true;
		var playerFrog:PlayerFrog;
		
		public function Snake(kernel:Kernel, gridPosition:Vector3D, playerFrog:PlayerFrog) {
			super(kernel, gridPosition);
			this.playerFrog = playerFrog;
			
			scaleX = scaleX * 0.8;
			scaleY = scaleY * 0.8;

			actorType = SNAKE_TYPE;
			
			playerFrog.addEventListener(UpdateEvent.ENEMY_TURN, Update);
		}

		internal override function Update(e:UpdateEvent):void {
			pastPositions.push(gridPosition.clone());
			pastLines.push(line);
			pastLife.push(visible);
			
			if(firstUpdate)
			{
				firstUpdate = false;
			}
			else if(path != null && visible)
			{
				var collision:Actor = UpdateGridPosition();
				
				if(collision != null)
				{
					Collide(collision);
					collision.Collide(this);
					
					UpdateGridPosition();
				}
				//gridPosition = new Vector3D(gridPosition.x - direction.x, gridPosition.y - direction.y, 0);

			}
		}

		private function UpdateGridPosition():Actor
		{
			var direction:Vector3D = new Vector3D(gridPosition.x - path[line].x, gridPosition.y - path[line].y, 0);
			direction = new Vector3D(direction.x / direction.normalize(), direction.y / direction.normalize(), 0);
			
			var tempPosition:Vector3D = new Vector3D(gridPosition.x - direction.x, gridPosition.y - direction.y, 0);
			var collision:Actor;
			
			if((collision = kernel.MoveActor(gridPosition, tempPosition)) == null)
			{
				gridPosition = tempPosition;
				
				if(gridPosition.x == path[line].x && gridPosition.y == path[line].y)
				{
					SwitchLine();
				}
			}
			
			return collision;
		}
		
		internal override function Collide(collision:Actor):Boolean
		{
			trace(getQualifiedClassName(this) + " has collided with a " + getQualifiedClassName(collision));
			
			if(collision.actorType != actorType)
			{
				if(collision.colour == weakness || collision.colour == colour)
				{
					kernel.RemoveActor(this, gridPosition);
					
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
		}
		
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
			visible = pastLife.pop();
			
			kernel.AddActor(this);
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
