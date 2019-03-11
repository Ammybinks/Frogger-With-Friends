package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	// Actor is a generic class that stores an objects position on the game grid, used for any entity that changes position over the course of the game
	public class Actor extends GridObject implements IGridCollidable, IFighter {
		static var FROG_TYPE:String = "frogType";
		static var SNAKE_TYPE:String = "snakeType";
		
		static var GREEN_COLOUR:String = "greenColour";
		static var BLUE_COLOUR:String = "blueColour";
		static var RED_COLOUR:String = "redColour";
		
		internal var actorType:String;
		public function get ActorType():String { return actorType }
		public function set ActorType(value:String):void { actorType = value }
		
		internal var colour:String;
		public function get Colour():String { return colour }
		public function set Colour(value:String):void { colour = value }
		
		internal var weakness:String;
		public function get Weakness():String { return weakness }
		public function set Weakness(value:String):void { weakness = value }
		
		var moving:Boolean;
		var alive = true;
		
		var pastPositions:Vector.<Vector3D> = new Vector.<Vector3D>();
		var pastLife:Vector.<Boolean> = new Vector.<Boolean>();
		
		var firstUpdate:Boolean = true;
		
		var fighting:Boolean = false;
		
		public function Actor(kernel:Kernel, gridPosition:Vector3D, colour:String) {
			super(kernel, gridPosition);

			kernel.actors[gridPosition.x][gridPosition.y] = this;
			
			this.colour = colour;
			
			SetColour();
			
			kernel.addEventListener(UpdateEvent.UPDATE, UpdatePosition);
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
		
		internal function Update(e:UpdateEvent):void
		{
			
		}
		
		internal function CheckCollision():void
		{
			
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