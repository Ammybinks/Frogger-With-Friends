package  {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Fight extends MovieClip {
		var fighter1:IFighter;
		var fighter2:IFighter;
		
		var fightTimer: Timer = new Timer((1000 / 4) * 3);
		
		public function Fight(fighter1:IFighter, fighter2:IFighter, position:Vector3D, size:Vector3D) {
			this.fighter1 = fighter1;
			this.fighter2 = fighter2;
			
			width = size.x * 2.5;
			height = size.y * 2.5;
			x = position.x - width / 2;
			y = position.y - height / 2;
			
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
			
			stage.removeChild(this);
		}
	}
}
