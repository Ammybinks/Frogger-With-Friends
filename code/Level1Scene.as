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
	
	public class Level1Scene extends GameScene implements IGameScene 
	{
		public function Level1Scene(input:InputManager)
		{
			super(input);
		}

		// Initialise all values and objects to be added to the screen
		public override function Initialise(stage:Object):void
		{
			// Return the program's focus to the stage, if it wasn't there already.
			// Solves problems with inputs not registering after a button has been pressed
			stage.focus = stage;
			
			stageSize = 7;
			
			// Initialise tile & grid values
			tileSize = stage.stageHeight / stageSize;
			stageBounds[0] = new Vector3D((stage.stageWidth - (tileSize * stageSize)) / 2, 0, 0);
			stageBounds[1] = new Vector3D(stageBounds[0].x + (tileSize * stageSize), stage.stageHeight, 0);
			
			// Set amount of stars the player gets for each number of moves
			stars = new <int>[2, 10, -1];
			
			// Set link to the next level in the sequence
			link = new Level2Scene(input);
		}

		// Initialises each moving actor and places them on the stage
		internal override function CreateActors(stage:Object): void
		{
			//////
			// Frogs
			//////
			
			//// Player PartyFrog
			var playerFrog:Actor = new PlayerFrog(this, input, new Vector3D(3, 5, 0), Actor.GREEN_COLOUR);

			playerFrog.rotation = 180;
			
			entities.push(playerFrog);
			
			// Listens for when the frog begins moving, to count turns
			playerFrog.addEventListener(TurnEvent.PLAYER_TURN, StartTurn);
			
			var nextFrog:Actor = playerFrog;
		
			//////
			// Snakes
			//////
			
			// Blue Snake
			var snake = new Snake(this, new Vector3D(3, 1, 0), Actor.BLUE_COLOUR);

			// Initialise the snake's path of movement
			snake.Path = new Vector.<Vector3D>(2);
			snake.Path[0] = new Vector3D(3, 1);
			snake.Path[1] = new Vector3D(3, 3);

			entities.push(snake);
		}

		// Places the goal on the stage in a certain position
		internal override function CreateGoal(stage:Object):void
		{
			goal = new Goal(this, new Vector3D(3, 0, 0));

			entities.push(goal);
		}
		
		// Creates all the walls for the level, including individiual walls for grid collisions and wall segments for physics collisions
		internal override function CreateWalls(stage:Object):void
		{
			var wall;
			var wallSegment;
			
			wall = new Wall(this, new Vector3D(0,0,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(1,0,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(2,0,0));
			entities.push(wall);		
			wall = new Wall(this, new Vector3D(0,1,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(1,1,0));
			entities.push(wall);	
			wall = new Wall(this, new Vector3D(2,1,0));
			entities.push(wall);		
			wall = new Wall(this, new Vector3D(0,2,0));
			entities.push(wall);	
			wall = new Wall(this, new Vector3D(1,2,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(2,2,0));
			entities.push(wall);	
			wall = new Wall(this, new Vector3D(0,3,0));
			entities.push(wall);
			wall = new Wall(this, new Vector3D(1,3,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(2,3,0));
			entities.push(wall);			
			
			wallSegment = new WallSegment(new Vector3D((TileSize * 0) + StageBounds[0].x, 
													   (TileSize * 0) + StageBounds[0].y), 
									      new Vector3D((TileSize * 3) + StageBounds[0].x, 
													   (TileSize * 4) + StageBounds[0].y));
			entities.push(wallSegment);
			
			
			wall = new Wall(this, new Vector3D(4,0,0));
			entities.push(wall);	
			wall = new Wall(this, new Vector3D(5,0,0));
			entities.push(wall);					
			wall = new Wall(this, new Vector3D(6,0,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(4,1,0));
			entities.push(wall);		
			wall = new Wall(this, new Vector3D(5,1,0));
			entities.push(wall);		
			wall = new Wall(this, new Vector3D(6,1,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(4,2,0));
			entities.push(wall);
			wall = new Wall(this, new Vector3D(5,2,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(6,2,0));
			entities.push(wall);
			wall = new Wall(this, new Vector3D(4,3,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(5,3,0));
			entities.push(wall);			
			wall = new Wall(this, new Vector3D(6,3,0));
			entities.push(wall);
			
			wallSegment = new WallSegment(new Vector3D((TileSize * 4) + StageBounds[0].x, 
													   (TileSize * 0) + StageBounds[0].y), 
									      new Vector3D((TileSize * 7) + StageBounds[0].x, 
													   (TileSize * 4) + StageBounds[0].y));
			entities.push(wallSegment);
		}
	}
	
}
