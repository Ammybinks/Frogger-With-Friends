package  {
	import flash.geom.Vector3D;
	
	public interface INext extends IActor {
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		
		function get Radius():Number;
		function set Radius(value:Number):void;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
	}
	
}
