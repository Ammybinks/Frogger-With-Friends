package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class BlueSnake extends Snake {

		public function BlueSnake(kernel:Kernel, gridPosition:Vector3D, playerFrog:IEventListener):void {
			super(kernel, gridPosition, playerFrog);
			
			colour = BLUE_COLOUR;
			weakness = GREEN_COLOUR;
		}
	}
	
}
