package  {
	import flash.events.Event;
	
	public class KeyButton extends Button {
		// Stores a reference to the scene that created this button
		private var scene:ISettingsScene;
		
		// Stores any text the button stored before it switched frames
		public var oldText:String;
		
		// Reference to the function based setter for the key code this button is associated with
		// This method will be called once a replacement code has been entered, overwriting the old code in the input manager
		public var setTarget:Function;
		
		public function KeyButton(x:int, y:int, text:String, setTarget:Function, scene:ISettingsScene) {
			super(x, y);
			
			this.bText.text = text;

			this.setTarget = setTarget;
			
			this.scene = scene;
		}

		public override function Activate(e:Event)
		{
			// If there isn't currently a button waiting for an input
			if(scene.Listening == null)
			{
				oldText = this.bText.text;
				
				// Switch to the second button type
				gotoAndStop(2);
				this.bText.text = "Press any key:";
				
				// Start the scene listening for inputs to change the key code
				scene.BeginListen(this);
			}
		}
		
		public function Deactivate(newText:String)
		{
			// Return to the original button style
			gotoAndStop(1);
			this.bText.text = newText;
		}
	}
	
}
