package ControlPanel.StrategyTester.CloseTrade {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import ControlPanel.StrategyTester.CloseTrade.*
	import ControlPanel.CommonFiles.Util.*
	import fl.controls.Button;

	//Opened by StrategyBuilderGUI
	public class CloseTrade extends MovieClip{
		
		private var closeTradeBuilder:CloseTradeBuilder;
		public var headerText:TextField
		public var headerClip:MovieClip;
		private var myStage:MovieClip;
		private var xLoca:Number;
		private var yLoca:Number;
		private var maxDaily:Number;
		private var closeType:String
		public var submitXML:XMLList;
		private var isData:Boolean
		
		
		public function CloseTrade(_stage:MovieClip, xLoca:Number, yLoca:Number, maxDaily:Number, name:String = "No Name Given", user:String = "user1", closeType:String = "Close") {
			this.name = name;
			this.maxDaily = maxDaily;
			this.xLoca = xLoca;
			this.yLoca = yLoca;
			this.x = xLoca;
			this.y = yLoca;
			this.myStage = _stage;
			this.closeType = closeType;
			headerClip = new MovieClip();
			closeTradeBuilder = new CloseTradeBuilder(this, user, "Close Trade", new XML(<{this.closeType}/>), false, closeType, maxDaily);
			closeTradeBuilder.addEventListener("CloseTradeXML", handleCloseTradeXML);
			closeTradeBuilder.addEventListener("isData", handleIsData);
			closeTradeBuilder.addEventListener("isReadyForStrat", handleIsReadyForStrat);
			addChild(closeTradeBuilder);
			
		}
		function junkFunction(event:Event):void{
			//trace("JUNK")
			//trace(submitXML)
			//trace("JUNK")
		}
		function handleIsReadyForStrat(event:Event):void{
			dispatchEvent(new Event("isReadyForStrat"));
		}
		function handleCloseTradeXML(event:CustomEvent):void{
			//trace("handleCloseTradeXML")
			//trace(event.data)
			//trace("handleCloseTradeXML")
			submitXML = new XMLList(event.data);
		}
		
		public function getIsData():Boolean{
			return isData;
		}
		function handleIsData(event:CustomEvent):void{
			isData = event.data as Boolean;
			dispatchEvent(new CustomEvent("DataSet", "Trade Trigger"));
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
		public function setXML():XMLList{
			//trace("++++++++++++++++++++THIS IS FROM CLOSE TRADE+++++++++++++++++")
			//trace(submitXML)
			//trace("++++++++++++++++++++THIS IS FROM CLOSE TRADE+++++++++++++++++")
			return submitXML;
		}
	}
	
}
