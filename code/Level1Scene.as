package  {
	import flash.display.MovieClip; //Import Movie clip
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

		public override function Initialise(stage:Object):void //Initialise Method
		{
			stageSize = 7;
			
			// Initialise tile & grid values
			tileSize = stage.stageHeight / stageSize;
			stageBounds[0] = new Vector3D((stage.stageWidth - (tileSize * stageSize)) / 2, 0, 0);
			stageBounds[1] = new Vector3D(stageBounds[0].x + (tileSize * stageSize), stage.stageHeight, 0);
			
			stars = new <int>[2, 10, -1];
			
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
			stage.addChild(playerFrog);
			
			playerFrog.addEventListener(TurnEvent.PLAYER_TURN, StartTurn);
			
			var nextFrog:Actor = playerFrog;
		
			
			
			// Blue Snake
			var snake = new Snake(this, new Vector3D(3, 1, 0), Actor.BLUE_COLOUR);

			snake.Path = new Vector.<Vector3D>(2);
			snake.Path[0] = new Vector3D(3, 1);
			snake.Path[1] = new Vector3D(3, 3);

			entities.push(snake);
			stage.addChild(snake);
		}

		internal override function CreateGoal(stage:Object):void
		{
			goal = new Goal(this, new Vector3D(3, 0, 0));

			stage.addChild(goal);
		}
		
	
		internal override function CreateWalls(stage:Object):void
		{
			var wall;
			
			wall = new Wall(this, new Vector3D(0, 0, 0));
			stage.addChild(wall);
		}
	}
	
}
