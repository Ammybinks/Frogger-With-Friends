﻿package  {
	import flash.display.MovieClip;
	
	public class LevelObject extends MovieClip {
		internal var scene:IGameScene;

		public function LevelObject(scene:IGameScene) {
			this.scene = scene;
			
			scene.addEventListener(GameEvent.END_GAME, OnEnd);
		}
		
		// When the game starts after ending, add the object back to the stage
		internal function OnStart(e:GameEvent):void
		{
			visible = true;
			
			scene.removeEventListener(GameEvent.START_GAME, OnStart);
		}
		
		// When the game ends, temporarily remove the object from the stage
		internal function OnEnd(e:GameEvent):void
		{
			visible = false;
			
			scene.addEventListener(GameEvent.START_GAME, OnStart);
		}
	}
	
}
