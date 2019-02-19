package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	
	public class Kernel extends MovieClip {
		var input:InputManager;
		
		// Stores a list of all objects that should be updated repeatedly
		var updateables:Array = new Array();
		
		var frog:MovieClip;

		// Size of the current puzzle, in an N x N grid
		var stageSize:int = 10;
		// Size of each respective tile, according to the current stageSize
		var tileSize:Number;
		// Upper left of the grid, after being centered
		var gridUL:Vector3D = new Vector3D(0, 0, 0);
		
		public function Kernel() {
			addEventListener(Event.ADDED_TO_STAGE, Loaded);
			addEventListener(Event.ENTER_FRAME, Update);
		}

		public function Loaded(e:Event) {
			// Initialise tile & grid values
			tileSize = stage.stageHeight / stageSize;
			gridUL.x = (stage.stageWidth - (tileSize * stageSize)) / 2;
			
			// Create Primary Player Token
			frog = new PlayerFrog(this);
			
			frog.x = stage.stageWidth / 2;
			frog.y = stage.stageHeight / 2;
			frog.height = tileSize;
			frog.width = tileSize;
			
			updateables.push(frog);
			stage.addChild(frog);
			
			// Create darker tiles on grid, for texture
			for(var col:int = 0; col < stageSize; col++)
			{
				for(var row:int = 0; row < stageSize; row++)
				{
					// For every other tile on the grid
					if((CheckEven(col) && CheckEven(row)) || (!CheckEven(col) && !CheckEven(row)))
					{
						CreateTile(col, row);
					}
				}
			}

			// Bring Primary Player Token to front of render queue
			stage.setChildIndex(frog, stage.numChildren - 1);
			
			input = new InputManager(this);
			
			removeEventListener(Event.ADDED_TO_STAGE, Loaded);
		}
		
		public function Update(e:Event) {
			input.Update();
			
			for(var i:int = 0; i < updateables.length; i++)
			{
				updateables[i].Update();
			}
		}
		
		// Returns whether the given number is even or not
		private function CheckEven(pN:int):Boolean
		{
			if(pN % 2 == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		// Creates a grey tile in a position according to its column and row on the grid
		private function CreateTile(pCol:int, pRow:int)
		{
			var tile:MovieClip = new TileGrey();
			
			tile.x = (pCol * tileSize) + (tileSize / 2);
			tile.x += gridUL.x;
			tile.y = (pRow * tileSize) + (tileSize / 2);
			tile.y += gridUL.y;
			tile.width = tileSize;
			tile.height = tileSize;
			
			stage.addChild(tile);
		}
	}
	
}
