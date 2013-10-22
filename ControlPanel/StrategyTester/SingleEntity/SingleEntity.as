package ControlPanel.StrategyTester.SingleEntity {
	import ControlPanel.CommonFiles.Scroll.Main;
	import ControlPanel.StrategyTester.TradeEntities.*
	import ControlPanel.CommonFiles.Util.*
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.*;
	import flash.filters.*
	

	//Opened by an Entity of some sort
	public class SingleEntity extends MovieClip{	
		private var myType:Object;
		private var isComparedEntity:Boolean
		private var myStage:MovieClip;
		private var tradable:TradeTradable;
		private var indicator:TradeIndicator;
		private var time:TradeTime;
		private var portfolio:TradePortfolio;
		private var discriptionLabel:String;
		private var signalConditionXML:XML;
		private var strategy:Strategy;
		private var _HumanTradableEntity:String = "";
		private var _HumanTreatment:String = "";
		private var _HumanDatabase:String = "";
		private var _HumanMathOperator:String = "";
		private var _HumanOHLCVOperator:String = "";
		private var _HumancandleOperator:String = "";
		private var type:String = "";
		private var displayText:TextField;
		private var isCompared:Boolean;
		private var tblLogo:TBLLogo;
		private var indLogo:INDLogo;
		private var portLogo:PortfolioClip;
		private var timeLogo:TimeClip;
		private var inTrade:Boolean;
		
		
		public function SingleEntity(stage:MovieClip, isComparedEntity:Boolean, inTrade:Boolean = true, myType:Object = null) {
			this.myType = myType;
			this.isComparedEntity = isComparedEntity;
			this.inTrade = inTrade;
			myStage = stage;
			var textExit:TextField = new TextField();
			textExit.text = "[X]";
			textExit.autoSize = "center";
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.color = 0x0033CC;
			//myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			textExit.setTextFormat(myFormat);
			textExit.x = 2;
			textExit.y = 10;
			//textExit.mouseEnabled = true;
			
			var textExitClip:MovieClip = new MovieClip();
			textExitClip.addChild(textExit);
			textExitClip.mouseChildren = false;
			textExitClip.buttonMode = true;
			textExitClip.addEventListener(MouseEvent.CLICK, removeCondition);
			//addChild(textExitClip);
			if(!isComparedEntity){
			setIcons();
			
			}
			if(isComparedEntity){
				
				doTypedEntity();
			}
			
		}
		function doTypedEntity():void{
			
			if (myType is TradeIndicator) { 
				if(tradable){
					tradable.destroySelf()
				}
				
				indicator = new TradeIndicator(isComparedEntity);
				indicator.addEventListener("setXML", handleCondition)
				indicator.addEventListener("ComparedSingleEntityRemoved", handleComparedRemoved);
				indicator.addEventListener("ComparedSingleEntityAdded", handleComparedSingleEntityAdded);
				indicator.addEventListener("enableDone", activateDoneButton);
				//indicator.addEventListener("RemoveMe", handleRemove)
				myType = indicator;
				
				indicator.x -= 50;
				indicator.y += 20;
				//indicator.height = 500,
				addChild(indicator);
				
			}
					
			if (myType is TradeTradable){
				if(indicator){
					indicator.destroySelf();
				}
					tradable = new TradeTradable(isComparedEntity);
					tradable.addEventListener("setXML", handleCondition)
					tradable.addEventListener("CandleCreationComplete", handleCandle);
					//tradable.addEventListener("mathOpsSelected", handleMathOp);
					tradable.addEventListener("ComparedSingleEntityRemoved", handleComparedRemoved);
					tradable.addEventListener("ComparedSingleEntityAdded", handleComparedSingleEntityAdded);
					//tradable.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
					tradable.addEventListener("enableDone", activateDoneButton);
					//tradable.addEventListener("RemovedButtonClicked", removeInitialSingleEntity)
					//tradable.addEventListener("RemoveMe", handleRemove)
					tradable.x -= 50;
					tradable.y += 20;
					myType = tradable;
					addChild(tradable);
								
			}
			
		}
		function dispatchNewEvent(eventString:String):void{
			dispatchEvent(new Event(eventString));
		}
		function handleCandle(event:Event):void{
			
			dispatchNewEvent("CandleCreationComplete");
		}
		function activateDoneButton(event:Event):void{
			dispatchNewEvent("enableDone");
		}
		function handleComparedRemoved(event:Event):void{
			
			dispatchNewEvent("ComparedSingleEntityRemoved");
		}
		function handleComparedSingleEntityAdded(event:Event):void{
			dispatchNewEvent("ComparedSingleEntityAdded");
		}
		function handleCondition(event:CustomEvent):void{
			discriptionLabel = event.target.getInfoLabel();
			signalConditionXML = new XML(event.data);
			
			dispatchNewEvent("ConditionAdded");
		}
		public function updateFieldOptions():void{
			myType.updateFieldOptions();
		}
		public function removeRemoveClip():void{
			if(getChildByName("RemoveClip")){
			   removeChild(getChildByName("RemoveClip"));
			   }
		}
		function removeCondition(event:Event):void
		{
			parent.removeChild(this);
		}
		public function deactivatePortfolio():void{
			portLogo.enabled = false;
			portLogo.alpha = 0.2;
			portLogo.buttonMode = false;
			portLogo.removeEventListener(MouseEvent.CLICK, handleTBLINDSelection);
		}
		function setIcons():void{
			tblLogo = new TBLLogo();
			tblLogo.addEventListener(MouseEvent.CLICK, handleTBLINDSelection)
			addChild(tblLogo);
			tblLogo.name = "Tradable"
			tblLogo.buttonMode = true;
			tblLogo.x = 250;
			tblLogo.y = -30;
			
			indLogo = new INDLogo();
			indLogo.addEventListener(MouseEvent.CLICK, handleTBLINDSelection)
			indLogo.name = "Indicator"
			indLogo.buttonMode = true;
			indLogo.x = 355;
			indLogo.y = -30;
			addChild(indLogo);
			
			portLogo = new PortfolioClip();
			portLogo.addEventListener(MouseEvent.CLICK, handleTBLINDSelection)
			portLogo.name = "Portfolio"
			portLogo.buttonMode = true;
			portLogo.x = 460;
			portLogo.y = -30;
			addChild(portLogo);
			
			timeLogo = new TimeClip();
			timeLogo.addEventListener(MouseEvent.CLICK, handleTBLINDSelection)
			timeLogo.name = "Time"
			timeLogo.buttonMode = true;
			timeLogo.x = 570;
			timeLogo.y = -30;
			addChild(timeLogo);
			if(!inTrade){
				deactivatePortfolio();
			}
			
		}
		function handleTBLINDSelection(event:Event):void{
			var gFilter = new GlowFilter(0xFFFFDD, 1, 25, 25, 2, 2, false, false)
			var mc:MovieClip = event.target as MovieClip;
			switch (mc.name) {
				case "Indicator":		 
				removeAllEntities();
				tblLogo.filters = [];
				indLogo.filters = [gFilter];
				portLogo.filters = [];
				timeLogo.filters = [];
				indicator = new TradeIndicator(isComparedEntity);
				indicator.addEventListener("setXML", handleCondition)
				//indicator.addEventListener("CandleCreationComplete", handleCandle);
				indicator.addEventListener("ComparedSingleEntityRemoved", handleComparedRemoved);
				indicator.addEventListener("ComparedSingleEntityAdded", handleComparedSingleEntityAdded);
				indicator.addEventListener("enableDone", activateDoneButton);
				//indicator.addEventListener("RemoveMe", handleRemove)
				myType = indicator;
				
				//indicator.x += 15;
				indicator.y += 20;
				//indicator.height = 500,
				addChild(indicator);
					break;
				case "Tradable":
				removeAllEntities();
					tblLogo.filters = [gFilter];
					indLogo.filters = [];
					portLogo.filters = [];
					timeLogo.filters = [];
					tradable = new TradeTradable(isComparedEntity);
					tradable.addEventListener("setXML", handleCondition)
					tradable.addEventListener("CandleCreationComplete", handleCandle);
					tradable.addEventListener("ComparedSingleEntityRemoved", handleComparedRemoved);
					tradable.addEventListener("ComparedSingleEntityAdded", handleComparedSingleEntityAdded);
					tradable.addEventListener("enableDone", activateDoneButton);
					
					tradable.y += 20;
					myType = tradable;
					addChild(tradable);
					break;
					
				case "Time":
				removeAllEntities();
					tblLogo.filters = [];
					indLogo.filters = [];
					portLogo.filters = [];
					timeLogo.filters = [gFilter];

					time = new TradeTime(isComparedEntity, inTrade);
					time.addEventListener("setXML", handleCondition);
					time.addEventListener("enableDone", activateDoneButton);
					time.y += 20;
					myType = time;
					addChild(time);
					break;
				case "Portfolio":
				removeAllEntities();
					tblLogo.filters = [];
					indLogo.filters = [];
					portLogo.filters = [gFilter];
					timeLogo.filters = [];

					portfolio = new TradePortfolio(isComparedEntity);
					portfolio.addEventListener("setXML", handleCondition)
					
					portfolio.addEventListener("enableDone", activateDoneButton);
					portfolio.y += 20;
					myType = portfolio;
					addChild(portfolio);
					break;
			}
		}
		public function removeAllEntities():void{
			if(tradable){
			tradable.destroySelf();
			}
			if(indicator){
			indicator.destroySelf();
			}
			if(time){
			time.destroySelf();
			}
			if(portfolio){
			portfolio.destroySelf();
			}
			
			
			
		}
		public function getType():Object{
			return this.myType;
		}
		public function resetMathOps():void{
			myType.addMathOps();
			myType.formatDisplay();
		}
		public function setXML():Array
		{	
			
			return myType.setXML();
		}
		public function getConditionalEntityArray():Array{
			return myType.getConditionalEntityArray();
		}

	}
	
}
