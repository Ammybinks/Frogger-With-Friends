package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class RedFrog extends Frog {
		public function RedFrog(kernel:Kernel, gridPosition:Vector3D, next:Actor, lead:Actor):void {
			super(kernel, gridPosition, next, lead);
			
			colour = RED_COLOUR;
			weakness = BLUE_COLOUR;
		}
	}
	
}
