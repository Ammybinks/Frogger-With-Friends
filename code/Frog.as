package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Frog extends Actor {
		var next:Actor;
		var oldNextPosition:Vector3D = new Vector3D(0, 0, 0);
		var pastNextPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		public function Frog(kernel:Kernel, gridPosition:Vector3D, next:Actor, lead:Actor):void {
			super(kernel, gridPosition);
			
			this.next = next;
			oldNextPosition.x = next.gridPosition.x;
			oldNextPosition.y = next.gridPosition.y;
			
			actorType = FROG_TYPE;

			lead.addEventListener(UpdateEvent.PLAYER_TURN, Update);
		}
		

		internal override function Update(e:UpdateEvent):void {
			pastPositions.push(gridPosition.clone());
			pastNextPositions.push(oldNextPosition.clone());
			pastLife.push(visible);
				
			if(oldNextPosition.x != next.gridPosition.x || oldNextPosition.y != next.gridPosition.y)
			{
				kernel.MoveActor(gridPosition, oldNextPosition);
				
				gridPosition.x = oldNextPosition.x;
				gridPosition.y = oldNextPosition.y;
				
				oldNextPosition.x = next.gridPosition.x;
				oldNextPosition.y = next.gridPosition.y;
				
				UpdateRotation();
			}
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
			oldNextPosition = pastNextPositions.pop();
			gridPosition = pastPositions.pop();
			visible = pastLife.pop();
			
			kernel.AddActor(this);

			UpdateRotation();
		}
		
		internal override function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastNextPositions = new <Vector3D>[pastNextPositions[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
	}
	
}
