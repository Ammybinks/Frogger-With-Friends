package  {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Fight {
		var fighter1:IFighter;
		var fighter2:IFighter;
		
		var fightTimer: Timer = new Timer(1000 / 2);
		
		public function Fight(fighter1:IFighter, fighter2:IFighter) {
			this.fighter1 = fighter1;
			this.fighter2 = fighter2;
			
			fighter1.StartFight();
			fighter2.StartFight();
			
			fightTimer.addEventListener(TimerEvent.TIMER, Resolve);
			fightTimer.start();
		}
		
		private function Resolve(e:TimerEvent)
		{
			if(fighter1.Colour == fighter2.Colour)
			{
				fighter1.Lose();
				fighter2.Lose();
			}
			else
			{
				if(fighter1.Colour == fighter2.Weakness)
				{
					fighter2.Lose();
				}
				else
				{
					fighter2.Win();
				}
				
				if(fighter2.Colour == fighter1.Weakness)
				{
					fighter1.Lose();
				}
				else
				{
					fighter1.Win();
				}

			}
			
			fighter1.StopFight();
			fighter2.StopFight();
			
			fightTimer.stop();
		}
	}
}
