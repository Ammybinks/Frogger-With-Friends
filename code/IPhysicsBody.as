package  {
	import flash.geom.Vector3D;
	
	public interface IPhysicsBody extends IPhysicsCollidable {
		function get V():Vector3D;
		function set V(value:Vector3D):void;
		function get A():Vector3D;
		function set A(value:Vector3D):void;
		
		function get Friction():Number;
		function get MaxSpeed():Number;
		function get MinSpeed():Number;
	}
}
