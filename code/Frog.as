package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	// PlayerFrog is the unique class used by the primary player token, containing behaviour to move the frog according to input, rather than any other entities or paths
	public class Frog extends Actor implements IPhysicsBody, INext {
		internal var physicsBody:PhysicsManager;
		
		internal var collider:CircleCollider;
		public function get Collider():ICollider { return collider };
		
		// Current velocity
		internal var v:Vector3D = new Vector3D(0, 0, 0);
		public function get V():Vector3D { return v }
		public function set V(value:Vector3D):void { v = value }
		
		// Acceleration
		internal var a:Vector3D = new Vector3D(0, 0, 0);
		public function get A():Vector3D { return a }
		public function set A(value:Vector3D):void { a = value }
		
		internal var elasticity:Number = 0.85;
		public function get Elasticity():Number { return elasticity }
		
		internal var friction:Number = 0.8;
		public function get Friction():Number { return friction }
		
		internal var radius:Number;
		public function get Radius():Number { return radius }
		
		// Trigger objects will collide with others, but won't create pushback force, meaning they can be moved through freely
		internal var isTrigger:Boolean = false;
		public function get IsTrigger():Boolean { return isTrigger }
		
		// A descriptor of the type of object the object is, used by other objects to determine what specific collision behaviour to enact
		internal var collisionType:String = "";
		public function get CollisionType():String { return collisionType }
		
		// How fast the actor accelerates and moves after the puzzle is solved
		internal var physicsSpeed = 2;
		
		internal var maxSpeed:Number = 100;
		public function get MaxSpeed():Number { return maxSpeed }
		
		internal var minSpeed:Number = 0.1;
		public function get MinSpeed():Number { return minSpeed }
		
		// Timer to determine when to instruct the next frog in the sequence to take its turn
		internal var turnTimer: Timer = new Timer(1000 / 30);
		
		// List of previous rotations, to ensure the frog always faces the correct direction after an undo command
		internal var pastRotations:Vector.<int> = new Vector.<int>();
		
		public function Frog(kernel:Kernel, gridPosition:Vector3D, colour:String):void {
			super(kernel, gridPosition, colour);
			
			actorType = FROG_TYPE;

			// Set the radius based on the overall size of the frog
			radius = (width / 2) * 0.75;
			
			physicsBody = new PhysicsManager(this);
			collider = new CircleCollider(this, kernel.StageBounds);
			
			kernel.Collidables.push(this);
			turnTimer.addEventListener(TimerEvent.TIMER, TakeTurn);
		}
		
		// Instructs the next frog in the queue to take its turn
		internal function TakeTurn(e:TimerEvent)
		{
			if(hasEventListener(TurnEvent.PLAYER_TURN))
			{
				dispatchEvent(new TurnEvent(TurnEvent.PLAYER_TURN));
			}
			
			turnTimer.stop();
		}

		// Moves the frog outside of the given collision area
		public function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void
		{
			if(!isTrigger)
			{
				A.x -= direction.x * depth * Elasticity;
				A.y -= direction.y * depth * Elasticity;
			}
		}
		
		// Adds the current state to the past turn lists
		internal override function AddPast():void
		{
			pastPositions.push(gridPosition.clone());
			pastRotations.push(rotation);
			pastLife.push(visible);
		}
		
		public override function Lose():void
		{
			kernel.FrogDied();
			
			visible = false;
		}
	}
	
}
