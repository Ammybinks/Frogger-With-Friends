package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.geom.Vector3D;
	
	public class GameScene extends Scene implements IGameScene {
		// The scene this one is linked to, and switch to after StarScene
		internal var link:IScene;
		
		// List of objects to update every frame
		internal var updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
		
		// List of objects to check collisions between on update
		internal var collidables:Vector.<IPhysicsCollidable> = new Vector.<IPhysicsCollidable>();
		public function get Collidables():Vector.<IPhysicsCollidable> { return collidables; }

		// Size of the current puzzle, in an N x N grid
		internal var stageSize:int;
		public function get StageSize():int { return stageSize; }
		
		// Size of each respective tile, according to the current stageSize
		internal var tileSize:Number;
		public function get TileSize():Number { return tileSize; }
		
		// Upper left and lower right points of the stage, for determining positioning and collisions
		internal var stageBounds:Vector.<Vector3D> = new Vector.<Vector3D>(2);
		public function get StageBounds():Vector.<Vector3D> { return stageBounds; }
		
		// Two dimensional array which stores the positions of each actor on a grid
		internal var actors:Vector.<Vector.<IGridCollidable>>;
		public function get Actors():Vector.<Vector.<IGridCollidable>> { return actors; }
		
		// TextFields for writing a variety of information to the screen
		internal var reminderText:TextField;
		internal var actorsText:TextField;
		internal var turnsText:TextField;
		internal var snakeText:TextField;
		

		// How many actors are currently moving
		internal var movingCount:int;
		public function get MovingCount():int { return movingCount; }
		public function set MovingCount(value:int):void { movingCount = value; }
		
		internal var previousMovingCount:int;
		
		// Which step in the turn sequence the game is currently on
		internal var turnStep:int = -1;
		
		// Number of snakes that need to be defeated before the puzzle is counted as solved
		internal var snakeCount:int = 0;
		
		// How many turns the player has taken to reach the current point in the solution
		internal var turnCount:int;
		
		// List of breakpoints of turns required to reach a certain amount of stars at the end of the puzzle
		internal var stars:Vector.<int>;
		
		// Game State values which determine what general behaviours should be enacted at any given time
		internal var solved:Boolean = false;
		public function get Solved():Boolean { return solved; }
		internal var gameOver:Boolean = false;
		public function get GameOver():Boolean { return gameOver; }
		internal var gameComplete:Boolean = false;
		public function get GameComplete():Boolean { return gameComplete; }

		// Reference to the goal object in the stage
		internal var goal:Goal;
		
		public function GameScene(input:InputManager)
		{
			super(input);
		}

		// Initialise all values and objects to be added to the screen
		public override function Initialise(stage:Object):void
		{
			// Return the program's focus to the stage, if it wasn't there already.
			// Solves problems with inputs not registering after a button has been pressed
			stage.focus = stage;
		}

		// Place every entity on the stage
		public override function LoadContent(stage:Object):void
		{
			CreateGrid(stage);
			
			CreateActorGrid();
			
			CreateGoal(stage);
			
			CreateActors(stage);
			
			CreateWalls(stage);

			CreateText(stage);
			
			CreateButtons(stage);
			
			// Iterate over every entity in the scene, adding it to the stage and any other lists if necessary
			for (var i:int = 0; i < entities.length; i++)
			{
				if(entities[i] is IUpdatable)
				{
					updatables.push(entities[i]);
				}
				if(entities[i] is IPhysicsCollidable)
				{
					collidables.push(entities[i]);
				}
				
				stage.addChild(entities[i]);
			}
		}
		
		// Removes every entity from the stage to prepare for the next scene to load
		public override function UnloadContent(stage:Object):IScene
		{
			unloading = true;

			Next.Entities = entities;
			
			for(var i:int = 0; i < entities.length; i++)
			{
				stage.removeChild(entities[i]);
			}
			
			entities.length = 0;
			updatables.length = 0;
			collidables.length = 0;
			
			return next;
		}
		
		public override function Update(): void
		{
			// If puzzle has been solved
			if(solved)
			{
				// Check collisions for each actor before updating them
				for(var i:int = 0; i < collidables.length; i++)
				{
					collidables[i].Collider.CheckCollision(collidables);
				}
			}
			
			for(i = 0; i < updatables.length; i++)
			{
				updatables[i].Update();
			}
			
			// If the game is currently moving through the turn sequence
			/// turnStep is first increased by PlayerFrog moving, and is subsequently incremented each time there are no actors moving, triggering the next set of turns in the sequence (Player->Party->Enemies->Player)
			if(turnStep > 0)
			{
				// If the number of moving actors reduced to 0
				if(movingCount == 0 && movingCount != previousMovingCount || movingCount < 0)
				{
					// Enemy turn
					if(turnStep == 1)
					{
						if(hasEventListener(TurnEvent.ENEMY_COLLISIONS))
						{
							dispatchEvent(new TurnEvent(TurnEvent.ENEMY_COLLISIONS));
						}
						if(hasEventListener(TurnEvent.ENEMY_TURN))
						{
							dispatchEvent(new TurnEvent(TurnEvent.ENEMY_TURN));
						}
						
						turnStep++;
					}
					// Return to standing position, waiting for player input
					else if(turnStep == 2)
					{
						if(hasEventListener(TurnEvent.BEGIN_TURN))
						{
							dispatchEvent(new TurnEvent(TurnEvent.BEGIN_TURN));
						}
						
						turnCount++;
						turnStep = 0;
					}
					
				}
					
				previousMovingCount = movingCount;
			}
			// While turnStep is 0, the game is waiting for player input and no other actions are currently being taken
			else if(turnCount > 0)
			{
				if (input.UndoTapped && !gameComplete)
				{
					UndoSetup();
					
					if (hasEventListener(UndoEvent.UNDO))
					{
						dispatchEvent(new UndoEvent(UndoEvent.UNDO));
					}
					
					turnCount--;
				}
				else if (input.RestartTapped)
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
							dispatchEvent(new GameEvent(GameEvent.START_GAME));
						}
					}
					
				}
			}
			
			/* Update diagnostic information
			var textFormat:TextFormat = turnsText.getTextFormat();
			turnsText.text = turnCount.toString();
			turnsText.setTextFormat(textFormat);
			
			textFormat = snakeText.getTextFormat();
			snakeText.text = snakeCount.toString();
			snakeText.setTextFormat(textFormat);
			
			WriteDebug();*/
		}

		// Draws the level's grid, according to stageSize
		internal function CreateGrid(stage:Object): void
		{
			for (var col: int = 0; col < stageSize; col++)
			{
				for (var row: int = 0; row < stageSize; row++)
				{
					// For every other tile on the grid
					if ((col % 2 == 0 && row % 2 == 0) || (col % 2 != 0 && row % 2 != 0))
					{
						// Create a dark tile
						CreateTile(stage, col, row);
					}
				}
			}
		}

		// Creates a grey tile in a position according to its column and row on the grid
		internal function CreateTile(stage:Object, pCol: int, pRow: int): void
		{
			var tile:MovieClip = new TileGrey();

			tile.x = (pCol * tileSize) + (tileSize / 2);
			tile.x += stageBounds[0].x;
			tile.y = (pRow * tileSize) + (tileSize / 2);
			tile.y += stageBounds[0].y;
			tile.width = tileSize;
			tile.height = tileSize;

			entities.push(tile);
		}
		
		// Creates a new two dimensional array and places it inside actors, run for the first time when the program starts and whenever undo is used to reset the grid
		internal function CreateActorGrid():void
		{
			actors = new Vector.<Vector.<IGridCollidable>>(stageSize);

			for (var i: int = 0; i < stageSize; i++)
			{
				actors[i] = new Vector.<IGridCollidable>(stageSize);

				for (var o: int = 0; o < stageSize; o++)
				{
					actors[i][o] = null;
				}
			}
		}

		// Places the goal on the stage in a certain position
		internal function CreateGoal(stage:Object):void
		{
		}
		
		// Initialises each moving actor and places them on the stage
		internal function CreateActors(stage:Object): void
		{
		}
		
		// Creates all the walls for the level, including individiual walls for grid collisions and wall segments for physics collisions
		internal function CreateWalls(stage:Object): void
		{

		}

		// Initialises all TextFields needed to print information to the screen
		internal function CreateText(stage:Object):void
		{
			var format:TextFormat = new TextFormat();
			format.size = 16;
			format.color = 0x000000;
			format.font = "Verdana";
			format.align = "center";
			
			reminderText = new TextField();
			reminderText.type = "dynamic";
			reminderText.text = "Welcome to Frogger With Friends!\n\nThe goal of the game is to\n defeat every enemy before \nmoving to the exit.\n\nWhenever a snake and a frog\n collide, they fight!\n\nThe winner is determined\nby their colours:\n\nGreen beats Blue\nBlue beats Red\nRed beats Green\n\nBoth fighters die on a tie,\nand if any of your party die\nyou have to restart!";
			reminderText.border = false;
			reminderText.selectable = false;
			reminderText.autoSize = TextFieldAutoSize.LEFT;
			reminderText.antiAliasType = AntiAliasType.ADVANCED;
			reminderText.embedFonts = true;

			reminderText.setTextFormat(format);
			entities.push(reminderText);
			
			
			actorsText = new TextField();
			actorsText.type = "dynamic";
			actorsText.text = " ";
			actorsText.border = false;
			actorsText.selectable = false;
			actorsText.autoSize = TextFieldAutoSize.LEFT;
			actorsText.antiAliasType = AntiAliasType.ADVANCED;
			actorsText.embedFonts = true;

			actorsText.setTextFormat(format);
			entities.push(actorsText);
			
			
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
			entities.push(turnsText);
			
			
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
			entities.push(snakeText);

			format.size = 32;
			
		
		}
		
		// Creates and places all buttons on the stage
		internal function CreateButtons(stage:Object):void
		{
			var levelThreeButton:SceneButton = new SceneButton(0, 0, "Exit", new StartMenuScene(input));
			levelThreeButton.x = 100;
			levelThreeButton.y = stage.stageHeight - 40;
			levelThreeButton.addEventListener(SceneChangeEvent.SCENE_CHANGE, ChangeScene);
			entities.push(levelThreeButton);
		}
		
		// Removes the given actor from the grid and places them at newPosition on the actors grid
		public function AbsoluteMoveActor(actor:Actor, newPosition:Vector3D):void
		{
			actors[actor.gridPosition.x][actor.gridPosition.y] = null;
			actors[newPosition.x][newPosition.y] = actor;
		}
		
		// Begins the turn sequence
		internal function StartTurn(e:TurnEvent):void
		{
			turnStep++;
		}
		
		// Ends the game
		public function FrogDied():void
		{
			gameOver = true;
		}

		// Increases snakeCount by 1, adding a snake to the puzzle
		public function AddSnake():void
		{
			snakeCount++;
		}
		
		// Reduces snakeCount by one and counts the puzzle as solved when there are no snakes left
		public function SnakeDied():void
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
		
		// Ends the game, hiding the stage and calculating the amount of stars to award the player
		public function EndGame():void
		{
			gameComplete = true;
			
			var starCount:int = 0;
			
			// Adds a star to the final string for each breakpoint in stars[] reached
			for(var i:int = 0; i < stars.length; i++)
			{
				if(turnCount <= stars[i] || stars[i] == -1)
				{	
					for(var o:int = stars.length - i; o > 0; o--)
					{
						starCount++;
					}
					
					break;
				}
			}
				
			if(hasEventListener(GameEvent.END_GAME))
			{
				dispatchEvent(new GameEvent(GameEvent.END_GAME));
			}
			
			// Switch to the post level scene
			next = new StarScene(starCount, turnCount, link, input);
		}
		
		// Sets up actors array in advance of calling undo for all actors, clearing the grid and switching game state values as necessary
		internal function UndoSetup():void
		{
			if(gameOver)
			{
				gameOver = false;
			}
			if(solved)
			{
				solved = false;
			}
			
			CreateActorGrid();
		}

		// Writes any needed diagnostic information to the screen for debugging purposes
		internal function WriteDebug():void
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
						tempChars += actors[o][i].CollisionType.charAt();
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

	}
	
}
