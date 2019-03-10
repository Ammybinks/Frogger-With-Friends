package  {
	import flash.geom.Vector3D;
	
	public interface IPhysicsBody extends ICollidable {
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		function get V():Vector3D;
		function set V(value:Vector3D):void;
		function get M():Vector3D;
		function set M(value:Vector3D):void;
		
		function get Friction():Number;
		function set Friction(value:Number):void;
		function get MaxSpeed():Number;
		function set MaxSpeed(value:Number):void;
		function get MinSpeed():Number;
		function set MinSpeed(value:Number):void;
	}
}
