package  
{

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
	
	public class StarScene extends MovieClip implements IScene
	{

		// constructor code
		public function StarScene(stars:String, Link:IScene, input:InputManager) 
		{
			this.Link = Link;
			this.input = input;
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.color = 0x000000;
			format.font = "Verdana";
			format.align = "center";
			
			winText = new TextField();
			winText.type = "dynamic";
			winText.text = stars;
			winText.border = false;
			winText.selectable = false;
			winText.autoSize = TextFieldAutoSize.LEFT;
			winText.antiAliasType = AntiAliasType.ADVANCED;
			winText.embedFonts = true;

			winText.setTextFormat(format);
		}
			
			private var input:InputManager;
			private var Link:IScene;
		
			private var winText:TextField; 
		
			private var entities:Vector.<Object> = new Vector.<Object>();
			public function get Entities():Vector.<Object> { return entities; }
			public function set Entities(value:Vector.<Object>):void { entities = value; }
			
			private var next:IScene;
			public function get Next():IScene { return next; }
			public function set Next(value:IScene):void { next = value; }
			
			private var unloading:Boolean = false;
			public function get Unloading():Boolean { return unloading; }		
			
			
		public function Initialise(stage:Object):void
		{
			
			
			winText.x = (stage.stageWidth / 2) - (winText.width / 2);
			winText.y = (stage.stageHeight / 2) - (winText.height / 2);
			entities.push(winText);
			
		}
		
		public function LoadContent (stage:Object):void
		{
			stage.addChild(winText);
			
		}
		
		public function UnloadContent(stage:Object):IScene//Unload content method
		{
			unloading = true;

			Next.Entities = entities;
			
			for(var i:int = 0; i < entities.length; i++)
			{
				stage.removeChild(entities[i]);
			}
			
			entities.length = 0;
			
			return next;
		}
		
		public function Update():void //Update method
		{
			if (input.anyTapped)
			{
				next = Link
			}
				
		}
	}
	
}
