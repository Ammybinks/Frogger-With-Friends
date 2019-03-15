package  {
	
	public interface IFighter {
		function get Colour():String;
		function get Weakness():String;
		
		function get Fighting():Boolean;
		function set Fighting(value:Boolean):void;

		function Win():void;
		function Lose():void;
	}
	
}
