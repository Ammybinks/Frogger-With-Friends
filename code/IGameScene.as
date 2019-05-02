package  {
	import flash.geom.Vector3D;
	import flash.display.MovieClip;
	
	public interface IGameScene extends IScene {
		function get Input():InputManager;
		
		function get Collidables():Vector.<IPhysicsCollidable>;
		
		function get StageSize():int;
		
		function get TileSize():Number;
		
		function get StageBounds():Vector.<Vector3D>;
		
		function get Actors():Vector.<Vector.<IGridCollidable>>;
		
		function get MovingCount():int;
		function set MovingCount(value:int):void;
		
		function get Solved():Boolean;
		function get GameOver():Boolean;
		function get GameComplete():Boolean;

		function EndGame():void;
		function FrogDied():void;
		function SnakeDied():void;
		function AddSnake():void;
		function AbsoluteMoveActor(actor:Actor, newPosition:Vector3D):void;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
	}
	
}
