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
	
	public class Level3Scene extends GameScene implements IGameScene {
		public override function Initialise(stage:Object):void //Initialise Method
		{
			input = new InputManager(stage);

			stageSize = 8;
			
			// Initialise tile & grid values
			tileSize = stage.stageHeight / stageSize;
			stageBounds[0] = new Vector3D((stage.stageWidth - (tileSize * stageSize)) / 2, 0, 0);
			stageBounds[1] = new Vector3D(stageBounds[0].x + (tileSize * stageSize), stage.stageHeight, 0);
			
			stars = new <int>[3, 11, -1];
		}

		internal override function CreateGoal(stage:Object):void
		{
			goal = new Goal(this, new Vector3D(4, 1, 0));

			stage.addChild(goal);
		}
		
		// Initialises each moving actor and places them on the stage
		internal override function CreateActors(stage:Object): void
		{
			//////
			// Frogs
			//////
			
			//// Player PartyFrog
			var playerFrog:Actor = new PlayerFrog(this, new Vector3D(3, 3, 0), Actor.GREEN_COLOUR);

			playerFrog.rotation = 180;
			
			entities.push(playerFrog);
			stage.addChild(playerFrog);
			
			playerFrog.addEventListener(TurnEvent.PLAYER_TURN, StartTurn);
			
			var nextFrog:Actor = playerFrog;

			// Blue PartyFrog
			var partyFrog:Actor = new PartyFrog(this, new Vector3D(3, 4, 0), Actor.BLUE_COLOUR, nextFrog as INext);
			
			entities.push(partyFrog);
			stage.addChild(partyFrog);
			
			nextFrog = partyFrog;

			// Red PartyFrog
			partyFrog = new PartyFrog(this, new Vector3D(3, 5, 0), Actor.RED_COLOUR, nextFrog as INext);

			entities.push(partyFrog);
			stage.addChild(partyFrog);
			

			//////
			// Snakes
			//////
			
			// Red Snake
			var snake = new Snake(this, new Vector3D(7, 3, 0), Actor.RED_COLOUR);

			snake.Path = new Vector.<Vector3D>(2);
			snake.Path[0] = new Vector3D(0, 3);
			snake.Path[1] = new Vector3D(7, 3);

			entities.push(snake);
			stage.addChild(snake);
			
			// Green Snake
			snake = new Snake(this, new Vector3D(0, 3, 0), Actor.GREEN_COLOUR);

			snake.Path = new Vector.<Vector3D>(2);
			snake.Path[0] = new Vector3D(7, 3);
			snake.Path[1] = new Vector3D(0, 3);

			entities.push(snake);
			stage.addChild(snake);
			
			// Blue Snake
			snake = new Snake(this, new Vector3D(1, 4, 0), Actor.BLUE_COLOUR);

			snake.Path = new Vector.<Vector3D>(2);
			snake.Path[0] = new Vector3D(7, 4);
			snake.Path[1] = new Vector3D(0, 4);

			entities.push(snake);
			stage.addChild(snake);
		}
	}
	
}
