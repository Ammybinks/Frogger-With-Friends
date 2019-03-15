package  {
	import flash.geom.Vector3D;
	
	public interface IPhysicsCollidable {
		function get Collider():ICollider;
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
		function get Radius():Number;

		function get IsTrigger():Boolean;
		function get CollisionType():String;
		
		function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void;
	}
}
