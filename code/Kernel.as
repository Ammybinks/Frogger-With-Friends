package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;

	public class Kernel extends MovieClip
	{
		var input: InputManager;

		// Size of the current puzzle, in an N x N grid
		var stageSize:int = 8;
		// Size of each respective tile, according to the current stageSize
		var tileSize:Number;
		// Upper left of the grid, after being centered
		var gridUL:Vector3D = new Vector3D(0, 0, 0);
		var actors:Vector.<Vector.<Actor>>;

		var actorsText:TextField;
		var turnsText:TextField;
		
		var turnsTaken:int = -1;
		var gameOver:Boolean = false;
		
		var snakeCount:int = 0;
		
		var solved:Boolean = false;
		
		public function Kernel(): void
		{
			addEventListener(Event.ADDED_TO_STAGE, Loaded);

			var updateTimer: Timer = new Timer(1000 / 60);
			updateTimer.addEventListener(TimerEvent.TIMER, Update);
			updateTimer.start();
		}

		public function Loaded(e: Event): void
		{
			input = new InputManager(this);

			// Initialise tile & grid values
			tileSize = stage.stageHeight / stageSize;
			gridUL.x = (stage.stageWidth - (tileSize * stageSize)) / 2;

			// Create actors 2D array
			actors = new Vector.<Vector.<Actor>>(stageSize);

			// Initialise grid of possible actor positions
			for (var i: int = 0; i < stageSize; i++)
			{
				actors[i] = new Vector.<Actor>(stageSize);

				for (var o: int = 0; o < stageSize; o++)
				{
					actors[i][o] = null;
				}
			}

			CreateGrid();

			CreateActors();

			// TODO: Clean up text initialization
			actorsText = new TextField();
			actorsText.type = "dynamic";
			actorsText.text = "Welcome to the Ball Game";
			actorsText.border = false;
			actorsText.selectable = false;
			actorsText.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.color = 0x000000;
			format.font = "Verdana";
			format.align = "left";
			actorsText.antiAliasType = AntiAliasType.ADVANCED;
			actorsText.embedFonts = true;

			actorsText.setTextFormat(format);
			addChild(actorsText);
			
			
			turnsText = new TextField();
			turnsText.type = "dynamic";
			turnsText.text = "Welcome to the Ball Game";
			turnsText.border = false;
			turnsText.selectable = false;
			turnsText.autoSize = TextFieldAutoSize.LEFT;
			turnsText.x = stage.stageWidth - turnsText.width / 2;
			turnsText.antiAliasType = AntiAliasType.ADVANCED;
			turnsText.embedFonts = true;

			turnsText.setTextFormat(format);
			addChild(turnsText);
			
			
			/* Bring Primary Player Token to front of render queue
			stage.setChildIndex(nextFrog, stage.numChildren - 1);
			stage.setChildIndex(frogFollow, stage.numChildren - 2);*/

			removeEventListener(Event.ADDED_TO_STAGE, Loaded);
		}
		
		private function CountTurn(e:UpdateEvent):void
		{
			turnsTaken++;
		}

		private function CreateGrid(): void
		{
			// Create darker tiles on grid, for texture
			for (var col: int = 0; col < stageSize; col++)
			{
				for (var row: int = 0; row < stageSize; row++)
				{
					// For every other tile on the grid
					if ((CheckEven(col) && CheckEven(row)) || (!CheckEven(col) && !CheckEven(row)))
					{
						CreateTile(col, row);
					}
				}
			}
		}

		private function CreateActors(): void
		{
			//////
			// Frogs
			//////
			
			//// Player Frog
			var playerFrog: PlayerFrog = new PlayerFrog(this, new Vector3D(3, 3, 0));

			AddActor(playerFrog);
			stage.addChild(playerFrog);
			
			var nextFrog: Actor = playerFrog;

			// Blue Frog
			var frogFollow: Frog = new BlueFrog(this, new Vector3D(3, 4, 0), nextFrog, playerFrog);

			AddActor(frogFollow);
			stage.addChild(frogFollow);

			nextFrog = frogFollow;

			// Red Frog
			frogFollow = new RedFrog(this, new Vector3D(3, 5, 0), nextFrog, playerFrog);

			AddActor(frogFollow);
			stage.addChild(frogFollow);

			nextFrog = frogFollow;
/*
			// Blue Frog
			frogFollow = new BlueFrog(this, new Vector3D(6, 8, 0), nextFrog, playerFrog);

			AddActor(frogFollow);
			stage.addChild(frogFollow);

			nextFrog = frogFollow;

			// Green Frog
			frogFollow = new GreenFrog(this, new Vector3D(6, 9, 0), nextFrog, playerFrog);

			AddActor(frogFollow);
			stage.addChild(frogFollow);

			nextFrog = frogFollow;

			// Red Frog
			frogFollow = new RedFrog(this, new Vector3D(5, 9, 0), nextFrog, playerFrog);

			AddActor(frogFollow);
			stage.addChild(frogFollow);
*/
			//////
			// Snakes
			//////
			
			// Red Snake
			var snake = new RedSnake(this, new Vector3D(7, 3, 0), playerFrog);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(0, 3);
			snake.path[1] = new Vector3D(7, 3);

			actors[snake.gridPosition.x][snake.gridPosition.y] = snake;
			stage.addChild(snake);

			snakeCount++;
			
			/* Red Snake
			snake = new RedSnake(this, new Vector3D(9, 4, 0), playerFrog);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(0, 4);
			snake.path[1] = new Vector3D(9, 4);

			actors[snake.gridPosition.x][snake.gridPosition.y] = snake;
			stage.addChild(snake);
			*/
			
			// Green Snake
			snake = new GreenSnake(this, new Vector3D(0, 3, 0), playerFrog);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(7, 3);
			snake.path[1] = new Vector3D(0, 3);

			actors[snake.gridPosition.x][snake.gridPosition.y] = snake;
			stage.addChild(snake);
			
			snakeCount++;
			
			/* Green Snake
			snake = new GreenSnake(this, new Vector3D(1, 8, 0), playerFrog);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(8, 8);
			snake.path[1] = new Vector3D(1, 8);

			actors[snake.gridPosition.x][snake.gridPosition.y] = snake;
			stage.addChild(snake);
			*/
			
			// Blue Snake
			snake = new BlueSnake(this, new Vector3D(1, 4, 0), playerFrog);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(7, 4);
			snake.path[1] = new Vector3D(0, 4);

			actors[snake.gridPosition.x][snake.gridPosition.y] = snake;
			stage.addChild(snake);
			
			snakeCount++;
			
			/* Blue Snake
			snake = new BlueSnake(this, new Vector3D(1, 7, 0), playerFrog);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(9, 7);
			snake.path[1] = new Vector3D(1, 7);

			actors[snake.gridPosition.x][snake.gridPosition.y] = snake;
			stage.addChild(snake);
			*/
			
			playerFrog.addEventListener(UpdateEvent.PLAYER_TURN, CountTurn);
		}

		public function Update(e: TimerEvent): void
		{
			if(!gameOver)
			{
				if (hasEventListener(UpdateEvent.UPDATE))
				{
					dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE));
				}
			}
			
			if((input.undoTapped || input.restartTapped) && turnsTaken > 0)
			{
				// Create actors 2D array
				actors = new Vector.<Vector.<Actor>>(stageSize);

				// Initialise grid of possible actor positions
				for (var i: int = 0; i < stageSize; i++)
				{
					actors[i] = new Vector.<Actor>(stageSize);

					for (var o: int = 0; o < stageSize; o++)
					{
						actors[i][o] = null;
					}
				}

				if (input.undoTapped)
				{
					if (hasEventListener(UndoEvent.UNDO))
					{
						dispatchEvent(new UndoEvent(UndoEvent.UNDO));
					}
					
					turnsTaken--;
				}
				else if (input.restartTapped)
				{
					if (hasEventListener(UndoEvent.RESTART))
					{
						dispatchEvent(new UndoEvent(UndoEvent.RESTART));
					}
					
					turnsTaken = 0;
				}
				
				if(gameOver)
				{
					gameOver = false;
				}
				if(solved)
				{
					solved = false;
				}
			}
			
			var textFormat:TextFormat = turnsText.getTextFormat();
			turnsText.text = turnsTaken.toString();
			turnsText.setTextFormat(textFormat);
			
			WriteDebug();
			
			input.Update();
		}

		public function MoveActor(oldPosition: Vector3D, newPosition: Vector3D):Actor
		{
			if (actors[oldPosition.x][oldPosition.y] != null && actors[newPosition.x][newPosition.y] == null)
			{
				var actor: Actor = actors[oldPosition.x][oldPosition.y];

				actors[oldPosition.x][oldPosition.y] = null;
				actors[newPosition.x][newPosition.y] = actor;

				return null;
			}
			else
			{
				return actors[newPosition.x][newPosition.y];
			}
		}
		
		public function AbsoluteMoveActor(oldPosition:Vector3D, newPosition:Vector3D, actor:Actor):void
		{
				actors[oldPosition.x][oldPosition.y] = null;
				actors[newPosition.x][newPosition.y] = actor;
		}
		
		public function RemoveActor(actor:Actor, position:Vector3D):void
		{
			actors[position.x][position.y] = null;

			if(actor.actorType == Actor.FROG_TYPE)
			{
				gameOver = true;
			}
			else if(actor.actorType == Actor.SNAKE_TYPE)
			{
				snakeCount--;
				
				if(snakeCount == 0)
				{
					solved = true;
				}
			}
		}
		
		// Writes any needed diagnostic information to the screen for debugging purposes
		private function WriteDebug():void
		{
			var tempString:String = "";
			
			for (var i: int = 0; i < actors.length; i++)
			{
				for (var o: int = 0; o < actors.length; o++)
				{
					var tempArray:Array = getQualifiedClassName(actors[o][i]).match(/[A-Z]/g);
					var tempChars:String = "";
					
					if(tempArray.length != 0)
					{
						for(var p:int = 0; p < tempArray.length; p++)
						{
							tempChars += tempArray[p];
						}
					}
					else
					{
						tempChars = "__";
					}
					
					tempString = tempString.concat("[",  tempChars, "]");
				}
				
				tempString += "\n";
			}

			var textFormat:TextFormat = actorsText.getTextFormat();
			actorsText.text = tempString;
			actorsText.setTextFormat(textFormat);
		}

		public function AddActor(actor: Actor): void
		{
			actors[actor.gridPosition.x][actor.gridPosition.y] = actor;
		}

		// Returns whether the given number is even or not
		private function CheckEven(pN: int): Boolean
		{
			if (pN % 2 == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		// Creates a grey tile in a position according to its column and row on the grid
		private function CreateTile(pCol: int, pRow: int): void
		{
			var tile: MovieClip = new TileGrey();

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