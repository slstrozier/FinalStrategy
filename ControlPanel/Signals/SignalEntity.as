package ControlPanel.Signals{
	import flash.display.MovieClip;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import flash.events.*;
	import flash.text.*
	import flash.filters.*;
	import ControlPanel.CommonFiles.Util.*
	//Opened by a SignalBuilder
	public class SignalEntity extends MovieClip{

		private var myStage:MovieClip;
		private var _background:MovieClip;
		private var tradable:SignalTradable;
		private var indicator:SignalIndicator;
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
		private var myType:Object;
		private var isComparedEntity:Boolean
		private var tblLogo:TBLLogo;
		private var indLogo:INDLogo;
		
		//Called by a SignalEntityBuilder
		public function SignalEntity(stage:MovieClip, isComparedEntity:Boolean, myType:Object = null) {
			strategy = Strategy.getInstance();
			this.isComparedEntity = isComparedEntity;
			myStage = stage;
			//drawBackground();
			
			//isCompared = new Boolean();
			this.myType = myType;
			
			//createRadioButtons();
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
			textExit.x = 825;
			textExit.y = 25;
			//textExit.mouseEnabled = true;
			
			var textExitClip:MovieClip = new MovieClip();
			textExitClip.addChild(textExit);
			textExitClip.mouseChildren = false;
			textExitClip.buttonMode = true;
			textExitClip.addEventListener(MouseEvent.CLICK, removeCondition);
			addChild(textExitClip);
			if(!isComparedEntity){
			setIcons();
			
			}
			if(isComparedEntity){
				doTypedEntity();
			}
			
		}
		function doTypedEntity():void{
			
			if (myType is SignalIndicator) { 
				if(tradable){
					tradable.destroySelf()
				}
				
				indicator = new SignalIndicator(isComparedEntity);
				indicator.addEventListener("setXML", handleCondition)
				indicator.addEventListener("ComparedSignalEntityRemoved", handleComparedRemoved);
				indicator.addEventListener("ComparedSignalEntityAdded", handleComparedSignalEntityAdded);
				indicator.addEventListener("enableDone", activateDoneButton);
				//indicator.addEventListener("RemoveMe", handleRemove)
				myType = indicator;
				
				indicator.x -= 50;
				indicator.y += 40;
				//indicator.height = 500,
				addChild(indicator);
			}
					
			if (myType is SignalTradable){
				if(indicator){
					indicator.destroySelf();
				}
					tradable = new SignalTradable(isComparedEntity);
					tradable.addEventListener("setXML", handleCondition)
					tradable.addEventListener("CandleCreationComplete", handleCandle);
					//tradable.addEventListener("mathOpsSelected", handleMathOp);
					tradable.addEventListener("ComparedSignalEntityRemoved", handleComparedRemoved);
					tradable.addEventListener("ComparedSignalEntityAdded", handleComparedSignalEntityAdded);
					//tradable.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
					tradable.addEventListener("enableDone", activateDoneButton);
					//tradable.addEventListener("RemovedButtonClicked", removeInitialSignalEntity)
					//tradable.addEventListener("RemoveMe", handleRemove)
					tradable.x -= 50;
					tradable.y += 40;
					myType = tradable;
					addChild(tradable);
								
			}
		
		}
		public function getType():Object{
			return this.myType;
		}
		function setIcons():void{
			tblLogo = new TBLLogo();
			tblLogo.addEventListener(MouseEvent.CLICK, handleTBLINDSelection)
			addChild(tblLogo);
			tblLogo.name = "Tradable"
			tblLogo.buttonMode = true;
			tblLogo.x = 320;
			tblLogo.y = -25;
			
			indLogo = new INDLogo();
			indLogo.addEventListener(MouseEvent.CLICK, handleTBLINDSelection)
			indLogo.name = "Indicator"
			indLogo.buttonMode = true;
			indLogo.x = 470;
			indLogo.y = -25;
			addChild(indLogo);
			
		}
		function handleTBLINDSelection(event:Event):void{
			var gFilter = new GlowFilter(0xFFFFDD, 1, 25, 25, 2, 2, false, false)
			var mc:MovieClip = event.target as MovieClip;
			switch (mc.name) {
				case "Indicator":		 
				if(tradable){
					tradable.destroySelf()
				}
				indLogo.filters = [gFilter];
				tblLogo.filters = [];
				indicator = new SignalIndicator(isComparedEntity);
				indicator.addEventListener("setXML", handleCondition)
				//indicator.addEventListener("CandleCreationComplete", handleCandle);
				indicator.addEventListener("ComparedSignalEntityRemoved", handleComparedRemoved);
				indicator.addEventListener("ComparedSignalEntityAdded", handleComparedSignalEntityAdded);
				indicator.addEventListener("enableDone", activateDoneButton);
				//indicator.addEventListener("RemoveMe", handleRemove)
				myType = indicator;
				
				//indicator.x += 15;
				indicator.y += 40;
				//indicator.height = 500,
				addChild(indicator);
					break;
				case "Tradable":
				if(indicator){
					indicator.destroySelf();
				}
					tblLogo.filters = [gFilter];
					indLogo.filters = [];

					tradable = new SignalTradable(isComparedEntity);
					tradable.addEventListener("setXML", handleCondition)
					tradable.addEventListener("CandleCreationComplete", handleCandle);
					//tradable.addEventListener("mathOpsSelected", handleMathOp);
					tradable.addEventListener("ComparedSignalEntityRemoved", handleComparedRemoved);
					tradable.addEventListener("ComparedSignalEntityAdded", handleComparedSignalEntityAdded);
					//tradable.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
					tradable.addEventListener("enableDone", activateDoneButton);
					//tradable.addEventListener("RemovedButtonClicked", removeInitialSignalEntity)
					//tradable.addEventListener("RemoveMe", handleRemove)
					//tradable.x += 15;
					tradable.y += 40;
					myType = tradable;
					addChild(tradable);
					break;
				
				
			}
		}
		function handleCandle(event:Event):void{
			
			dispatchNewEvent("CandleCreationComplete");
			
		}
		function activateDoneButton(event:Event):void{
			dispatchNewEvent("enableDone");
		}
		function handleComparedRemoved(event:Event):void{
			
			dispatchNewEvent("ComparedSignalEntityRemoved");
		}
		function handleComparedSignalEntityAdded(event:Event):void{
			dispatchNewEvent("ComparedSignalEntityAdded");
		}
		function removeCondition(event:Event):void
		{
			parent.removeChild(this);
		}
		public function updateFieldOptions():void{
			myType.updateFieldOptions();
		}
		function handleCondition(event:CustomEvent):void{
			discriptionLabel = event.target.getInfoLabel();
			signalConditionXML = new XML(event.data);
			
			dispatchNewEvent("ConditionAdded");
		}
		public function getInfoLabel():String{
			return discriptionLabel;
		}
		public function setXML():Array
		{	
			
			return myType.setXML();
		}
		public function getConditionalEntityArray():Array{
			return myType.getConditionalEntityArray();
		}
		/*function resetTreatment():void{
			if(treatmentComboBox.stage){
				removeChild(treatmentComboBox);
				clearArrayFromStage(treatmentsParameter);
				removeFields();
				formatDisplay();
			}
		}*/
		public function setIsCompared(_isCompared:Boolean):void{
			this.isCompared = _isCompared;
		}
		public function resetMathOps():void{
			myType.addMathOps();
			myType.formatDisplay();
		}
		public function removeRemoveClip():void{
			if(getChildByName("RemoveClip")){
			   removeChild(getChildByName("RemoveClip"));
			   //dispatch("ComparedEntityRemoved", new Array);
			   }
		}
		function createSummery():String{
			
			var summery:String;
			if(!isComparedEntity){
				summery =  "If " + _HumanTradableEntity + "'s " + type + " in " + _HumanDatabase + " with " + _HumanTreatment + " is " + _HumanMathOperator;
			}
			if(isComparedEntity){
				summery =  _HumanTradableEntity + "'s " + type + " in " + _HumanDatabase + " with " + _HumanTreatment;
			}
			return summery;
		}
		function formatDisplay():String{
			var string = "Database: " + _HumanDatabase + "\n" + "Entity : " + _HumanTradableEntity + "\n" + "Treatment: " + _HumanTreatment + "\n" + "Type of Data: " + type +  "\n" + "Operator: " + _HumanMathOperator;
			displayText.text = string;
			
			return string;
		}
		public function getXML():XML{
			return signalConditionXML;
		}
		function dispatchNewEvent(eventString:String):void{
			dispatchEvent(new Event(eventString));
		}
	}
	
}
