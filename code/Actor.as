package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	// Actor is a generic class that stores an objects position on the game grid, used for any entity that changes position over the course of the game
	public class Actor extends MovieClip {
		static var FROG_TYPE:String = "frogType";
		static var SNAKE_TYPE:String = "snakeType";
		
		static var GREEN_COLOUR:String = "greenColour";
		static var BLUE_COLOUR:String = "blueColour";
		static var RED_COLOUR:String = "redColour";
		
		var actorType:String;
		var colour:String;
		var weakness:String;
		
		var kernel:Kernel;
		
		internal var gridPosition:Vector3D;
		public function get GridPosition():Vector3D { return gridPosition }
		public function set GridPosition(value:Vector3D):void { gridPosition = value }
		
		var moving:Boolean;
		var alive = true;
		
		var pastPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		var pastLife:Vector.<Boolean> = new Vector.<Boolean>();
		
		var firstUpdate:Boolean = true;
		
		public function Actor(kernel:Kernel, gridPosition:Vector3D) {
			this.kernel = kernel;
			this.gridPosition = gridPosition;
			
			height = kernel.tileSize;
			width = kernel.tileSize;
			
			kernel.addEventListener(UpdateEvent.UPDATE, UpdatePosition);
			kernel.addEventListener(UndoEvent.UNDO, Undo);
			kernel.addEventListener(UndoEvent.RESTART, Restart);
		}
		
		internal function Update(e:UpdateEvent):void
		{
			
		}
		
		internal function CheckCollision():void
		{
			
		}

		// Locks the frog to its' determined position on the grid
		public function UpdatePosition(e:UpdateEvent):void
		{
			if(!kernel.solved)
			{
				x = (kernel.tileSize * gridPosition.x) + (kernel.tileSize / 2) + kernel.stageBounds[0].x;
				y = (kernel.tileSize * gridPosition.y) + (kernel.tileSize / 2) + kernel.stageBounds[0].y;
			}
		}
		
		internal function Collide(collision:Actor):Boolean
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
				return false;
			}
		}
		
		internal function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
		
		internal function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			visible = pastLife.pop();
			
			if(visible)
			{
				kernel.AddActor(this);
			}
		}
	}
}