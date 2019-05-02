package  {
	import flash.geom.Vector3D;
	import flash.display.MovieClip;
	
	public interface IScene {
		function get Entities():Vector.<Object>;
		function set Entities(value:Vector.<Object>):void;
		
		function get Next():IScene;
		function set Next(value:IScene):void;
		
		function get Unloading():Boolean;
		
		function Update():void;
		function Initialise(stage:Object):void;
		function LoadContent(stage:Object):void;
		function UnloadContent(stage:Object):IScene;
	}
}