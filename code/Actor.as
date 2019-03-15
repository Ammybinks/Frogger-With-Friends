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

		// The type of the actor, used to determine actions on collisions with other actors
		internal var actorType:String;
		public function get ActorType():String { return actorType };
		
		// The actor's colour, checked when determining whether the actor should win a fight
		internal var colour:String;
		public function get Colour():String { return colour };
		
		// What colour the actor is weak to, checked when determining whether the actor should win a fight
		internal var weakness:String;
		public function get Weakness():String { return weakness };
		
		// How fast the actor moves along the grid during the puzzle
		internal var gridSpeed:Number = 10;
		
		// How far the actor needs to move to reach its destination
		internal var distanceToMove:Vector3D;
		
		// If the actor is currently moving
		internal var moving:Boolean;
		
		// If the actor is currently fighting with another
		internal var fighting:Boolean;
		public function get Fighting():Boolean { return fighting; }
		public function set Fighting(value:Boolean):void { fighting = value; }
		
		// Lists of all required previous states, referred to when undoing a turn or restarting the puzzle
		internal var pastPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		internal var pastLife:Vector.<Boolean> = new Vector.<Boolean>();
		
		internal var firstUpdate:Boolean = true;
		
		public function Actor(kernel:Kernel, gridPosition:Vector3D, colour:String) {
			super(kernel, gridPosition);

			// Place the actor on the grid
			kernel.Actors[gridPosition.x][gridPosition.y] = this;
			
			this.colour = colour;
			
			SetColour();
			
			kernel.addEventListener(UndoEvent.UNDO, Undo);
			kernel.addEventListener(UndoEvent.RESTART, Restart);
		}
		
		// Sets the colour the sprite should use
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

		// Begins a movement cycle by calculating how far the actor needs to move to reach their new gridPosition
		internal function StartMove():void
		{
			distanceToMove = new Vector3D(((kernel.TileSize * gridPosition.x) + (kernel.TileSize / 2) + kernel.StageBounds[0].x) - x, ((kernel.TileSize * gridPosition.y) + (kernel.TileSize / 2) + kernel.StageBounds[0].y) - y, 0);
		}

		internal function Move():void
		{
			// If actor has reached its destination
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
		
		// Removes all but the first of each past state before calling Undo()
		internal function Restart(e:UndoEvent):void
		{
			pastPositions = new <Vector3D>[pastPositions[0]];
			pastLife = new <Boolean>[pastLife[0]];
			
			Undo(e);
		}
		
		// Undoes a single turn, setting the actors state to as it was at that time
		internal function Undo(e:UndoEvent):void
		{
			gridPosition = pastPositions.pop();
			visible = pastLife.pop();
			
			// If the actor is now alive
			if(visible)
			{
				kernel.Actors[gridPosition.x][gridPosition.y] = this;
			}
			
			UpdatePosition();
		}

		// Adds the current state to the past turn lists
		internal function AddPast():void
		{
			pastPositions.push(gridPosition.clone());
			pastLife.push(visible);
		}
		
		public function Win():void
		{
			kernel.Actors[gridPosition.x][gridPosition.y] = this;
		}
		
		public function Lose():void
		{
			visible = false;
		}
	}
}