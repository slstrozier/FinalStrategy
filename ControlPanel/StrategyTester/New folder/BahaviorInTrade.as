package ControlPanel.StrategyTester
{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Util.*
	import ControlPanel.CommonFiles.Scroll.*
	import ControlPanel.CommonFiles.CandleStick.*
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import fl.controls.DataGrid;
	import fl.data.DataProvider;
	import flash.utils.getDefinitionByName;
	import flash.display.Bitmap;
	import flash.events.Event;
	import fl.controls.RadioButtonGroup;
	import fl.controls.RadioButton;
	import fl.controls.Slider
	import flash.text.TextFormat;
	import flash.filters.*;
	import fl.controls.DataGrid;
	import fl.controls.Button;
	import flash.geom.*;
	import flash.display.*;
	import fl.motion.DynamicMatrix;
	//this is for a test
	

	public class BahaviorInTrade extends MovieClip{
		public var _if:If;
		public var then:Then;
		public var emExXML:XML;
		public var ifArray:Array;
		public var headerText:TextField
		public var headerClip:Sprite
		public var description:String
		public var behaviorDG:DataGrid;
		public var behaviorInTradeDataProvider:DataProvider;
		private var _background:MovieClip;
		private var if_reactionList:Array;
	//*****XML***********
		private var CONDENTITY:String;
		private var CONDOPERATOR:String;
		private var PARAMETERS:String;
		private var BETSTRUCT:String;
		private var TYPE:String;
		private var condition_xml:XML;
		//*****ENDXML***********
		private var slider:Slider;
		private var sliderLabel:TextField;
		private var fixedReactionAdd:String;
		private var maxDaily:Number
		private var selectableGroup:RadioButtonGroup;
		private var _fixed:RadioButton;
		private var _dynamic:RadioButton;
		private var reaction:String;
		private var dispatchString:String;
		private var fixedBetStruct:XML;
		private var myGlow:GlowFilter = new GlowFilter();
		private var strategyString:String;
		private var fullClip:MovieClip;
		private var isDynamic:Boolean;
		private var _background2:MovieClip;
		private var headerX:Number;
		private var headerY:Number;
		private var _mask:MovieClip; 
		private var m:Main;
		private var bahavior:DataGrid;
		private var if_reaction:DynamicReaction;
		private var if_reactionDisplay:Array;
		private var conditionType:String;
		
		public function BahaviorInTrade(_description:String, _headerXLoca:Number, _headerYLoca:Number) {
			
			selectableGroup = new RadioButtonGroup("Reaction");
			myGlow.color = 0xFFCCCC;
			myGlow.blurX = 4; 
			myGlow.blurY = 4;
			myGlow.strength = 200;
			
			headerX = _headerXLoca
		    headerY = _headerYLoca
			strategyString = "";
			fullClip = new MovieClip();
			
			slider = new Slider();
			bahavior = new DataGrid();
			var header:MovieClip = new MovieClip;
			ifArray = new Array
			headerClip = new Sprite();
			
			
			description = _description;
			headerText = new TextField();
			headerText.autoSize = "left"
			drawBackground();
			
			
			behaviorDG = new DataGrid();
			behaviorDG.name = "Behavior Conditions"
			CreateDataGrid(behaviorDG,360,275,"Behavior Conditions");
			behaviorInTradeDataProvider = new DataProvider();
			behaviorDG.dataProvider = behaviorInTradeDataProvider;
			//_background.addChild(_if);
			drawMask();
			
			m = new Main(_mask);
			
			_background.addChild(m)
			
			m.x = -50
			drawBackground2();
			setCommitScreenButton();
			setCommitBehaviorButton();
			this.expandMe();
			
			
		}
		public function returnHeader():Sprite{
			return headerClip;
		}
		public function setMaxDaily(_maxDaily:Number):void{
			maxDaily = _maxDaily;
			createSlider(200, 250, sliderLabel = new TextField(), Number(maxDaily));
			createRadioButtons();
		}
		public function returnXML():XML{
			return this.condition_xml;
		}
		function setCommitScreenButton():void{
			var butText:Button = new Button();
			butText = new Button();
			butText.label = "Commit Screen"
			butText.setSize(110, 50)
			butText.emphasized = true;
			butText.setStyle("icon", BulletCheck);
			butText.move(785, 345)
			butText.addEventListener(MouseEvent.CLICK, handleScreenCommit);
			_background.addChild(butText);
			
		}
		
		function setCommitBehaviorButton():void{
			//Create a new instance of a Sprite to act as the button graphic.
			var butText:Button = new Button();
			butText = new Button();
			butText.label = "Commit Behavior"
			butText.emphasized = true;
			butText.setSize(125, 25)
			butText.setStyle("icon", BulletCheck);
			butText.move(550, 240)
			butText.addEventListener(MouseEvent.CLICK, handleBehaviorCommit);
			_background.addChild(butText);
			
			//_background.addChildAt(butText,0);
		}
		
		function handleScreenCommit(event:Event):void{
			//dispatchEvent(new Event("BehaviorCommitted"));
			//trace(setXML());
			
		}
	
		function finishedReactions(event:Event):void{
			//var dynReaParDisp:MovieClip = event.target as MovieClip;
			var tempXML:XML = new XML(ifArray[0].condition_xml);
			tempXML["BetStruct"] = concactParameters(if_reaction.returnParameterArray());
			ifArray[0].resetXML(tempXML);
			if_reactionDisplay = new Array(if_reaction);
			if_reaction.closeMe();
			////trace(if_reactionDisplay[0])
			////trace(tempXML);
			behaviorInTradeDataProvider.addItem({"Behavior Conditions":  ifArray[0].displayInfo() + if_reaction.returnParameterArray(), TheXML: tempXML, Reactions: if_reaction})
			reset();
			
		}
		function concactParameters(array:Array):String
		{
			var temp:String = "";
			if(array[0] != undefined)
			{
				for each (var inputField:Object in array)
					{
						temp +=  inputField + ",";
					}
						
				temp = temp.substring(temp.length - 1, -  temp.length);
			}
			
			return temp;
		}
		
		function createSlider(_xLoca:Number, _yLoca:Number, _sliderLabel:TextField, _size:Number):void
		{
			_sliderLabel.text = (0).toString();
			_sliderLabel.autoSize = "left";
			//position slider
			slider.move(_xLoca,_yLoca);

			// control if slider updates instantly or after mouse is released
			slider.liveDragging = true;

			//set size of slider
			slider.setSize(100,0);

			//set maximum value
			slider.maximum = _size;

			//set mininum value
			slider.minimum = 0;

			slider.addEventListener(Event.CHANGE, handleSlider);
			DrawTextBox(sliderLabel, _xLoca + 75, _yLoca + 25, "0");
			_background.addChild(slider);
		}
		function DrawTextBox(myTextField:TextField, _xLoca:Number,
		_yLoca:Number, _name:String):void
		{
			_background.addChild(myTextField);
			myTextField.autoSize = "center";
			myTextField.x = _xLoca;
			myTextField.y = _yLoca;
			myTextField.selectable = false;
			myTextField.text = _name;
			

		}
		
		function handleSlider(e:Event):void
		{
			sliderLabel.text = e.currentTarget.value;
			fixedReactionAdd = e.currentTarget.value;
		}
		
		
		public function returnEmConditions():DataProvider{
			return behaviorInTradeDataProvider;
		}
		
		function drawMask():void
		{

			_mask = new MovieClip();
			
			
			_mask.graphics.drawRect(25, 50, 1050, 500);
			
			_background.addChild(_mask);
		}
		function drawBackground():void{
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
				matr.createGradientBox( 900, 600, Math.PI/2, 0, -175 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			//Save typing + increase performance through local reference to a Graphics object
			var g:Graphics = _background.graphics;
				g.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod );
				g.drawRect(0, 0, 900, 400);
				
			_background.addChild(PlaceImage("plusmed.png", newIf, 0.1, 0.1, _background.width - 35, 10));
						
		}
		function removeIf(event:Event):void{
			
		}
		function drawBackground2():void
		{
			_background2 = new MovieClip();

			_background2.graphics.lineStyle(1);
			_background2.graphics.beginFill(0xDDDDDD);
			_background2.graphics.drawRect(0, 300, 830, 400);
			_background2.graphics.endFill();
			
		}
		
		
		//This function adds the if to this objects list of if's
		function newIf(event:Event):void{
			
			checkForPossibleReactions();
			var if2:If = new If(true, _background);
			if2.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove)
			
			if2.addEventListener("candleStick", handleCandle);
			if2.addEventListener("typeSelected", typeSelectedHandler);
			if2.addEventListener("mathOp", allowDynamic);
			
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
			if(ifArray.length > 0)
			{
				
				slider.enabled = false;
				_dynamic.enabled = false
			}
			
			
			
		}
		function allowDynamic(event:Event):void{
			if(ifArray.length == 1){
			_dynamic.enabled = true;
			}
		}
		function handleCandle(event:Event):void{
			var candleS:Candlestick = new Candlestick(_background);
		}
		function handleBehaviorCommit(event:Event):void{
			
					if(selectableGroup.selection == _fixed)
					{
						if(ifArray.length == 1)
						{
							ifArray[0].displayInfo();
							var temp:XML = new XML(ifArray[0].condition_xml);
							temp["BetStruct"] = "0:" + this.slider.value;
							behaviorInTradeDataProvider.addItem({"Behavior Conditions":  ifArray[0].displayInfo() , TheXML: temp})
							
						}
						
						if(ifArray.length > 1)
						{
							//place the first xml in ifArray into multCondArray
							var multCondArray:Array = new Array();
							ifArray[0].displayInfo();
							var temp:XML = new XML(ifArray[0].condition_xml);
							temp["BetStruct"] = "0:" + this.slider.value;
							//the first ifObjects description is added to dispInfo
							var dispInfo:String = "";
							dispInfo = ifArray[0].returnMyName() + "; ";
							//adds the xml to multCondArray
							multCondArray.push(temp);
							
							//place all other xmls in multCondArray into the list
							for(var ifIndex:Number = 1; ifIndex < ifArray.length; ifIndex++)
							{	
								ifArray[ifIndex].displayInfo();
								//all the other ifObjects are appended to  dispInfo
								dispInfo += ifArray[ifIndex].returnMyName() + "; "
								var condXML:XML = new XML(ifArray[ifIndex].condition_xml);
								multCondArray.push(condXML);
							}
							//break down the xml's inside multCondArray and place the into one string;	
							condition_xml = new XML(<Add/>);
							for(var indx:Number = 0; indx < multCondArray.length; indx++){
								condition_xml.appendChild(multCondArray[indx]);
							}
							
							//condition_xml.appendChild(xmlString);
							//trace(condition_xml);
							var natString:String =  "Multiple Conditions: " + dispInfo;
							behaviorInTradeDataProvider.addItem({"Behavior Conditions":  natString, TheXML: condition_xml})
						}
						
					}
					//trace(behaviorInTradeDataProvider.getItemAt(0).TheXML);
					//condition_xml = new XML(<Add/>);
			
			
			
			reset();
		}
		
		/*Resets the behavior in trade to an empty one*/
		function reset():void{
			slider.value = 0;
			sliderLabel.text = slider.value.toString();
			_fixed.enabled = false;
			_dynamic.enabled = false;
			selectableGroup.selection = _fixed;
			for (var objIndex:Number = 0; objIndex < ifArray.length; objIndex++){
				ifArray[objIndex].removeEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
				_mask.removeChild(ifArray[objIndex]);
			}
			ifArray.splice(0);
		}
		function typeSelectedHandler(event:CustomEvent):void{
			conditionType = event.data;
			checkTypeForReaction(conditionType)
			if(ifArray.length > 1){
				checkForPossibleReactions();
			}
			
		}
		function checkTypeForReaction(typeOfIf:String):void{
	
			if(conditionType == "PORT" || conditionType == "TIME"){			
				slider.enabled = true;
				_fixed.enabled = true;
				_dynamic.enabled = false;
			
			}
			if(conditionType == "IND" || conditionType == "TBL"){
				slider.enabled = true;
				_fixed.enabled = true;
			
			}
			
		}
		function handleRemove(event:Event):void{
			var obj:Object = event.target;
			var index:Number = ifArray.indexOf(event.target);
			ifArray.splice(ifArray.indexOf(event.target), 1)
			for (var index; index < ifArray.length; index++)
			{
				ifArray[index].y = ifArray[index].y - obj.height;
			}
			
			
			checkForPossibleReactions();
			if(ifArray.length == 0)
			{
				reset();
			}
			
		}
		function checkForPossibleReactions():void{
			
			if(ifArray.length == 0){
				slider.enabled = false;
				_fixed.enabled = false;
				_dynamic.enabled = false;
			}
			if(ifArray.length == 1){
				slider.enabled = true;
				_fixed.enabled = true;

			}
			if(ifArray.length > 1){
				slider.enabled = true;
				_fixed.enabled = true;
				_dynamic.enabled = false;
			}
		}
		function setReactions():void{
			
		}
		function displayArray():void{
			var tempy:Number;
			for each(var _if:If in ifArray)
			{
				tempy = _if.y;
				_background.addChild(_if);
			}
		}
	
		
		function expandHeader(event:MouseEvent):void{
			expandMe();
		}
		function collapseHeader(event:MouseEvent):void{
			collapseMe();
		}
		function collapseMe():void{
			_background.alpha = 0;
			_background.y = 1500;
			if(then){
			then.y = 5000;
			}
			_background.enabled = false;
			headerClip.filters = [];
			headerClip.addEventListener(MouseEvent.CLICK, expandHeader)
			headerClip.removeEventListener(MouseEvent.CLICK, collapseHeader)
		}
		function expandMe():void{
			addChild(_background)
			_background.alpha = 1;
			_background.x = 15
			_background.y = 15
			
			if(then){
			then.y = 400
			}
			_background.enabled = true;
			headerClip.filters = [myGlow]
			headerClip.removeEventListener(MouseEvent.CLICK, expandHeader)
			headerClip.addEventListener(MouseEvent.CLICK, collapseHeader)
		}
		
		
		function createRadioButtons():void
		{
			_fixed = new RadioButton();
			_dynamic = new RadioButton();
			_fixed.enabled = false;
			_dynamic.enabled = false;
			slider.enabled = false;
			selectableGroup.addEventListener(Event.CHANGE, changeHandler);
			_dynamic.addEventListener(MouseEvent.CLICK, handleDynamicReaction)

			_fixed.width = 200;
			_fixed.label = "Fixed one-time reaction = ADD ";
			_fixed.value = "Fixed";
			_fixed.group = selectableGroup;
			_fixed.move(0, slider.y);
			
			_background.addChild(_fixed);

			_dynamic.width = 350;
			_dynamic.label = "Dynamic Reaction - react stronger as a signal gets stronger.";
			_dynamic.value = "Dynamic";
			_dynamic.group = selectableGroup;
			_dynamic.move(0, _fixed.y + 65);
			_background.addChild(_dynamic);
			selectableGroup.selection = _fixed;

		}
		//this is the event listener for the dynamic radion button
		function handleDynamicReaction(event:Event):void{
			if_reaction = new DynamicReaction(this, ifArray[0], 100, 100);
			if_reaction.addEventListener("finishedReactions", finishedReactions);
		}
		//this is the eventListener for the selectableGroup (radio buttons)
		function changeHandler(event:Event):void
		{
			//checkDynamic();			
		}
		function CreateDataGrid(dg:DataGrid, xLoc:Number, yLoc:Number,
		dataName:String):void
		{
			var i:uint;
			var totalRows:uint = 5;
			dg.x = xLoc;
			dg.y = yLoc;
			dg.name = dataName;
			dg.setSize(400, 100);
			dg.columns = [dataName];


			var redX:Class = getDefinitionByName("red_X2") as Class;
			var red_X:Bitmap = new Bitmap(new redX());
			red_X.scaleX = 0.05;
			red_X.scaleY = 0.05;
			red_X.x = dg.x + dg.width + 10;
			red_X.y = dg.y;

			var container:MovieClip = new MovieClip();

			container.addChild(red_X);
			container.buttonMode = true;
			container.addEventListener(MouseEvent.CLICK,
			function(e:MouseEvent){DeleteFromList(e,dg)});
			_background.addChild(container);
			_background.addChild(dg);
		}



		//Deletes a selected item from the list
		function DeleteFromList(e:Event, dg:DataGrid):void
		{
			
			if (dg.selectedIndex > -1)
			{
				if (dg.dataProvider.length > 0)
				{
					dg.dataProvider.removeItemAt(dg.selectedIndex);
				}
			}
			if(dg.name == "Behavior During Trade")
			{
				//updateDecisionNames(behaviorInTradCondData, "Behavior");
			}
			if(dg.name == "Trade Exit Conditions", "Exit")
			{
				//updateDecisionNames(fullPositionCloseTradeCondData, "Exit");
			}
		}
		function dispatchFixed():void{
			dispatchEvent(new Event("fixed"));
		}
		function dispatchDynamic():void{
			dispatchEvent(new Event("dynamic"));
		}
	
		function setXML():XML
		{
			var myCondition_xml:XML = new XML(<Add/>);
			
			var arrayOfXML:Array = new Array();
			
			for(var dpIndex:Number = 0; dpIndex < behaviorInTradeDataProvider.length; dpIndex++)
			{
				myCondition_xml.appendChild(behaviorInTradeDataProvider.getItemAt(dpIndex).TheXML);
				//trace(arrayOfXML[dpIndex])
			}
			//myCondition_xml.appendChild(arrayOfXML);
			return myCondition_xml;
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
	
	}
}
