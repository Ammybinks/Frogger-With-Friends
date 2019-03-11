package  {
	import flash.display.MovieClip;
	
	public class LevelObject extends MovieClip {
		var kernel:Kernel;

		public function LevelObject(kernel:Kernel) {
			this.kernel = kernel;
			
			kernel.addEventListener(GameEvent.END_GAME, OnEnd);
		}
		
		internal function OnStart(e:GameEvent):void
		{
			visible = true;
			
			kernel.removeEventListener(GameEvent.START_GAME, OnStart);
		}
		
		internal function OnEnd(e:GameEvent):void
		{
			visible = false;
			
			kernel.addEventListener(GameEvent.START_GAME, OnStart);
		}
	}
	
}
