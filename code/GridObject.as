package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class GridObject extends LevelObject {
		internal var gridPosition:Vector3D;
		public function get GridPosition():Vector3D { return gridPosition }
		public function set GridPosition(value:Vector3D):void { gridPosition = value }
		
		public function GridObject(kernel:Kernel, gridPosition:Vector3D) {
			super(kernel);
			
			this.gridPosition = gridPosition;
			
			height = kernel.tileSize;
			width = kernel.tileSize;
			
			UpdatePosition(null);
		}

		// Locks the frog to its' determined position on the grid
		internal function UpdatePosition(e:UpdateEvent):void
		{
			if(!kernel.solved)
			{
				x = (kernel.tileSize * gridPosition.x) + (kernel.tileSize / 2) + kernel.stageBounds[0].x;
				y = (kernel.tileSize * gridPosition.y) + (kernel.tileSize / 2) + kernel.stageBounds[0].y;
			}
		}
	}
	
}
