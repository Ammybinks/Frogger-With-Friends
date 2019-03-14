package  {
	import flash.geom.Vector3D;
	
	public interface IPhysicsCollidable {
		function get Collider():ICollider;
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
		function get Radius():Number;
		function set Radius(value:Number):void;

		function get IsTrigger():Boolean;
		function set IsTrigger(value:Boolean):void;
		function get CollisionType():String;
		function set CollisionType(value:String):void;
		
		function OnPhysicsCollide(direction:Vector3D, depth:Number, isTrigger:Boolean, collisionType:String):void;
	}
}
