package  {
	import flash.display.MovieClip;
	
	public class PlayerFrog extends MovieClip {
		var kernel:MovieClip;
		
		var physicsBody:PhysicsManager;
		
		var speed:Number = 5;

		public function PlayerFrog(pKernel:MovieClip) {
			kernel = pKernel;
			
			physicsBody = new PhysicsManager(this);
		}

		public function Update() {
			physicsBody.Update();
			
			if(kernel.input.left)
			{
				physicsBody.AddSpeed(-speed, 0);
			}
			if(kernel.input.right)
			{
				physicsBody.AddSpeed(speed, 0);
			}
			if(kernel.input.up)
			{
				physicsBody.AddSpeed(0, -speed);
			}
			if(kernel.input.down)
			{
				physicsBody.AddSpeed(0, speed);
			}
		}
	}
	
}
