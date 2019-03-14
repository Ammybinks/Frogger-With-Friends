package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	// Actor is a generic class that stores an objects position on the game grid, used for any entity that changes position over the course of the game
	public class Actor extends GridObject implements IUpdatable, IGridCollidable, IFighter {
		static var FROG_TYPE:String = "frogType";
		static var SNAKE_TYPE:String = "snakeType";
		
		static var GREEN_COLOUR:String = "greenColour";
		static var BLUE_COLOUR:String = "blueColour";
		static var RED_COLOUR:String = "redColour";

		public function get Width():Number { return width; }
		
		internal var actorType:String;
		public function get ActorType():String { return actorType };
		public function set ActorType(value:String):void { actorType = value };
		
		internal var colour:String;
		public function get Colour():String { return colour };
		public function set Colour(value:String):void { colour = value };
		
		internal var weakness:String;
		public function get Weakness():String { return weakness };
		public function set Weakness(value:String):void { weakness = value };
		
		var moving:Boolean;
		var alive = true;
		
		var pastPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		var pastLife:Vector.<Boolean> = new Vector.<Boolean>();
		
		var firstUpdate:Boolean = true;
		
		var fighting:Boolean = false;
		var currentFight:Fight;
		
		var gridSpeed:Number = 10;
		
		var distanceToMove:Vector3D;
		
		public function Actor(kernel:Kernel, gridPosition:Vector3D, colour:String) {
			super(kernel, gridPosition);

			kernel.actors[gridPosition.x][gridPosition.y] = this;
			
			this.colour = colour;
			
			SetColour();
			
			kernel.addEventListener(UndoEvent.UNDO, Undo);
			kernel.addEventListener(UndoEvent.RESTART, Restart);
		}
		
		internal function SetColour():void
		{
			if(colour == GREEN_COLOUR)
			{
				gotoAndStop(1);
				weakness = RED_COLOUR;
			}
			else if(colour == BLUE_COLOUR)
			{
				gotoAndStop(2);
				weakness = GREEN_COLOUR;
			}
			else if(colour == RED_COLOUR)
			{
				gotoAndStop(3);
				weakness = BLUE_COLOUR
			}
		}
		
		public function Update():void
		{
			
		}
		
		internal function CheckCollision():void
		{
			
		}

		internal function StartMove():void
		{
			distanceToMove = new Vector3D(((kernel.tileSize * gridPosition.x) + (kernel.tileSize / 2) + kernel.stageBounds[0].x) - x, ((kernel.tileSize * gridPosition.y) + (kernel.tileSize / 2) + kernel.stageBounds[0].y) - y, 0);
		}

		internal function Move():void
		{
			if(Math.abs(distanceToMove.x) < gridSpeed && Math.abs(distanceToMove.y) < gridSpeed)
			{
				distanceToMove = null;
				
				UpdatePosition();
			}
			else
			{
				var tempDistance:Vector3D = distanceToMove.clone();
				tempDistance.normalize();
				var movement:Vector3D = new Vector3D(tempDistance.x * gridSpeed, tempDistance.y * gridSpeed, 0);
				
				x += movement.x;
				y += movement.y;
				
				distanceToMove.x -= movement.x;
				distanceToMove.y -= movement.y;
			}
		}
		
		/*internal function OnGridCollide(collision:Actor):Boolean
		{
			trace((colour.charAt() + actorType.charAt()).toUpperCase() + " has collided with a " + (collision.colour.charAt() + collision.actorType.charAt()).toUpperCase());
			
			if(collision.actorType != actorType)
			{
				if(collision.colour == weakness || collision.colour == colour)
				{
					kernel.actors[gridPosition.x][gridPosition.y] = null;
					
					if(hasEventListener(StateEvent.ACTOR_DIED))
					{
						dispatchEvent(new StateEvent(StateEvent.ACTOR_DIED));
					}
					
					visible = false;
				}
				
				return true;
			}
			else
			{
				return false;
			}
		}*/
		
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
				kernel.actors[gridPosition.x][gridPosition.y] = this;
			}
			
			UpdatePosition();
		}

		public function StartFight():void
		{
			kernel.actors[gridPosition.x][gridPosition.y] = null;
			
			fighting = true;
		}
		
		public function StopFight():void
		{
			fighting = false;
		}
		
		public function Win():void
		{
			kernel.actors[gridPosition.x][gridPosition.y] = this;
		}
		
		public function Lose():void
		{
			if(hasEventListener(StateEvent.ACTOR_DIED))
			{
				dispatchEvent(new StateEvent(StateEvent.ACTOR_DIED));
			}
			
			visible = false;
		}
	}
}