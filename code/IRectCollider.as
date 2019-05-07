package  {
	import flash.geom.Vector3D;
	
	public interface IRectCollider extends ICollider {
		function get UpperLeft():Vector3D
		function get BottomRight():Vector3D
	}
	
}
