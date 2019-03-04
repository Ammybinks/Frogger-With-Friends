package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class GreenSnake extends Snake {

		public function GreenSnake(kernel:Kernel, gridPosition:Vector3D, playerFrog:PlayerFrog):void {
			super(kernel, gridPosition, playerFrog);
			
			colour = GREEN_COLOUR;
			weakness = RED_COLOUR;
		}
	}
	
}
