package  {
	
	public interface IFighter {
		function get Colour():String;
		function set Colour(value:String):void;
		function get Weakness():String;
		function set Weakness(value:String):void;

		function StartFight():void;
		function StopFight():void;
		function Win():void;
		function Lose():void;
	}
	
}
