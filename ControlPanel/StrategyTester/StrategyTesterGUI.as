package ControlPanel.StrategyTester
{
	import ControlPanel.CommonFiles.Util.*
	import ControlPanel.CommonFiles.CandleStick.*
	import ControlPanel.StrategyTester.TradeTrigger.*;
	import ControlPanel.StrategyTester.BehaviorInTrade.*;
	import ControlPanel.StrategyTester.CloseTrade.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.MouseEvent;
	import fl.controls.TextInput;
	import fl.controls.Label;
	import fl.controls.CheckBox;
	import fl.controls.List;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.DataGrid;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	import com.yahoo.astra.fl.controls.AutoComplete;
	import flash.display.Stage;
	import flashx.textLayout.elements.ListElement;
	import fl.events.ComponentEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.Bitmap;
	import flash.filters.*;
	import flash.display.*;
	import flash.utils.getDefinitionByName;
	import fl.events.*
	import adobe.utils.CustomActions;
	import fl.motion.CustomEase;
	import flash.net.*
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import fl.transitions.TweenEvent;
	import flash.text.TextFormat;
	import fl.controls.ProgressBar;
	import flash.xml.XMLDocument;
	import flash.geom.ColorTransform;
	import fl.controls.*
	
	
	
	


	public class StrategyTesterGUI extends MovieClip
	{
		
		public var customCandle:CustomCandle;
		public var tradeTrigger:TradeTrigger;
		public var behavEmerExit:CloseTrade;
		public var closeEmerExit:CloseTrade;
		public var fullPositionCloseTrade:CloseTrade;
		public var partialPositionCloseTrade:CloseTrade;
		private var behaviorInTrade:BehaviorInTrade;
		private var maxDaily:Number
		private var list:List;
		private var GO_CONTAIN:MovieClip;
		private var redXContainer2:MovieClip;
		private var greenCheckContainer:Sprite;
		private var i:int;
		
		
		private var isEntryActive:Boolean;
		private var isBehaviorActive:Boolean;
		private var isExitActive:Boolean;
		//private var isEntryActive:Boolean;
		private var navigationList:Array;
		private var setupHistory:Array;
		private var historyDisplay:Label;
		
		private var fullXML:XMLList;
		private var setUpXML:XMLList;
		private var behaviorXMLArray:Array;
		private var closeXMLArray:Array;
		private var closeXMLArray2:Array;
		public var xml:XML;
		public var myTimer:Timer;
		public var batchNo:Number;
		public var batchResponse:Boolean;
		private var pollCount:Number;
		private var _background:MovieClip;
		private var strategyScreens:Array;
		private var nav:MovieClip;
		private var hoverArrow:MovieClip;
		private var tradeEntrySetup:TradeEntrySetup;
		private var tradeEntrySetupHeader:MovieClip;
		private var tradeTriggerHeader:MovieClip;
		private var behaviorInTradeHeader:MovieClip;
		private var partialCloseEmExitHeader:MovieClip;
		private var partialCloseNormalExitHeader:MovieClip;
		private var fullCloseEmExitHeader:MovieClip;
		private var fullCloseNormalExitHeader:MovieClip;
		private var pushOutMC:MovieClip;
		private var sideNav:MovieClip;
		private var mainBox:MovieClip;
		private var progressBar:ProgressBar;
		private var mySharedObject:SharedObject = SharedObject.getLocal("PreviousXMLFiles");
		private var headerArray:Array;
		

		//public var batchNo:Number;

		public function StrategyTesterGUI()
		{
			pushOutMC = new MovieClip();
			sideNav = new MovieClip();
			mainBox = new MovieClip();
			headerArray = new Array();
			drawBackground();
			this.placeImage(hoverArrow = new MovieClip, "hoverArrow.png", hover, _background, 0.5);
			progressBar = new ProgressBar();
			
			hoverArrow.alpha = 0;
			batchResponse  = false;
			
			myTimer  = new Timer(5000, 0)
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			//myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			//^^^^"THIS IS THE TIMER" ^^^^	
			
			/*setupHistory = new Array();
			isEntryActive = true;
			isBehaviorActive = false;
			
			isExitActive = false;
			i = 1;
			
			behaviorXMLArray = new Array();
			closeXMLArray = new Array();
			closeXMLArray = new Array();


			behaviorInTradCondData = new DataProvider();
			fullPositionCloseTradeCondData = new DataProvider();
			partialPositionCloseTradeCondData = new DataProvider();
			tradeEntryCondData = new DataProvider();
			exitTradeCondData = new DataProvider();
			emerExitTradeCondData = new DataProvider();

			*/
			drawMainBox();
			createNav();
			//Trade Entry Setup//
			tradeEntrySetup = new TradeEntrySetup(200, 200);
			
			tradeEntrySetup.addEventListener("setUpXMLReady", handleSetUpXMLReady);
			tradeEntrySetup.addEventListener("maxDailySet", handleMaxDaily);
			tradeEntrySetup.x = -25;
			tradeEntrySetup.y =  19;
			mainBox.addChild(tradeEntrySetup);
			tradeEntrySetupHeader.InfoClip.DisplayClass = tradeEntrySetup;
			
			////Trade Entry Setup//
			
			_background.scaleX = 0.8;
			_background.scaleY = 0.8;
			
			
			
			//nav.alpha = 0;
			loadSavedXML();
			//addCircleToNavClip("Trade Trigger");
		}
		
		function minimize(event:Event):void{
			
			this.buttonMode = true;
			var tweenScaleXDown:Tween = new Tween(this, "scaleX", None.easeNone, this.scaleX, 0.1, 1, true)
			var tweenScaleYDown:Tween = new Tween(this, "scaleY", None.easeNone, this.scaleY, 0.1, 1, true)
			tweenScaleYDown.addEventListener(TweenEvent.MOTION_FINISH, addClick)

		}
		function addClick(event:TweenEvent):void{
			this.addEventListener(MouseEvent.CLICK, maximize);
		}
		function maximize(event:Event):void{

			removeEventListener(MouseEvent.CLICK, maximize);
			var tween2:Tween = new Tween(this, "scaleX", None.easeNone, this.scaleX, 1, 1, true)
			var tween2_1:Tween = new Tween(this, "scaleY", None.easeNone, this.scaleY, 1, 1, true)
			this.buttonMode = false;
		}
		function drawBackground():void{
			_background = new MovieClip();
			addChild(_background);
			
		}
		function engineStart():void{
			
			
			behavEmerExit = new CloseTrade(mainBox, 75, 500, maxDaily, "Trade Exit (Emergency)", "user1", "EmEx");
			behavEmerExit.addEventListener("DataSet", checkDataSet);
			behavEmerExit.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			partialCloseEmExitHeader.InfoClip.DisplayClass = behavEmerExit;
			
			
			mainBox.addChild(behavEmerExit);
			closeEmerExit = new CloseTrade(mainBox, 75, 500, maxDaily, "Full Position Trade Exit (Emergency)", "user1", "EmEx")
			closeEmerExit.addEventListener("DataSet", checkDataSet);
			closeEmerExit.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			mainBox.addChild(closeEmerExit);
			fullCloseEmExitHeader.InfoClip.DisplayClass = closeEmerExit;
			//Custom Candle//
			customCandle = new CustomCandle();
			//Custom Candle//
			
			//BehaviorInTrade//
			behaviorInTrade = new BehaviorInTrade(mainBox, 100, 500, maxDaily);
			behaviorInTrade.setMaxDaily(maxDaily);
			//behaviorInTrade.addEventListener("BehaviorInTradeDecisionMade", inTradeDecisionMade);
			behaviorInTrade.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			behaviorInTrade.addEventListener("DataSet", checkDataSet);
			behaviorInTrade.x = 75;
			behaviorInTrade.y = 119;
			//behaviorInTrade.scaleX = 0.9;
			//behaviorInTrade.scaleY = 0.9;
			mainBox.addChild(behaviorInTrade);
			behaviorInTradeHeader.InfoClip.DisplayClass = behaviorInTrade;
			
			//BehaviorInTrade//
			
			//TradeTrigger//
			tradeTrigger = new TradeTrigger(mainBox, 100, 500, maxDaily);
			//_background.addChild(tradeTrigger);
			
			tradeTrigger.addEventListener("DataSet", checkDataSet);
			tradeTrigger.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			tradeTrigger.x = 75;
			tradeTrigger.y = 119;
			tradeTriggerHeader.InfoClip.DisplayClass = tradeTrigger;
			
			mainBox.addChild(tradeTrigger);
			//TradeTrigger//
			//CloseTrade//
			fullPositionCloseTrade = new CloseTrade(mainBox, 75, 500, maxDaily, "Full Position Trade Exit (Expected)");
			fullPositionCloseTrade.addEventListener("DataSet", checkDataSet);
			fullPositionCloseTrade.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			
			mainBox.addChild(fullPositionCloseTrade);
			fullCloseNormalExitHeader.InfoClip.DisplayClass = fullPositionCloseTrade;
			//CloseTrade
			
			partialPositionCloseTrade = new CloseTrade(mainBox, 75, 500, maxDaily, "Trade Exit (Expected)");
			partialPositionCloseTrade.addEventListener("DataSet", checkDataSet);
			partialPositionCloseTrade.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			mainBox.addChild(partialPositionCloseTrade);
			partialCloseNormalExitHeader.InfoClip.DisplayClass = partialPositionCloseTrade;
			
			nav.alpha = 1;
			var iniTween:Tween = new Tween(hoverArrow, "x", Bounce.easeOut,hoverArrow.x, tradeTriggerHeader.x + 180,1, true)
			hoverArrow.alpha = 1;
			collapseAll();
			tradeTrigger.expandMe();

		}
		function handleIsReadyForStrat(event:Event):void{
			var mc:MovieClip = nav.getChildByName(event.target.name) as MovieClip
			var myColor:ColorTransform = mc.InfoClip.transform.colorTransform;
				myColor.color = 0x7CFC00;
				mc.InfoClip.transform.colorTransform = myColor;
		}
		function checkDataSet(event:CustomEvent):void{
			
			var canMoveForward:Boolean = event.target.getIsData();
			var mc:MovieClip = nav.getChildByName(event.target.name) as MovieClip
			var myColor:ColorTransform = mc.InfoClip.transform.colorTransform;
			if(canMoveForward){
				myColor.color = 0xFBEC5D;
			}
			if(!canMoveForward){
				myColor.color = 0xFF0000;
			}
			//nav.getChildByName(event.target.name).InfoClip
			
			
			mc.InfoClip.transform.colorTransform = myColor;
			//addCircleToNavClip(event.data);
		}
		function addTriangleToNavClip():MovieClip{
			
			var triangleHeight:uint = 10;
			var triangleShape:MovieClip = new MovieClip();
			
			triangleShape.graphics.beginFill(0x000000);
			triangleShape.graphics.moveTo(0, 0);
			triangleShape.graphics.lineTo(triangleHeight, triangleHeight);
			triangleShape.graphics.lineTo(0, triangleHeight);
			return triangleShape;;
		}
		function loadSavedXML():void{
			/*if(mySharedObject.data.XML){
				trace("This is the loaded data from a previous XML")
				trace(mySharedObject.data.XML)
				trace("This is the loaded data from a previous XML")
			}
			if(mySharedObject.data.Strategy){
				trace("This is the loaded Strategy data from a previous XML")
				trace(mySharedObject.data.Strategy)
				trace("This is the loaded Strategy data from a previous XML")
			}*/
		}
		function hover(event:Event):void{
			//trace("hover");
		}
		function setHeaderText(stage:MovieClip, _headerClip:MovieClip, headerDescription:String, xLoca:Number = 0, yLoca:Number = 0):void
		{
			//_headerClip = new MovieClip();
			var headerText:TextField = new TextField();
			var myFormat:TextFormat = new TextFormat();
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			headerText.defaultTextFormat = myFormat;
			headerText.textColor = 0x000000;
			headerText.text = headerDescription;
			headerText.autoSize = "center";
			_headerClip.buttonMode = true;
			_headerClip.graphics.lineStyle(1, 0x6D7B8D);
			_headerClip.graphics.beginFill(0xC0C0C0);
			_headerClip.graphics.drawRect(xLoca, yLoca,headerText.width + 20,25);
			_headerClip.mouseChildren = false;
			_headerClip.x = xLoca + 10;
			_headerClip.y = yLoca;
			_headerClip.name = headerDescription;
			//headerClip.addEventListener(MouseEvent.CLICK, expandHeader);
			_headerClip.addChild(headerText);
			headerText.x = _headerClip.x
			headerText.y = _headerClip.y;
			_headerClip.addEventListener(MouseEvent.CLICK, callNavArrow)
			headerArray.push(_headerClip)
			var infoClip:MovieClip = addTriangleToNavClip();
			
			infoClip.y = _headerClip.y + 15.5;
			_headerClip.InfoClip = infoClip;
			//_headerClip.addChild(infoClip)
			
			
			stage.addChild(_headerClip);
			////trace(headerClip.width + "<---" + headerDescription)
		}
		function handleXMLDisplay(event:Event):void{
			displayXML(event.currentTarget.DisplayClass.setXML(), mouseX, mouseY + 10)
			event.currentTarget.addEventListener(MouseEvent.CLICK, closeDisplayXML);
			event.currentTarget.removeEventListener(MouseEvent.CLICK, handleXMLDisplay);
			}
		function closeDisplayXML(event:Event):void{
			if(getChildByName("XML Display Box")){
				removeChild(getChildByName("XML Display Box"));
			}
			event.currentTarget.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			event.currentTarget.removeEventListener(MouseEvent.CLICK, closeDisplayXML);
		}
		function createNav():void{
			nav = new MovieClip();
			
			var tempMC:Sprite = new Sprite;
			var tempWidth:Number;
			
			
			setHeaderText(nav, tradeEntrySetupHeader = new MovieClip(), "Trade Setup", -8);
			tradeEntrySetupHeader.InfoClip.x -= 5
			tradeEntrySetupHeader.InfoClip.buttonMode = true;
			tradeEntrySetupHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			nav.addChild(tradeEntrySetupHeader.InfoClip)
			
			
			setHeaderText(nav, tradeTriggerHeader = new MovieClip(), "Trade Trigger", 40);
			tradeTriggerHeader.InfoClip.x = tradeTriggerHeader.x + 41
			tradeTriggerHeader.InfoClip.DisplayClass = tradeTrigger;
			tradeTriggerHeader.InfoClip.buttonMode = true;
			tradeTriggerHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			nav.addChild(tradeTriggerHeader.InfoClip)
			
			//tradeTriggerHeader.InfoClip.DisplayClass = behaviorInTrade;
			
			
			
			setHeaderText(nav, behaviorInTradeHeader = new MovieClip, "Behavior In Trade", 92);
			behaviorInTradeHeader.InfoClip.x += behaviorInTradeHeader.x + 93
			
			behaviorInTradeHeader.InfoClip.buttonMode = true;
			nav.addChild(behaviorInTradeHeader.InfoClip)
			behaviorInTradeHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			
			setHeaderText(nav, partialCloseEmExitHeader = new MovieClip, "Trade Exit (Emergency)", 232);
			partialCloseEmExitHeader.InfoClip.x += 482
			partialCloseEmExitHeader.InfoClip.DisplayClass = behavEmerExit;
			
			partialCloseEmExitHeader.InfoClip.buttonMode = true;
			nav.addChild(partialCloseEmExitHeader.InfoClip)
			partialCloseEmExitHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			
			setHeaderText(nav, partialCloseNormalExitHeader = new MovieClip, "Trade Exit (Expected)", 156);
			partialCloseNormalExitHeader.InfoClip.x += 322
			
			partialCloseNormalExitHeader.InfoClip.buttonMode = true;
			nav.addChild(partialCloseNormalExitHeader.InfoClip)
			partialCloseNormalExitHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			
			setHeaderText(nav, fullCloseEmExitHeader = new MovieClip, "Full Position Trade Exit (Emergency)", 432);
			fullCloseEmExitHeader.InfoClip.x += 875
			
			nav.addChild(fullCloseEmExitHeader.InfoClip)
			fullCloseEmExitHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			
			setHeaderText(nav, fullCloseNormalExitHeader = new MovieClip, "Full Position Trade Exit (Expected)", 315);
			fullCloseNormalExitHeader.InfoClip.x += 641
			
			fullCloseEmExitHeader.InfoClip.buttonMode = true;
			fullCloseNormalExitHeader.InfoClip.buttonMode = true;
			nav.addChild(fullCloseNormalExitHeader.InfoClip)
			fullCloseNormalExitHeader.InfoClip.addEventListener(MouseEvent.CLICK, handleXMLDisplay);
			
			hoverArrow.x = tradeTriggerHeader.x + 75
			//tradeTrigger.expandMe();
			
			this.hoverArrow.y = 685;
			/*for each(var obj:Object in strategyScreens){
				obj.addEventListener(MouseEvent.CLICK, navigationArrowHandler);
			}*/
			nav.x = 100;
			nav.y = 650;
			AddDropShadow(nav);
			_background.addChild(nav);
			
			tradeEntrySetupHeader.addEventListener(MouseEvent.CLICK, handleTradeEntryHeaderIn);
			tradeTriggerHeader.addEventListener(MouseEvent.CLICK, tradeTriggerHeaderIn);
			behaviorInTradeHeader.addEventListener(MouseEvent.CLICK, behaviorInTradeHeaderIn);
			partialCloseEmExitHeader.addEventListener(MouseEvent.CLICK, partialCloseEmExitHeaderIn);
			partialCloseNormalExitHeader.addEventListener(MouseEvent.CLICK, partialCloseNormalExitHeaderIn);
			fullCloseEmExitHeader.addEventListener(MouseEvent.CLICK, fullCloseEmExitHeaderIn);
			fullCloseNormalExitHeader.addEventListener(MouseEvent.CLICK, fullCloseNormalExitHeaderIn);
		}
		function drawMainBox():void{
			
			
			mainBox.graphics.lineStyle(1, 0x6D7B8D);
			mainBox.graphics.beginFill(0xFFFFFF, 1);
			mainBox.graphics.drawRect(75,70,901,450);
			mainBox.graphics.endFill();
			
			placeImage(pushOutMC, "pushOut.png", pushOut,  mainBox, 0.15, 975, 300)
			
			
			addChild(mainBox);
			
			drawSideNav();
		}
		function setMainBoxClips():void{
			var dropShadow:DropShadowFilter = new DropShadowFilter(/*16,45,20,0.5, 20.0, 20.0,1.0*/)
			var minimizeSTester:MovieClip = new MovieClip;
			sideNav.addChild(minimizeSTester);
			minimizeSTester.graphics.lineStyle(1, 0x6D7B8D);
			minimizeSTester.graphics.beginFill(0xFFFFFF, 1);
			//minimizeSTester.graphics.drawRect(875,119.5,100,100);
			minimizeSTester.graphics.endFill();
			var mini:MovieClip = new MinArrow();
			mini.scaleX = 0.6;
			mini.scaleY = 0.6;
			mini.x = 792;
			mini.y = 0;
			mini.addEventListener(MouseEvent.CLICK, minimize);
			mini.filters = [dropShadow]
			mini.buttonMode = true;
			minimizeSTester.addChild(mini);
			
			
			var exitSTester:MovieClip = new MovieClip;
			sideNav.addChild(exitSTester);
			exitSTester.graphics.lineStyle(1, 0x6D7B8D);
			exitSTester.graphics.beginFill(0xFFFFFF, 1);
			
			exitSTester.graphics.endFill();
			var exit:MovieClip = new Exit();
			exit.scaleX = 0.6;
			exit.scaleY = 0.6;
			exit.x = 922;
			exit.y = 90;
			exit.addEventListener(MouseEvent.CLICK, exitMe);
			exit.filters = [dropShadow]
			exit.buttonMode = true;
			exitSTester.addChild(exit);
			
			
			var resetSTester:MovieClip = new MovieClip;
			sideNav.addChild(resetSTester);
			resetSTester.graphics.lineStyle(1, 0x6D7B8D);
			resetSTester.graphics.beginFill(0xFFFFFF, 1);
			//resetSTester.graphics.drawRect(875,319.5,100,100);
			resetSTester.graphics.endFill();
			var _refresh:MovieClip = new Refresh();
			_refresh.scaleX = 0.8;
			_refresh.scaleY = 0.8;
			_refresh.x = 825;
			_refresh.y = 300
			_refresh.addEventListener(MouseEvent.CLICK, refreshMe);
			_refresh.filters = [dropShadow]
			_refresh.buttonMode = true;
			resetSTester.addChild(_refresh);
			
			
			var submitStrategy:MovieClip = new MovieClip;
			sideNav.addChild(submitStrategy);
			submitStrategy.graphics.lineStyle(1, 0x6D7B8D);
			submitStrategy.graphics.beginFill(0xFFFFFF, 1);
			//submitStrategy.graphics.drawRect(875,419.5,100,100);
			submitStrategy.graphics.endFill();
			var _submit:MovieClip = new SubmitCheck();
			//_submit.scaleX = 0.4;
			//_submit.scaleY = 0.4;
			_submit.x = 865;
			_submit.y = 400;
			_submit.addEventListener(MouseEvent.CLICK, submitQuery);
			_submit.filters = [dropShadow]
			_submit.buttonMode = true;
			submitStrategy.addChild(_submit);
			
			var viewXML:MovieClip = new Glasses;
			sideNav.addChild(viewXML);
			viewXML.scaleX = 0.3;
			viewXML.scaleY = 0.3;
			viewXML.x = 910;
			viewXML.y = 180;
			viewXML.addEventListener(MouseEvent.CLICK, viewFinalXML);
			viewXML.filters = [dropShadow]
			viewXML.buttonMode = true;
			
			var saveXML:MovieClip = new SaveDiskMC;
			sideNav.addChild(saveXML);
			saveXML.scaleX = 0.7;
			saveXML.scaleY = 0.7;
			saveXML.x = 775;
			saveXML.y = 115;
			saveXML.addEventListener(MouseEvent.CLICK, handleSaveXML);
			saveXML.filters = [dropShadow]
			saveXML.buttonMode = true;
			
			var openXML:MovieClip = new OpenFolderMC;
			sideNav.addChild(openXML);
			openXML.scaleX = 0.6;
			openXML.scaleY = 0.6;
			openXML.x = 850;
			openXML.y = 260;
			openXML.addEventListener(MouseEvent.CLICK, handleOpenXML);
			openXML.filters = [dropShadow]
			openXML.buttonMode = true;
		}
		function displayXML(xmlFile:XMLList, xLoca:Number = 150, yLoca:Number = 100):void{ 
			
			if(getChildByName("XML Display Box")){
				removeChild(getChildByName("XML Display Box"));
			}
			var xmlText:TextField;
			var boldText:TextFormat = new TextFormat();
			with (boldText) {
				font = "Calibri";
				size = 12;
				color = 0x000000;
				//bold = true;
			}
			xmlText = new TextField
		
			with(xmlText){
				autoSize = "left";
				width = 300;
				//height = 200;
				multiline  = true;
				textColor = 0xFFFFFF1
				text = xmlFile.toXMLString()
				setTextFormat(boldText)
			}
			xmlText.y = yLoca;
			xmlText.x = xLoca;
			
		
			var xmlDisplayBox:MovieClip = new MovieClip;
			
			xmlDisplayBox.name = "XML Display Box";
			with(xmlDisplayBox){
				graphics.beginFill(0xFFFFFF, 1)
				graphics.lineStyle(1);
				graphics.drawRoundRect(xLoca, yLoca, xmlText.width, xmlText.height, 10, 10)
				graphics.endFill();
			}
			xmlDisplayBox.addChild(xmlText);
			
			
			
			
			/*var mySb:UIScrollBar = new UIScrollBar(); 
			mySb.direction = "vertical"; 
			// Size it to match the text field. 
			mySb.setSize(xmlDisplayBox.width, xmlDisplayBox.height - 5); 
			 
			// Move it immediately below the text field. 
			mySb.move(xmlDisplayBox.width + xmlDisplayBox.x - 20, xmlDisplayBox.y - 5);
			 
			//puut it on stage
			xmlDisplayBox.addChild(mySb);
			 // Set nameTxt as target for scroll bar. 
			 mySb.scrollTarget = xmlDisplayBox;  */
			
			
			var closeXButton:CloseXButton = new CloseXButton();
			
			//xmlDisplayBox.addChild(closeXButton)
			closeXButton.buttonMode = true;
			closeXButton.x = xLoca + xmlDisplayBox.width/2 + 23
			
			closeXButton.y = yLoca;
			//_closeButton.x = xmlDisplayBox.width - 125;
			//_closeButton.move(xmlDisplayBox.width - 125, xmlDisplayBox.height - 45)
			closeXButton.addEventListener(MouseEvent.CLICK, removeXMLDisplayBox);
			addChild(xmlDisplayBox);
			
		}
		function removeXMLDisplayBox(event:Event):void{
			removeChild(event.target.parent);
		}
		function viewFinalXML(event:Event):void{
			displayXML(setFullXML(), mouseX + 50, mouseY - 50);
			event.currentTarget.removeEventListener(MouseEvent.CLICK, viewFinalXML);
			event.currentTarget.addEventListener(MouseEvent.CLICK, closeFinalXML);
		}
		function handleSaveXML(event:Event):void{
			trace("This should save the XML")
		}
		function handleOpenXML(event:Event):void{
			trace("This should open the XML")
		}
		function closeFinalXML(event:Event):void{
			
			if(getChildByName("XML Display Box")){
				removeChild(getChildByName("XML Display Box"));
			}
			event.currentTarget.addEventListener(MouseEvent.CLICK, viewFinalXML);
			event.currentTarget.removeEventListener(MouseEvent.CLICK, closeFinalXML);
			
		}
		function refreshMe(event:Event):void{
			//trace("refresh")
		}
		function exitMe(event:Event):void{
			removeChild(this._background);
			removeChild(this.mainBox);
			removeChild(this.sideNav);
			if(getChildByName("XML Display Box")){
				removeChild(getChildByName("XML Display Box"));
			}
		}
		function pushOut(event:Event):void{
			
			var sideNavOut:Tween = new Tween(sideNav, "x", Strong.easeOut, sideNav.x, sideNav.x + 100, 0.5, true)
			pushOutMC.rotationY = 180;			
			pushOutMC.x = pushOutMC.x + pushOutMC.width;
			pushOutMC.removeEventListener(MouseEvent.CLICK, pushOut)
			pushOutMC.addEventListener(MouseEvent.CLICK, pushIn)
			
			
		}
		function pushIn(event:Event):void{
			var sideNavIn:Tween = new Tween(sideNav, "x", Strong.easeInOut, sideNav.x, sideNav.x - 100, 0.5, true)
			pushOutMC.rotationY = 360;
			pushOutMC.x = pushOutMC.x - pushOutMC.width;
			pushOutMC.addEventListener(MouseEvent.CLICK, pushOut)
			pushOutMC.removeEventListener(MouseEvent.CLICK, pushIn)
		}
		function drawSideNav():void{
			
			
			sideNav.graphics.lineStyle(1, 0x6D7B8D);
			sideNav.graphics.beginFill(0xFFFFFF, 1);
			sideNav.graphics.drawRect(875,70.5,100,450);
			sideNav.graphics.endFill();
			addChildAt(sideNav, getChildIndex(this.mainBox));
			setMainBoxClips();
		}
		function handleTradeEntryHeaderIn(event:Event):void{
			collapseAll();
			tradeEntrySetup.expandMe();
		}
		
		
		function tradeTriggerHeaderIn(event:Event):void{
			collapseAll();
			tradeTrigger.expandMe();
			
		}
		
		function behaviorInTradeHeaderIn(event:Event):void{
			collapseAll();
			behaviorInTrade.expandMe();
		}
		
		function partialCloseEmExitHeaderIn(event:Event):void{
			collapseAll();
			behavEmerExit.expandMe();	
		}
		
		function partialCloseNormalExitHeaderIn(event:Event):void{
			collapseAll();
			partialPositionCloseTrade.expandMe();			
		}
		
		function fullCloseEmExitHeaderIn(event:Event):void{
			collapseAll();
			closeEmerExit.expandMe();

		}
		function fullCloseNormalExitHeaderIn(event:Event):void{
			collapseAll();
			//test;
			fullPositionCloseTrade.expandMe();
		}
		function callNavArrow(event:MouseEvent):void{
			//this.hoverArrow.x = event.target.x * 2 - 2
			var xMove:Number = (event.target.x * 2)+(event.target.width/2)
			var tween:Tween = new Tween(hoverArrow, "x", Bounce.easeOut,hoverArrow.x, xMove + 80, 1, true)
			
			//this.hoverArrow.y = 350;
		}
		function collapseAll():void{
			tradeEntrySetup.collapseMe();
			tradeTrigger.collapseMe();
			behavEmerExit.collapseMe();
			behaviorInTrade.collapseMe();
			closeEmerExit.collapseMe();
			fullPositionCloseTrade.collapseMe();
			partialPositionCloseTrade.collapseMe();
		}
		function handleMaxDaily(event:CustomEvent):void{
			maxDaily = event.data
			engineStart();
			//here set whatever mech you create to display the other forms to display after max daily has been set
			
			
		}
		function handleSetUpXMLReady(event:CustomEvent):void{
			setUpXML = event.data
			var mc:MovieClip = nav.getChildByName("Trade Setup") as MovieClip
			var myColor:ColorTransform = mc.InfoClip.transform.colorTransform;
				myColor.color = 0x7CFC00;
				mc.InfoClip.transform.colorTransform = myColor;
		}
		function setFullXML():XMLList{
			
			
			fullXML = new XMLList(<Strategy/>)
                                
            fullXML.appendChild(setUpXML);
			
			var getinXML:XML = new XML(<GetIn/>);
			
			getinXML.appendChild(tradeTrigger.setXML())
			
			
			var behavXMLConds:XML = new XML(behaviorInTrade.setXML());
			//var bitEmEx:XML = new XML(behavEmerExit.setXML());
			var bitEmEx:XML = new XML(<EmEx/>)
			bitEmEx.appendChild(behavEmerExit.setXML());
			trace(bitEmEx);
			behavXMLConds.appendChild(bitEmEx);
			var bitClose:XML = new XML(<Close/>)
			bitClose.appendChild(partialPositionCloseTrade.setXML());
			behavXMLConds.appendChild(bitClose);
			
			var getOutXML:XML = new XML(<GetOut/>)
			var getOutNormal = new XML(<Close/>);
			getOutNormal.appendChild(fullPositionCloseTrade.setXML());
			getOutXML.appendChild(getOutNormal);
		
			var getOutEmer = new XML(<EmEx/>);
			getOutEmer.appendChild(closeEmerExit.setXML());
			
			
			getOutXML.appendChild(getOutEmer);
			
			
		
			//behavXMLConds.appendChild(partialPositionCloseTrade.setXML());
			
			
			/*var closeEmEx:XML = new XML(closeEmerExit.setXML())
			
			

			var getOutXML:XML = new XML(<GetOut/>)
			
			
			for(var i = 0; i < closeXMLArray.length; i++)
			{
					getOutXML.appendChild(closeXMLArray[i]);
			}
			
			 
			
			
			
			
			
			getOutXML.appendChild(closeEmEx);
			getOutXML.appendChild(this.fullPositionCloseTrade.setXML());*/
			
			fullXML.appendChild(getinXML);
			fullXML.appendChild(behavXMLConds);
			fullXML.appendChild(getOutXML);
			
			//fullXML.appendChild(bahaviorXML);
			//fullXML.appendChild(getOutXML);
			return fullXML;
		}
		/*/*adds the behaviorInTrade decision to the datagrid "behavior in trade" datagrid. Needs to be broken down into single decision. 
		 *The custom event's data property contains the xml structure for the behaviorInTrade decision(Root = <Add>). 
		*/
		/*
		function inTradeDecisionMade(event:CustomEvent):void{
			
			var todaysDate:Date = new Date();
			
			behaviorInTradCondData.addItem({"Behavior During Trade": "Behavior in Trade Decision @ " + todaysDate.toLocaleTimeString(), Decision: event.data, Clip: behaviorInTrade});
			
			_background.removeChild(behaviorInTrade);
			behaviorInTrade = new BehaviorInTrade(mainBox, 100, 500, maxDaily);	
			behaviorInTrade.addEventListener("BehaviorInTradeDecisionMade", inTradeDecisionMade);
			_background.addChild(behaviorInTrade);
			behaviorInTrade.setMaxDaily(maxDaily);
		}
		
	*/
		
		
		function placeImage(_container:MovieClip, _className:String,
		_function:Function,  _stage:MovieClip, scale:Number = 1, xLoca:Number = 0, yLoca:Number = 0):void
		{
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());

			_container.name = _className;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.scaleX = scale;
			_container.scaleY = scale;
			
			_container.addEventListener(MouseEvent.CLICK, _function);
			_container.x = xLoca;
			_container.y = yLoca;
			
			_stage.addChild(_container);

		}
		function AddDropShadow(mClip:MovieClip):void
		{
			var filter = new DropShadowFilter();
			mClip.filters = [filter];
		}
		/*function submitQuery(e:Event):void{
			
			var xmlURL:URLLoader = new URLLoader(new URLRequest("C:/Users/Programmer2/Desktop/strategy_vix_mac.xml"))
			xmlURL.addEventListener(Event.COMPLETE, xmlDownloaded);
			addEventListener("ReadyToPoll", pullRequest);
		}
		*/
		function submitQuery(e:Event):void
		{
			 //to do setFullXML() to a value;
			xml = new XML(setFullXML())
			mySharedObject.data.Strategy = xml;
			
			pullRequest();
			
			
			
			var date:Date = new Date;
			trace("-------------------------------------- Submitted the Strategy @ "  + date.toTimeString() + "----------------------------------------");
			
		}
		
		
		
		
		
		function pullRequest():void{
			
			var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/TestTheory" + "?rand=" +(Math.random()*1000000000).toString());
			trace("-------------------------------------- The Query submitted was " + xmlScriptLoader.url + "----------------------------------------");
			xmlScriptLoader.data = xml;
			trace(xml)
			xmlScriptLoader.contentType = "text/xml";
			xmlScriptLoader.method = URLRequestMethod.POST;
			
			var xmlLoader:URLLoader = new URLLoader();
	
			xmlLoader.addEventListener(Event.COMPLETE, handleXMLLoad)
			xmlLoader.load(xmlScriptLoader)
		}
		function handleXMLLoad(event:Event):void{
			pollCount = 0;
			batchNo = Number(event.target.data);
			myTimer.start();
			
			//addProgressBar(350,250);
		}
		
		function checkBatchReady(_batchNo:Number):void{
			pollCount++;
			var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/BatchRespond?id=" +_batchNo+ "&rand=" + (Math.random()*1000000000).toString());
			//var xmlScriptLoader:URLRequest = new URLRequest("C:/Users/Programmer2/Desktop/screenTest.xml");
			xmlScriptLoader.contentType = "text/xml";
			xmlScriptLoader.method = URLRequestMethod.POST;
			
			var xmlLoader2:URLLoader = new URLLoader();
			
			xmlLoader2.addEventListener(Event.COMPLETE, handleBatchRespondReady)
			
			xmlLoader2.load(xmlScriptLoader)
			trace(xmlScriptLoader.url + " -----Batch # " + _batchNo + "------");
			trace("---------------------Poll count is # " + pollCount + "--------------------------------");
			function handleBatchRespondReady(event:Event):void{
				
				var urlLoad:URLLoader = event.target as URLLoader;
						
				var ready_true:XML = new XML(event.target.data);	
				trace(ready_true.ready);
				
				/*var readyTrueSplit:Array = ready_true.split("-");
				//progressBar.setProgress(readyTrueSplit[0], 100);*/
				
			
				if(batchReady(ready_true.ready)){
					trace("batch is ready")
					myTimer.stop();
					var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/GetStrategyResult?id=" +_batchNo+ "&rand=" + (Math.random()*1000000000).toString());
					xmlScriptLoader.contentType = "text/xml";
					xmlScriptLoader.method = URLRequestMethod.POST;
					
					var xmlLoader2:URLLoader = new URLLoader();
					
					xmlLoader2.addEventListener(Event.COMPLETE, handleStrategyReady)
					xmlLoader2.load(xmlScriptLoader)
					
				}
				
			}
		
		}
		function handleStrategyReady(event:Event):void{
			var xmlDoc:XMLDocument = new XMLDocument(event.target.data)
			//var xml:XML = new XML(event.target.data)
			
			dispatchResults(event.target.data);
			
			
				mySharedObject.data.XML = xmlDoc;
				//mySharedObject.data.lastName = "Doe";
				mySharedObject.flush();
		}
		function batchReady(isReady:String):Boolean{
			
			if(isReady == "true")
			{
				return true;
			}
			else
			{
				return false;
			}
			
		}
	
		function timerHandler(event:Event):void{
			checkBatchReady(batchNo);
		}
		
		function addProgressBar(xloca:Number, yloca:Number):void{
			progressBar.move(xloca, yloca);
			progressBar.height = 20;
			progressBar.mode = "manual";
			progressBar.addEventListener(Event.COMPLETE, handleProgressComplete);
			addChild(progressBar);
			var filter:BlurFilter = new BlurFilter()
			_background.filters = [filter];
		}
		function handleProgressComplete(event:Event = null):void{
			var bgFArray:Array = _background.filters;
			for(var bgFArrayIndex:int = 0; bgFArrayIndex < bgFArray.length; bgFArrayIndex++){
			}
			
		}
		
		function dispatchResults(_result:String):void{
			dispatchEvent(new CustomEvent("ResultReady", _result));
			
		}

	}
}