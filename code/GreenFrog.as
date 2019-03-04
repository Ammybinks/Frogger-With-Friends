package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class GreenFrog extends Frog {
		public function GreenFrog(kernel:Kernel, gridPosition:Vector3D, next:Actor, lead:Actor):void {
			super(kernel, gridPosition, next, lead);
			
			colour = GREEN_COLOUR;
			weakness = RED_COLOUR;
		}
	}
	
}
