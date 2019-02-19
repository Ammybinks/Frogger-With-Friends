package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	// Actor is a generic class that stores an objects position on the game grid, used for any entity that changes position over the course of the game
	public class Actor extends MovieClip {
		var gridPosition:Vector3D = new Vector3D(0, 0, 0);
	}
}