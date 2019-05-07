package  {
	
	public interface ISettingsScene extends IScene {
		function get Listening():KeyButton;
		
		function BeginListen(button:KeyButton):void;
	}
	
}
