﻿package  {
	import flash.geom.Vector3D;
	import flash.events.Event;
	
	public class UpdateEvent extends Event {
		public static const UPDATE = "update";
		public static const BEGIN_TURN = "beginTurn";
		public static const PLAYER_TURN = "playerTurn";
		public static const ENEMY_COLLISIONS = "enemyCollisions";
		public static const ENEMY_TURN = "enemyTurn";
		
		public function UpdateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
	
}
