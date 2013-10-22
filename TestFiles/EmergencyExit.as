package ControlPanel.StrategyTester
{
	import flash.display.MovieClip;
	import ControlPanel.StrategyTester.*
	import ControlPanel.CommonFiles.Scroll.*
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.*;
	import flash.text.TextFormat;
	import fl.controls.Button;
	import flash.geom.*;
	import flash.display.*;
	import ControlPanel.*


	public class EmergencyExit extends MovieClip{
		public var _if:If;
		public var emExXML:XML;
		public var ifArray:Array;
		public var headerText:TextField
		public var headerClip:Sprite
		public var description:String
		public var emergDataGrid:DataGrid;
		public var emergDataProvider:DataProvider;
		private var _background:MovieClip;
		var _mask:MovieClip; 
		var m:Main;
		private var xLoca:Number;
		private var yLoca:Number;
		private var myStage:MovieClip;
		private var myColor:Number
		var myGlow:GlowFilter = new GlowFilter();
		private var acceptExitConditions:Button = new Button;
		
		public function EmergencyExit(stage:MovieClip, _description:String, _xLoca:Number, _yLoca:Number,  _backgroundColor:Number) {
			
			
			myStage = stage
			myColor = _backgroundColor
			description = _description
			xLoca = _xLoca;
			yLoca = _yLoca;
			
			myGlow.color = myColor;
			myGlow.blurX = 4; 
			myGlow.blurY = 4;
			myGlow.strength = 200;
			//emergDataGrid.addEventListener(MouseEvent.CLICK, StartTradeEntry);
			
			ifArray = new Array
			
			drawBackground();
			
			//setHeaderText();
			emergDataGrid = new DataGrid();
			emergDataGrid.name = "Emergency Exit Conditions"
			CreateDataGrid(emergDataGrid,250,375,"Emergency Exit Conditions");
			emergDataProvider = new DataProvider();
			emergDataGrid.dataProvider = emergDataProvider;
			//_background.addChild(_if);
			drawMask();
			
			m = new Main(_mask);
			
			_background.addChild(m)
			
			m.x = 25;
			m.y = 130;
			
			
		}
		public function returnEmConditions():DataProvider{
			return emergDataProvider;
		}
		public function guiComplete():void{
			_background.y = 1500;
			myStage.addChild(_background)
		}
		function drawMask():void
		{

			_mask = new MovieClip();
			
			
			_mask.graphics.drawRect(xLoca, yLoca, 1050, 500);
			
			_background.addChild(_mask);
		}
		function drawBackground():void{
			/*_background = new MovieClip();
			_background.alpha = 0;
			_background.graphics.lineStyle(1, 0x000000);
			_background.graphics.beginFill(myColor, 1);
			_background.graphics.drawRect(0,0,900,400);
			_background.graphics.endFill();*/
			
			
			_background = new MovieClip();
			_background.graphics.lineStyle(1, 0x6D7B8D);
			//Type of Gradient we will be using
			var fType:String = GradientType.LINEAR;
			//Colors of our gradient in the form of an array
			var colors:Array = [0xCCBB88, 0xFFFFFF];
			//Store the Alpha Values in the form of an array
			var alphas:Array = [0.8, 0.8];
			//Array of color distribution ratios.  
			//The value defines percentage of the width where the color is sampled at 100%
			var ratios:Array = [0, 255];
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix = new Matrix();
				matr.createGradientBox( 900, 400, Math.PI/2, 0, -175 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			//Save typing + increase performance through local reference to a Graphics object
			var g:Graphics = _background.graphics;
				g.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod );
				g.drawRect(this.xLoca, this.yLoca, 900, 400);

			_background.addChild(PlaceImage("plusmed.png", newIf, 0.1, 0.1, _background.width - 65 + 100, 125));
			
			acceptExitConditions = new Button();
			acceptExitConditions.label = "Done"
			acceptExitConditions.width = 75;
			acceptExitConditions.emphasized = true;
			acceptExitConditions.setStyle("icon", BulletCheck);
			acceptExitConditions.move(875, 460)
			//acceptExitConditions.enabled = false;
			acceptExitConditions.addEventListener(MouseEvent.CLICK, acceptCondition);
			_background.addChild(acceptExitConditions)
			//_background.addChild(PlaceImage("next.png", acceptCondition, 0.1, 0.1, _background.width - 35,  _background.height - 50));
			//_background.addChild(PlaceImage("red_X2", removeIf, 0.1, 0.1, _background.width - 35, 55));
			
		}
		
		function newIf(event:Event):void{
			var if2:If = new If(true, this);
			if2.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove)
			if2.addEventListener("IhaveBeenAccepted", handleAccept)
			if(ifArray.length > 0)
			{
				if2.y = ifArray[ifArray.length - 1].y + if2.height;
				_mask.addChild(if2)
				ifArray.push(if2);
			}
			if(ifArray.length == 0)
			{
				_mask.addChild(if2)
				ifArray.push(if2);
			}
			
		}
		function handleAccept(event:Event):void{
			var tIf:If = event.target as If
			emergDataProvider.addItem({"Emergency Exit Conditions": tIf.displayInfo() ,If: tIf})
			
		}
		public function setXML():XML{
			emExXML = new XML(<EmEx/>);
			for each (var ifItem:If in ifArray){
				ifItem.acceptMe();
				emExXML.appendChild(ifItem.condition_xml)
				
			}
			//////trace(emExXML.toXMLString());
			return emExXML;
		}
		public function returnHeader():Sprite{
			return headerClip;
		}
		function handleRemove(event:Event):void{
			var obj:Object = event.target;
			var index:Number = ifArray.indexOf(event.target);
			ifArray.splice(ifArray.indexOf(event.target), 1)
			for (var index; index < ifArray.length; index++)
			{
				ifArray[index].y = ifArray[index].y - obj.height;
			}
			
		}
	
		function displayArray():void{
			var tempy:Number;
			for each(var _if:If in ifArray)
			{
				tempy = _if.y;
				_background.addChild(_if);
			}
		}
		function acceptCondition(event:Event):void{
			//collapseMe()
			//trace(this.setXML());
		}
		
		public function expandMe():void{
			_background.alpha = 1;
			_background.y = 0;
			_background.enabled = true;
			
		}
		function expandHeader(event:MouseEvent):void{
			expandMe();
		}
		public function collapseMe():void{
			_background.alpha = 0;
			_background.y = 1500;
			_background.enabled = false;
					}
		function collapseHeader(event:MouseEvent):void{
			collapseMe();
		}
		function CreateDataGrid(dg:DataGrid, xLoc:Number, yLoc:Number,
		dataName:String):void
		{
			var i:uint;
			var totalRows:uint = 5;
			dg.x = xLoc;
			dg.y = yLoc;
			dg.name = dataName;
			dg.setSize(600, 100);
			dg.columns = [dataName];


			var redX:Class = getDefinitionByName("red_X2") as Class;
			var red_X:Bitmap = new Bitmap(new redX());
			red_X.scaleX = 0.05;
			red_X.scaleY = 0.05;
			red_X.x = dg.x + dg.width + 10;
			red_X.y = dg.y;

			var container:MovieClip = new MovieClip();

			//container.addChild(red_X);
			container.buttonMode = true;
			container.addEventListener(MouseEvent.CLICK,
			function(e:MouseEvent){DeleteFromList(e,dg)});
			
			dg.addChild(container);
			_background.addChild(dg)
			
		}
		function PlaceImage(_className:String, _function:Function, _xScale:Number = 1, _yScale:Number = 1, _xLoca:Number = 0, _yLoca:Number = 0):MovieClip
			{
				var _container:MovieClip = new MovieClip();
				var tempClass:Class = getDefinitionByName(_className) as Class;
				var tempBitmap:Bitmap = new Bitmap(new tempClass());
				_container.name = _className;
				_container.scaleX = _xScale;
				_container.scaleY = _yScale;
				_container.x = _xLoca;
				_container.y = _yLoca;
				_container.addChild(tempBitmap);
				_container.buttonMode = true;
				_container.addEventListener(MouseEvent.CLICK, _function);
				return _container;
			}
		function DeleteFromList(event:Event, dg:DataGrid):void
		{
			if (dg.selectedIndex > -1)
			{
				if (dg.dataProvider.length > 0)
				{
					dg.dataProvider.removeItemAt(dg.selectedIndex);
				}
			}
		}
	}
	
}
