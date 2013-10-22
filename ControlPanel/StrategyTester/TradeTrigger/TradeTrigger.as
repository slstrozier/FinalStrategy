package ControlPanel.StrategyTester.TradeTrigger {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import ControlPanel.StrategyTester.TradeTrigger.*
	import ControlPanel.CommonFiles.Util.CustomEvent;

	//Opened by StrategyBuilderGUI
	public class TradeTrigger extends MovieClip{
		
		private var tradeTriggerBuilder:TradeTriggerBuilder;
		public var headerText:TextField
		public var headerClip:MovieClip;
		private var myStage:MovieClip;
		private var xLoca:Number;
		private var yLoca:Number;
		private var maxDaily:Number;
		private var triggerXML:XMLList;
		private var isData:Boolean
		
		public function TradeTrigger(_stage:MovieClip, xLoca:Number, yLoca:Number, maxDaily:Number, user:String = "user1") {
			this.name = "Trade Trigger";
			this.maxDaily = maxDaily;
			this.xLoca = xLoca;
			this.yLoca = yLoca;
			this.x = xLoca;
			this.y = yLoca;
			this.myStage = _stage;
			headerClip = new MovieClip();
			tradeTriggerBuilder = new TradeTriggerBuilder(this, user, "Trade Trigger", new XML(<GetIn/>), "Add", maxDaily);
			tradeTriggerBuilder.addEventListener("TriggerXML", handleTriggerXML);
			tradeTriggerBuilder.addEventListener("isData", handleIsData);
			tradeTriggerBuilder.addEventListener("isReadyForStrat", handleIsReadyForStrat);
		
			addChild(tradeTriggerBuilder);
		}
		function handleIsReadyForStrat(event:Event):void{
			dispatchEvent(new Event("isReadyForStrat"));
		}
		public function getIsData():Boolean{
			return isData;
		}
		function handleIsData(event:CustomEvent):void{
			isData = event.data as Boolean;
			dispatchEvent(new CustomEvent("DataSet", "Trade Trigger"));
		}
		function handleTriggerXML(event:CustomEvent):void{
			this.triggerXML = new XMLList(event.data);
		}
		public function returnHeader():MovieClip{
			return headerClip;
		}
		function expandHeader(event:MouseEvent):void{
			expandMe();
		}
		public function expandMe():void{
			this.alpha = 1;
			this.y = 0;
			this.enabled = true;
			
		}
		public function collapseMe():void{
			this.alpha = 0;
			this.y = 1500;
			this.enabled = false;
			
		}
		function collapseHeader(event:MouseEvent):void{
			collapseMe();
		}
		function acceptTrigger(event:Event):void{
			// trace(setXML());
			// trace(ifArray[0].displayInfo());
			collapseMe();
		}
		public function setXML():XMLList{
			triggerXML = tradeTriggerBuilder.setXML();
			return triggerXML;
		}

	}
	
}
