package  {
	
	public interface IFighter {
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get Colour():String;
		function set Colour(value:String):void;
		function get Weakness():String;
		function set Weakness(value:String):void;
		function get Width():Number;

		function StartFight():void;
		function StopFight():void;
		function Win():void;
		function Lose():void;
	}
	
}
