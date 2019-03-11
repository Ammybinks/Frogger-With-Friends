package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	// PlayerFrog is the unique class used by the primary player token, containing behaviour to move the frog according to input, rather than any other entities or paths
	public class Frog extends Actor implements IPhysicsBody, INext {
		var physicsBody:PhysicsManager;
		var collider:CircleCollider;
		
		// Current velocity
		internal var v:Vector3D = new Vector3D(0, 0, 0);
		public function get V():Vector3D { return v }
		public function set V(value:Vector3D):void { v = value }
		// Object mass
		internal var m:Vector3D = new Vector3D(0, 0, 0);
		public function get M():Vector3D { return m }
		public function set M(value:Vector3D):void { m = value }
		// Acceleration
		internal var a:Vector3D = new Vector3D(0, 0, 0);
		public function get A():Vector3D { return a }
		public function set A(value:Vector3D):void { a = value }
		
		internal var elasticity:Number = 0.85;
		public function get Elasticity():Number { return elasticity }
		public function set Elasticity(value:Number):void { elasticity = value }
		
		internal var friction:Number = 0.8;
		public function get Friction():Number { return friction }
		public function set Friction(value:Number):void { friction = value }
		
		internal var radius:Number;
		public function get Radius():Number { return radius }
		public function set Radius(value:Number):void { radius = value }
		
		internal var isTrigger:Boolean = false;
		public function get IsTrigger():Boolean { return isTrigger }
		public function set IsTrigger(value:Boolean):void { isTrigger = value }
		
		internal var collisionType:String = "";
		public function get CollisionType():String { return collisionType }
		public function set CollisionType(value:String):void { collisionType = value }
		
		internal var maxSpeed:Number = 100;
		public function get MaxSpeed():Number { return maxSpeed }
		public function set MaxSpeed(value:Number):void { maxSpeed = value }
		
		internal var minSpeed:Number = 0.1;
		public function get MinSpeed():Number { return minSpeed }
		public function set MinSpeed(value:Number):void { minSpeed = value }
		
		internal var physicsSpeed = 2;
		
		var pastRotations:Vector.<int> = new Vector.<int>();
		
		var turnTimer: Timer = new Timer(1000 / 10);
		
		public function Frog(kernel:Kernel, gridPosition:Vector3D, colour:String):void {
			super(kernel, gridPosition, colour);
			
			actorType = FROG_TYPE;

			radius = (width / 2) * 0.75;
			
			physicsBody = new PhysicsManager(this);
			collider = new CircleCollider(this, kernel.stageBounds);
			
			kernel.AddCollider(this, collider.CheckCollision);
			kernel.addEventListener(CollisionEvent.CHECK_COLLISION, collider.CheckCollision);
			turnTimer.addEventListener(TimerEvent.TIMER, TakeTurn);
		}
		
		internal function TakeTurn(e:TimerEvent)
		{
			if(hasEventListener(UpdateEvent.PLAYER_TURN))
			{
				dispatchEvent(new UpdateEvent(UpdateEvent.PLAYER_TURN));
			}
			
			turnTimer.stop();
		}

		public function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void
		{
			if(!isTrigger)
			{
				A.x -= direction.x * depth * Elasticity;
				A.y -= direction.y * depth * Elasticity;
			}
		}
	}
	
}
