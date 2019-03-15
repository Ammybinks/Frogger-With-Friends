package  {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Fight extends MovieClip {
		// Reference to each object in the fight
		private var fighter1:IFighter;
		private var fighter2:IFighter;
		
		// Timer to indicate how long the fight should continue before resolving
		private var fightTimer: Timer = new Timer((1000 / 4) * 3);
		
		public function Fight(fighter1:IFighter, fighter2:IFighter, position:Vector3D, size:Vector3D) {
			this.fighter1 = fighter1;
			this.fighter2 = fighter2;
			
			width = size.x * 2.5;
			height = size.y * 2.5;
			x = position.x - width / 2;
			y = position.y - height / 2;
			
			fighter1.Fighting = true;
			fighter2.Fighting = true;
				
			fightTimer.addEventListener(TimerEvent.TIMER, Resolve);
			fightTimer.start();
		}
		
		// Resolve the fight, determining which (if any) fighter is the winner and calling their appropriate responses
		private function Resolve(e:TimerEvent)
		{
			// If both fighters are the same colour
			if(fighter1.Colour == fighter2.Colour)
			{
				// Both fighters lose
				fighter1.Lose();
				fighter2.Lose();
			}
			else
			{
				// If fighter 1 is weak to fighter 2
				if(fighter2.Colour == fighter1.Weakness)
				{
					// Fighter 1 loses and fighter 2 wins
					fighter1.Lose();
					fighter2.Win();
				}
				// If fighter 2 is weak to fighter 1
				else if(fighter1.Colour == fighter2.Weakness)
				{
					// Fighter 2 loses and fighter 1 wins
					fighter2.Lose();
					fighter1.Win();
				}
			}
			
			fighter1.Fighting = false;
			fighter2.Fighting = false;
			
			fightTimer.stop();
			
			stage.removeChild(this);
		}
	}
}
