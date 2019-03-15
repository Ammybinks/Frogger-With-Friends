package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class GridObject extends LevelObject {
		// The current position on the puzzle grid
		internal var gridPosition:Vector3D;
		public function get GridPosition():Vector3D { return gridPosition }
		public function set GridPosition(value:Vector3D):void { gridPosition = value }
		
		public function GridObject(kernel:Kernel, gridPosition:Vector3D) {
			super(kernel);
			
			this.gridPosition = gridPosition;
			
			height = kernel.TileSize;
			width = kernel.TileSize;
			
			UpdatePosition();
		}

		// Locks the frog to its determined position on the grid
		internal function UpdatePosition():void
		{
			if(!kernel.Solved)
			{
				x = (kernel.TileSize * gridPosition.x) + (kernel.TileSize / 2) + kernel.StageBounds[0].x;
				y = (kernel.TileSize * gridPosition.y) + (kernel.TileSize / 2) + kernel.StageBounds[0].y;
			}
		}
	}
	
}
