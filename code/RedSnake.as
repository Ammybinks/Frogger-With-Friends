package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class RedSnake extends Snake {

		public function RedSnake(kernel:Kernel, gridPosition:Vector3D, playerFrog:PlayerFrog):void {
			super(kernel, gridPosition, playerFrog);
			
			colour = RED_COLOUR;
			weakness = BLUE_COLOUR;
		}
	}
	
}
