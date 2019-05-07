package  {
	import flash.geom.Vector3D;
	
	public interface INext {
		function get x():Number;
		function get y():Number;
		
		function get GridPosition():Vector3D;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
	}
	
}
