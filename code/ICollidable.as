package  {
	import flash.geom.Vector3D;
	
	public interface ICollidable {
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
		function get A():Vector3D;
		function set A(value:Vector3D):void;
		
		function get Elasticity():Number;
		function set Elasticity(value:Number):void;
		function get Radius():Number;
		function set Radius(value:Number):void;
	}
}
