package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	import flash.utils.getQualifiedClassName;

	public class Kernel extends MovieClip
	{
		var input: InputManager;

		// Size of the current puzzle, in an N x N grid
		var stageSize:int = 8;
		// Size of each respective tile, according to the current stageSize
		var tileSize:Number;
		// Upper left of the grid, after being centered
		var stageBounds:Vector.<Vector3D> = new Vector.<Vector3D>(2);
		var actors:Vector.<Vector.<IGridCollidable>>;
		
		var collidables:Vector.<IPhysicsCollidable> = new Vector.<IPhysicsCollidable>();

		var stars:Vector.<int>;
		
		var actorsText:TextField;
		var turnsText:TextField;
		var snakeText:TextField;
		var winText:TextField;
		
		var turnStep:int = -1;
		
		var snakeCount:int = 0;
		
		var solved:Boolean = false;
		var gameOver:Boolean = false;
		var gameComplete:Boolean = false;

		var goal:Goal;
		
		var turnCount:int;
		var movingCount:int;
		var previousMovingCount:int;
		
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
			stageBounds[0] = new Vector3D((stage.stageWidth - (tileSize * stageSize)) / 2, 0, 0);
			stageBounds[1] = new Vector3D(stageBounds[0].x + (tileSize * stageSize), stage.stageHeight, 0);

			// Create actors 2D array
			actors = new Vector.<Vector.<IGridCollidable>>(stageSize);

			// Initialise grid of possible actor positions
			for (var i: int = 0; i < stageSize; i++)
			{
				actors[i] = new Vector.<IGridCollidable>(stageSize);

				for (var o: int = 0; o < stageSize; o++)
				{
					actors[i][o] = null;
				}
			}

			CreateGrid();

			goal = new Goal(this, new Vector3D(4, 1, 0));

			stage.addChild(goal);
			
			CreateActors();

			// TODO: Clean up text initialization
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.color = 0x000000;
			format.font = "Verdana";
			format.align = "center";
			
			
			actorsText = new TextField();
			actorsText.type = "dynamic";
			actorsText.text = " ";
			actorsText.border = false;
			actorsText.selectable = false;
			actorsText.autoSize = TextFieldAutoSize.LEFT;
			actorsText.antiAliasType = AntiAliasType.ADVANCED;
			actorsText.embedFonts = true;

			actorsText.setTextFormat(format);
			addChild(actorsText);
			
			
			turnsText = new TextField();
			turnsText.type = "dynamic";
			turnsText.text = " ";
			turnsText.border = false;
			turnsText.selectable = false;
			turnsText.autoSize = TextFieldAutoSize.LEFT;
			turnsText.x = stage.stageWidth - 15;
			turnsText.antiAliasType = AntiAliasType.ADVANCED;
			turnsText.embedFonts = true;

			turnsText.setTextFormat(format);
			addChild(turnsText);
			
			
			snakeText = new TextField();
			snakeText.type = "dynamic";
			snakeText.text = " ";
			snakeText.border = false;
			snakeText.selectable = false;
			snakeText.autoSize = TextFieldAutoSize.LEFT;
			snakeText.x = stage.stageWidth - 15;
			snakeText.y += snakeText.height;
			snakeText.antiAliasType = AntiAliasType.ADVANCED;
			snakeText.embedFonts = true;

			snakeText.setTextFormat(format);
			addChild(snakeText);

			format.size = 32;
			
			winText = new TextField();
			winText.type = "dynamic";
			winText.text = "Congratulations!\n\n* * *\nYou won in 00 turns.\n\nPress 'R' to restart and try for a better score!";
			winText.border = false;
			winText.selectable = false;
			winText.autoSize = TextFieldAutoSize.LEFT;
			winText.antiAliasType = AntiAliasType.ADVANCED;
			winText.embedFonts = true;

			winText.setTextFormat(format);
			
			winText.x = (stage.stageWidth / 2) - (winText.width / 2);
			winText.y = (stage.stageHeight / 2) - (winText.height / 2);

			winText.visible = false;
			
			addChild(winText);
			
			stars = new <int>[3, 11, -1];
			/* Bring Primary Player Token to front of render queue
			stage.setChildIndex(nextFrog, stage.numChildren - 1);
			stage.setChildIndex(frogFollow, stage.numChildren - 2);*/

			removeEventListener(Event.ADDED_TO_STAGE, Loaded);
		}
		
		public function EndGame():void
		{
			gameComplete = true;
			
			var totalStars:String = "";
			
			for(var i:int = 0; i < stars.length; i++)
			{
				if(turnCount <= stars[i] || stars[i] == -1)
				{	
					for(var o:int = stars.length - i; o > 0; o--)
					{
						totalStars = "*  " + totalStars;
					}
					
					break;
				}
			}
			
			var textFormat:TextFormat = winText.getTextFormat();
			winText.text = "Congratulations!\n\n" + totalStars + "\nYou won in " + turnCount + " turns.\n\nPress 'R' to restart and try for a better score!";
			winText.setTextFormat(textFormat);
			
			winText.visible = true;
			
			if(hasEventListener(GameEvent.END_GAME))
			{
				dispatchEvent(new GameEvent(GameEvent.END_GAME));
			}
		}
		
		public function AddCollider(object:IPhysicsCollidable, collider:Function)
		{
			collidables.push(object);
			addEventListener(CollisionEvent.CHECK_COLLISION, collider);
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
			var playerFrog:Actor = new PlayerFrog(this, new Vector3D(3, 3, 0), Actor.GREEN_COLOUR);

			playerFrog.rotation = 180;
			
			stage.addChild(playerFrog);
			
			playerFrog.addEventListener(StateEvent.ACTOR_DIED, FrogDied);
			playerFrog.addEventListener(UpdateEvent.PLAYER_TURN, StartTurn);
			
			var nextFrog:Actor = playerFrog;

			// Blue Frog
			var frogFollow:Actor = new Frog(this, new Vector3D(3, 4, 0), Actor.BLUE_COLOUR, nextFrog as INext, playerFrog);
			
			stage.addChild(frogFollow);

			frogFollow.addEventListener(StateEvent.ACTOR_DIED, FrogDied);
			
			nextFrog = frogFollow;

			// Red Frog
			frogFollow = new Frog(this, new Vector3D(3, 5, 0), Actor.RED_COLOUR, nextFrog as INext, playerFrog);

			stage.addChild(frogFollow);
			
			frogFollow.addEventListener(StateEvent.ACTOR_DIED, FrogDied);

			//////
			// Snakes
			//////
			
			// Red Snake
			var snake = new Snake(this, new Vector3D(7, 3, 0), Actor.RED_COLOUR, playerFrog as IEventListener);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(0, 3);
			snake.path[1] = new Vector3D(7, 3);

			stage.addChild(snake);
			
			snake.addEventListener(StateEvent.ACTOR_DIED, SnakeDied);
			
			// Green Snake
			snake = new Snake(this, new Vector3D(0, 3, 0), Actor.GREEN_COLOUR, playerFrog as IEventListener);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(7, 3);
			snake.path[1] = new Vector3D(0, 3);

			stage.addChild(snake);
			
			snake.addEventListener(StateEvent.ACTOR_DIED, SnakeDied);
			
			// Blue Snake
			snake = new Snake(this, new Vector3D(1, 4, 0), Actor.BLUE_COLOUR, playerFrog as IEventListener);

			snake.path = new Vector.<Vector3D>(2);
			snake.path[0] = new Vector3D(7, 4);
			snake.path[1] = new Vector3D(0, 4);

			stage.addChild(snake);
			
			snake.addEventListener(StateEvent.ACTOR_DIED, SnakeDied);
		}

		public function Update(e: TimerEvent): void
		{
			if(!gameComplete && !gameOver)
			{
				if(solved)
				{
					if (hasEventListener(CollisionEvent.CHECK_COLLISION))
					{
						dispatchEvent(new CollisionEvent(CollisionEvent.CHECK_COLLISION, collidables));
					}
				}
				
				if (hasEventListener(UpdateEvent.UPDATE))
				{
					dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE));
				}
			}
			
			if(turnStep > 0)
			{
				if(movingCount == 0 && movingCount != previousMovingCount || movingCount < 0)
				{
					if(turnStep == 1)
					{
						if(hasEventListener(UpdateEvent.ENEMY_COLLISIONS))
						{
							dispatchEvent(new UpdateEvent(UpdateEvent.ENEMY_COLLISIONS));
						}
						if(hasEventListener(UpdateEvent.ENEMY_TURN))
						{
							dispatchEvent(new UpdateEvent(UpdateEvent.ENEMY_TURN));
						}
						
						turnStep++;
					}
					else if(turnStep == 2)
					{
						if(hasEventListener(UpdateEvent.BEGIN_TURN))
						{
							dispatchEvent(new UpdateEvent(UpdateEvent.BEGIN_TURN));
						}
						
						turnCount++;
						turnStep = 0;
					}
					
				}
					
				previousMovingCount = movingCount;
			}
			
			if(turnCount > 0)
			{
				if (input.undoTapped && !gameComplete)
				{
					UndoSetup();
					
					if (hasEventListener(UndoEvent.UNDO))
					{
						dispatchEvent(new UndoEvent(UndoEvent.UNDO));
					}
					
					turnCount--;
				}
				else if (input.restartTapped)
				{
					UndoSetup();
					
					if (hasEventListener(UndoEvent.RESTART))
					{
						dispatchEvent(new UndoEvent(UndoEvent.RESTART));
					}
					
					turnCount = 0;
					
					if(gameComplete)
					{
						gameComplete = false;
						
						if(hasEventListener(GameEvent.START_GAME))
						{
							winText.visible = false;
							
							dispatchEvent(new GameEvent(GameEvent.START_GAME));
						}
					}
					
				}
			}
			
			var textFormat:TextFormat = turnsText.getTextFormat();
			turnsText.text = turnCount.toString();
			turnsText.setTextFormat(textFormat);
			
			textFormat = snakeText.getTextFormat();
			snakeText.text = snakeCount.toString();
			snakeText.setTextFormat(textFormat);
			
			WriteDebug();
			
			input.Update();
		}
		
		private function StartTurn(e:UpdateEvent):void
		{
			turnStep++;
		}
		
		private function UndoSetup():void
		{
			if(gameOver)
			{
				gameOver = false;
			}
			if(solved)
			{
				solved = false;
			}
			
			// Create actors 2D array
			actors = new Vector.<Vector.<IGridCollidable>>(stageSize);

			// Initialise grid of possible actor positions
			for (var i: int = 0; i < stageSize; i++)
			{
				actors[i] = new Vector.<IGridCollidable>(stageSize);

				for (var o: int = 0; o < stageSize; o++)
				{
					actors[i][o] = null;
				}
			}
		}
		
		public function MoveActor(oldPosition: Vector3D, newPosition: Vector3D):void
		{
			var actor:IGridCollidable = actors[oldPosition.x][oldPosition.y];

			actors[oldPosition.x][oldPosition.y] = null;
			actors[newPosition.x][newPosition.y] = actor;
		}
		
		public function AbsoluteMoveActor(oldPosition:Vector3D, newPosition:Vector3D, actor:Actor):void
		{
				actors[oldPosition.x][oldPosition.y] = null;
				actors[newPosition.x][newPosition.y] = actor;
		}
		
		private function FrogDied(e:StateEvent):void
		{
			gameOver = true;
		}

		private function SnakeDied(e:StateEvent):void
		{
			snakeCount--;
			
			if(snakeCount == 0)
			{
				solved = true;
				
				if (hasEventListener(StateEvent.PUZZLE_SOLVED))
				{
					dispatchEvent(new StateEvent(StateEvent.PUZZLE_SOLVED));
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
					var tempChars:String = "";
					
					if(actors[o][i] != null)
					{
						//tempChars += actors[o][i].Colour.charAt();
						tempChars += actors[o][i].ActorType.charAt();
						tempChars = tempChars.toUpperCase();
					}
					else
					{
						tempChars = "_";
					}
					
					tempString = tempString.concat("[",  tempChars, "]");
				}
				
				tempString += "\n";
			}

			var textFormat:TextFormat = actorsText.getTextFormat();
			actorsText.text = tempString;
			actorsText.setTextFormat(textFormat);
		}

		public function AddSnake():void
		{
			snakeCount++;
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
			var tile: MovieClip = new TileGrey(this);

			tile.x = (pCol * tileSize) + (tileSize / 2);
			tile.x += stageBounds[0].x;
			tile.y = (pRow * tileSize) + (tileSize / 2);
			tile.y += stageBounds[0].y;
			tile.width = tileSize;
			tile.height = tileSize;

			stage.addChild(tile);
		}
	}

}