package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class BlueFrog extends Frog {
		public function BlueFrog(kernel:Kernel, gridPosition:Vector3D, next:Actor, lead:Actor):void {
			super(kernel, gridPosition, next, lead);
			
			colour = BLUE_COLOUR;
			weakness = GREEN_COLOUR;
		}
	}
	
}
