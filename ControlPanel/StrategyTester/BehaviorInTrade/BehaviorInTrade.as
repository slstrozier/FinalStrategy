package ControlPanel.StrategyTester.BehaviorInTrade {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import ControlPanel.CommonFiles.Util.CustomEvent;

	//Opened by StrategyBuilderGUI
	public class BehaviorInTrade extends MovieClip{
		
		private var behaviorInTradeBuilder:BehaviorInTradeBuilder;
		public var headerText:TextField
		public var headerClip:MovieClip;
		private var myStage:MovieClip;
		private var xLoca:Number;
		private var yLoca:Number;
		private var maxDaily:Number;
		private var submitXML:XML;
		private var isData:Boolean
		
		public function BehaviorInTrade(_stage:MovieClip, xLoca:Number, yLoca:Number, maxDaily:Number, user:String = "user1") {
			this.name = "Behavior In Trade";
			this.maxDaily = maxDaily;
			this.xLoca = xLoca;
			this.yLoca = yLoca;
			this.x = xLoca;
			this.y = yLoca;
			this.myStage = _stage;
			headerClip = new MovieClip();
			behaviorInTradeBuilder = new BehaviorInTradeBuilder(this, user, "Behavior In Trade", new XML(<Add/>), true, "Add", maxDaily);
			behaviorInTradeBuilder.addEventListener("BehaviorInTradeXML", handleBehaviorInTradeXML);
			behaviorInTradeBuilder.addEventListener("isData", handleIsData);
			behaviorInTradeBuilder.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			addChild(behaviorInTradeBuilder);
			submitXML = new XML(<Behavior/>)
			submitXML.appendChild(<Add/>)
			submitXML["Add"] = "NONE";
		}
		function handleBehaviorInTradeXML(event:CustomEvent):void{
			submitXML = new XML(event.data);
		}
		public function getIsData():Boolean{
			return isData;
		}
		function handleIsReadyForStrat(event:Event):void{
			dispatchEvent(new Event("isReadyForStrat"));
		}
		
		function handleIsData(event:CustomEvent):void{
			isData = event.data as Boolean;
			dispatchEvent(new CustomEvent("DataSet", "Behavior In Trade"));
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
			
			collapseMe();
		}
		public function setXML():XML{
			return this.submitXML;
		}
		public function setMaxDaily(newMaxDaily:Number):void{
			this.maxDaily = newMaxDaily;
		}

	}
	
}
