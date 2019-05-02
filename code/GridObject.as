package  {
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class GridObject extends LevelObject {
		// The current position on the puzzle grid
		internal var gridPosition:Vector3D;
		public function get GridPosition():Vector3D { return gridPosition }
		public function set GridPosition(value:Vector3D):void { gridPosition = value }
		
		public function GridObject(scene:IGameScene, gridPosition:Vector3D) {
			super(scene);
			
			this.gridPosition = gridPosition;
			
			height = scene.TileSize;
			width = scene.TileSize;
			
			UpdatePosition();
		}

		// Locks the frog to its determined position on the grid
		internal function UpdatePosition():void
		{
			if(!scene.Solved)
			{
				x = (scene.TileSize * gridPosition.x) + (scene.TileSize / 2) + scene.StageBounds[0].x;
				y = (scene.TileSize * gridPosition.y) + (scene.TileSize / 2) + scene.StageBounds[0].y;
			}
		}
	}
	
}
