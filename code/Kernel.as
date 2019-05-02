package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;

	public class Kernel extends MovieClip
	{
		private var sceneManager:SceneManager;
		
		public function Kernel(): void
		{
			sceneManager = new SceneManager(stage);
			
			// Initialise timer used to determine when Update should be run
			var updateTimer: Timer = new Timer(1000 / 60);
			updateTimer.addEventListener(TimerEvent.TIMER, Update);
			updateTimer.start();
		}
		
		private function Update(e:TimerEvent):void
		{
			sceneManager.Update();
		}
	}
}