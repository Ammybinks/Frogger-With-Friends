package  {
	import flash.display.MovieClip;
	
	// PlayerFrog is the unique class used by the primary player token, containing behaviour to move the frog according to input, rather than any other entities or paths
	public class PlayerFrog extends Actor {
		var kernel:Kernel;
		
		var physicsBody:PhysicsManager;
		
		var speed:Number = 1;

		public function PlayerFrog(pKernel:Kernel) {
			// Attatch reference to kernel
			kernel = pKernel;
			
			// Create new manager for physics interactions
			physicsBody = new PhysicsManager(this);
		}

		public function Update() {
			// Locks the frog to its' determined position on the grid
			////TODO: fix encapsulation here
			x = (kernel.tileSize * gridPosition.x) + (kernel.tileSize / 2) + kernel.gridUL.x;
			y = (kernel.tileSize * gridPosition.y) + (kernel.tileSize / 2) + kernel.gridUL.y;
			
			// Moves the frog along the grid
			////TODO: Limit frog to moving inside the grid
			////TODO: Only move the frog after a button press is completed, housed in InputManager
			if(kernel.input.left)
			{
				gridPosition.x -= 1;
			}
			if(kernel.input.right)
			{
				gridPosition.x += 1;
			}
			if(kernel.input.up)
			{
				gridPosition.y -= 1;
			}
			if(kernel.input.down)
			{
				gridPosition.y += 1;
			}
			
			/* Deprecated physics based movement
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
			*/
		}
	}
	
}
