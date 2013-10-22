package ControlPanel.StrategyTester.CloseTrade{
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.*;
	import flash.display.Sprite;
	import fl.controls.*;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.ScrollPolicy;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	import ControlPanel.CommonFiles.Util.*
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.filters.DropShadowFilter;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import fl.controls.UIScrollBar; 
	import fl.controls.Slider;
	import ControlPanel.StrategyTester.SingleEntity.EntityBuilder
	import flash.geom.*;
	import flash.display.*

 			
	//Opened by a Trade Trigger uses a TratTriggerEntity
	public class CloseTradeBuilder extends MovieClip{

		
		public var closeTradeConditionXML:XMLList;
		public var closeTradeConditionArray:Array;
		public var headerText:TextField
		public var headerClip:Sprite
		public var myDescription:String
		public var closeTradeDataGrid:DataGrid;
		public var closeTradeDataProvider:DataProvider;
		private var _background:MovieClip;
		private var xLoca:Number;
		private var yLoca:Number;
		private var myStage:MovieClip;
		private var xmlRootName:String;		
		private var infoLabel:TextField;
		private var STRATEGY:Strategy;
		private var _database:String;
		private var dropShadow;
		private var xmlDisplay:TextField;
		private var submitXML:XML;
		private var setBehaviorMC:Button;
		private var maxBet:Number;
		private var sliderArray:Array;
		private var percentColumn:DataGridColumn;
		private var needRisk:Boolean;
		public var isDataSet:Boolean;
		
		public function CloseTradeBuilder(stage:MovieClip, user:String, description:String, data:XML, needRisk:Boolean = false, xmlName:String = "Signal", maxBet:Number = 75) {
			
			this.xmlRootName = xmlName;
			this.maxBet = maxBet;
			this.needRisk = needRisk;
			this.name = description;
			myStage = stage;
			sliderArray = new Array();
			myDescription = description;
			closeTradeConditionArray = new Array();
			infoLabel = new TextField ;
			
			
			
			startUpStrategy();			
		}
		function init():void{
			
			this.scaleX = 0.9;
			this.scaleY = 0.9;
			this.x += 1
			this.y += 70	
			drawBackground();
			
			//dropShadow = new DropShadowFilter(5,10,20,0.5, 15, 15,1.0);
			closeTradeDataGrid = new DataGrid();
			closeTradeDataGrid.name = myDescription + " Conditions"
			createDataGrid(closeTradeDataGrid, 0,_background.y + 355, "Close Trade Conditions");
			closeTradeDataProvider = new DataProvider();
			closeTradeDataGrid.dataProvider = closeTradeDataProvider;
			addChild(_background);
			var textExit:TextField = new TextField();
			textExit.text = "[Close]";
			textExit.autoSize = "center";
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.color = 0x0033CC;
			//myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			textExit.setTextFormat(myFormat);
			textExit.x = 900;
			textExit.y = 0;
			//textExit.mouseEnabled = true;
			
			var textExitClip:MovieClip = new MovieClip();
			//textExitClip.addChild(textExit);
			textExitClip.mouseChildren = false;
			textExitClip.buttonMode = true;
			textExitClip.addEventListener(MouseEvent.CLICK, removeCondition);
			//addChild(textExitClip);
			
			addSetBehaviorButton();
			myStage.addChild(this);
			newEntityBuilder();
			//myStage.addChild(this);
		}
		function reset():void{
			//doneWithIfBtn.enabled = false;
			//this.submitBtn.enabled = false;
			/*this.slider.value = 0;
			this.slider.enabled = false;
			this.sliderLabel.text = this.slider.value.toString();
*/		}
		function handleSlider(e:Event):void
		{
			//checkSlider();
			//sliderLabel.text = e.target.value + " % ";
		}
		public function checkForConditions():Boolean{
			if(closeTradeDataGrid.length > 0){
				return true;
			}
			return false;
		}
		function createSlider(_xLoca:Number, _yLoca:Number, _sliderLabel:TextField, _size:Number):MovieClip
		{
			var sliderClip:MovieClip = new MovieClip();
			var sliderText:TextField = new TextField();
			//createSlider(375, 310, sliderLabel = new TextField, maxBet);
			var slider:Slider = new Slider();
			sliderClip.addChild(sliderClip)
			sliderClip.addChild(sliderText)
			
			//position slider
			slider.move(_xLoca,_yLoca);
			
			// control if slider updates instantly or after mouse is released
			slider.liveDragging = true;

			//set size of slider
			slider.setSize(200,200);

			//set maximum value
			slider.maximum = _size;

			//set mininum value
			slider.minimum = 0;
			
			slider.enabled = true;
			
			slider.addEventListener(Event.CHANGE, handleSlider);
			var myFormat:TextFormat = new TextFormat;
			myFormat.size = 12
			
			sliderText.defaultTextFormat = myFormat;
			sliderText.autoSize = "left"
			sliderText.x = slider.x + 60;
			sliderText.y = slider.y + 15;
			sliderText.text = "Initial Bet %";
			
			
			
			_sliderLabel.autoSize = "center"
			_sliderLabel.defaultTextFormat = myFormat
			_sliderLabel.x = slider.x + slider.width + 25;
			_sliderLabel.y = slider.y - 5;
			_sliderLabel.text = "0";
						
			return sliderClip;
		}
		function newEntityBuilder():void{
			if(getChildByName("EntityBuilder")){
			   removeChild(getChildByName("EntityBuilder"));
			   }
			
			var closeTradeEntity:EntityBuilder = new EntityBuilder();
			closeTradeEntity.name = "EntityBuilder";
			addChild(closeTradeEntity);
			closeTradeEntity.addEventListener("ConditionAdded", handleAccept)
			closeTradeEntity.y += 40;
			
		}
		function checkForData():void{
			
			if(closeTradeDataGrid.length > 0){
				isDataSet = true;
				
			}
			if (closeTradeDataGrid.dataProvider.length < 1)
			{
				isDataSet = false;
				dispatch("CloseTradeXML", new XML);
			}
			
			dispatch("isData", isDataSet);
		}
		function addSetBehaviorButton():void{
			setBehaviorMC = new Button();
			setBehaviorMC.move(900, this.height - 20);
			setBehaviorMC.label = "Set Condition"
			setBehaviorMC.addEventListener(MouseEvent.CLICK, setBehavior);
			addChild(setBehaviorMC);
		}
		function createXMLStringFromList(xmlList:XML):String{
			var xmlString:String;
            for each(var item:Object in xmlList) {
                xmlString += item
            }
			xmlString = xmlString.split("\n").join("");
			xmlString = xmlString.split("  ").join("");
			xmlString = xmlString.split(null).join("");
			xmlString = xmlString.replace("type", " type")
			return xmlString;
        
		}
		function dispatch(dispatchString:String, data:* = null):void{
			dispatchEvent(new CustomEvent(dispatchString, data));
		}
		function addXmlDisplay():void{
			
			xmlDisplay = new TextField();
			xmlDisplay.background = true;
			xmlDisplay.backgroundColor = 0xFFFFFF;
			xmlDisplay.width = 375;
			xmlDisplay.x = 450;
			xmlDisplay.y = 300;
		
			var mySb:UIScrollBar = new UIScrollBar(); 
			mySb.direction = "vertical"; 
			// Size it to match the text field. 
			mySb.setSize(xmlDisplay.width, xmlDisplay.height);  
			 
			// Move it immediately below the text field. 
			mySb.move(xmlDisplay.x + xmlDisplay.width, xmlDisplay.y); 
			mySb.scrollTarget = xmlDisplay;
			// put them on the Stage 
			//addChild(myTxt); 
			addChild(mySb); 
			addChild(xmlDisplay);
		}
		function breakdownXML(xml:XML):String{
			
			var type = "Field: " + xml.Condition.CondEntity.@type
			var condEntity = xml.Condition.CondEntity
			var condOperator = "Operator: "+ xml.Condition.CondOperator
			var parameter = "Operator Parameter: " + xml.Condition.Parameter
			var db = "Database: " + xml.DB;
			var  fullDisplay:String = type + "\n" + condEntity + "\n" + condOperator + "\n" + parameter + "\n" + db
			
			return fullDisplay;
		}
		function removeCondition(event:Event):void
		{
			parent.removeChild(this);
		}
		public function setBehavior(event:Event = null):void{
			if(closeTradeDataGrid.length > 0){
				dispatch("isReadyForStrat")
				dispatch("CloseTradeXML", setXML()) 
			}
			//trace("******************************XML FOR SET XML******************************************");
			//trace(setXML());
			//trace("******************************XML FOR SET XML******************************************");
						
 		}
		
		function dispatchResults(_result:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", _result));
		}
		function startUpStrategy():void
		{
			STRATEGY = Strategy.getInstance();
			init();
			

		}
		function drawBackground():void{
			
			
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
				matr.createGradientBox( 450, 900, Math.PI/2, 0, -175 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			
			_background = new MovieClip();
			var g:Graphics = _background.graphics;
				g.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod );
				g.drawRect(0, 0, 1000, 500);
			var filter = new DropShadowFilter(16,45,20,0.5, 20.0, 20.0,1.0);
			addChild(_background);
		}
		
		
		function handleAccept(event:CustomEvent):void{

			var array:Array = event.data;
			var s:String = this.myDescription + " Conditions"
			closeTradeDataProvider.addItem({"Initial Entity": array[0].Summery, "Math Operator": array[0].MathOp, "Second Entity": array[0].SecondEntSummery, XML: array[0].XML})	
			checkForData();
			//sliderArray.push(createSlider
			
			
		}
		public function setXML():XMLList{
			
			closeTradeConditionXML = new XMLList();
			
			if(closeTradeDataProvider.length > 0)
			{
				for(var closeTradeConditionArrayIndex:Number = 0; closeTradeConditionArrayIndex < closeTradeDataProvider.length; closeTradeConditionArrayIndex++)
				{
					var betXML:XML = new XML(<BetStruct/>);
					
					betXML["BetStruct"] = "0:100";
					var tempXML:XML = new XML(closeTradeDataProvider.getItemAt(closeTradeConditionArrayIndex).XML)
					tempXML.appendChild(betXML["BetStruct"]);
					closeTradeConditionXML += tempXML;
				}
/*
				//trace("+++++++++++++++++++++++++++This is the XML from setXML in CloseTrade++++++++++++++++++++++++++++++")
				//trace(closeTradeConditionXML)
				//trace("+++++++++++++++++++++++++++This is the XML from setXML in CloseTrade++++++++++++++++++++++++++++++")
				return closeTradeConditionXML;*/
			}
			//closeTradeConditionXML[0] = "NONE"
			/*//trace(closeTradeConditionXML)
			//trace("THIS IS THE Close Trade XML+++++++++++++++++++++++++++++++++++++++:")*/
			return closeTradeConditionXML;
	
		
		}
		
		function setLabel(obj:Object):void
		{

			infoLabel.autoSize = "left";
			infoLabel.x = 0;
			infoLabel.y = 0;
			infoLabel.textColor = 0x000000;
			infoLabel.text = obj.description;
			infoLabel.wordWrap = true;
			infoLabel.background = true;
			infoLabel.backgroundColor = 0xF6DDBC;
			infoLabel.border = true;
			infoLabel.borderColor = 0xC0C0C0;
			infoLabel.width = 250;
			infoLabel.antiAliasType = AntiAliasType.ADVANCED;
			var tw:Tween = new
			Tween(infoLabel,"alpha",None.easeNone,infoLabel.alpha,1,1,true);
		}
		
		/*
		* Assigns properties to a datagrid and assigns properties to the datagrid.
		*
		* @dg The Datagrid in which to assign properties.
		* @xLoc The x location of the datagrid
		* @yLoc The y location of the datagrid
		* @dataName The name of the lead column of the datagrid
		*
		* @ return void
		*/
		function createDataGrid(dg:DataGrid, xLoc:Number, yLoc:Number,
		dataName:String):void
		{
			var i:uint;
			var totalRows:uint = 5;
			//dg.editable = true;
			dg.x = xLoc;
			dg.y = yLoc;
			dg.name = dataName;
			dg.setSize(825, 125);
			if(needRisk){
			dg.columns = ["Initial Entity", "Math Operator", "Second Entity", "Percent Risk (of Portfolio)"];
			}
			if(!needRisk){
			dg.columns = ["Initial Entity", "Math Operator", "Second Entity"];
			}
			dg.rowHeight = 40;
			dg.resizableColumns = true; 
			dg.verticalScrollPolicy = ScrollPolicy.AUTO; 
			var col0:DataGridColumn = new DataGridColumn(); 
			
			col0 = dg.getColumnAt(0); 
			col0.cellRenderer = MultiLineCell;
			//col0.editable = false;
			
			var col1:DataGridColumn = new DataGridColumn(); 
			col1 = dg.getColumnAt(1); 
			col1.cellRenderer = MultiLineCell;
			//col1.editable = false;
			
			var col2:DataGridColumn = new DataGridColumn(); 
			col2 = dg.getColumnAt(2); 
			col2.cellRenderer = MultiLineCell;
			//col2.editable = false;
			
			if(needRisk){
			percentColumn = new DataGridColumn(); 
			percentColumn = dg.getColumnAt(3);
			percentColumn.cellRenderer = LoaderCellRenderer;
			percentColumn.editable = true;
			}
						
			var redX:Class = getDefinitionByName("red_X2") as Class;
			var red_X:Bitmap = new Bitmap(new redX());
			
			red_X.scaleX = 0.05;
			red_X.scaleY = 0.05;
			//red_X.x = dg.x + dg.width + 10;
			//red_X.y = yLoc

			var container:MovieClip = new MovieClip();

			container.addChild(red_X);
			container.y = yLoca;
			container.x = dg.width + 10;
			container.buttonMode = true;
			container.addEventListener(MouseEvent.CLICK,
			function(e:MouseEvent){DeleteFromList(e,dg)});
			
			dg.addChild(container);
			_background.addChild(dg)
			
		}
		function handlePercColChange(event:Event):void{
			
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
			checkForData();
		}
		
		
	}
	
}
