package ControlPanel.QSB{
	import flash.display.MovieClip;
	import flash.events.*;
	import ControlPanel.CommonFiles.Util.CustomEvent
	import flash.filters.GlowFilter;

	 //Called by  ********************FinalStrategyGUI************
	public class QueryStringBuilderGUI extends MovieClip{
		private var indicator:Indicator;
		private var tradable:Tradable;
		private var dates:Array;
		private var indtblDisplayList:Array;
		private var isTBL:Boolean;
		private var glowFilter:GlowFilter;
		private var filterArray:Array//this is the Array that will hold the movie clips for filter handling.
		
		
		public function QueryStringBuilderGUI(stage:MovieClip) {
			indtblDisplayList = new Array();
			this.dates = new Array();
			indicator = new Indicator(this);
			tradable = new Tradable(this);
			glowFilter = new GlowFilter();
			placeLogo();
			
			stage.addChild(this);
			
		}
		function placeLogo():void{
			var logo:QSBLogo = new QSBLogo();
			
			logo.scaleX = 1.5;
			logo.scaleY = 1.5;
			logo.x = 400
			//logo.y -= 25
			addChild(logo);
			var tblLogo:TBLLogo = new TBLLogo();
			tblLogo.addEventListener(MouseEvent.CLICK, handleTBLIND)
			addChild(tblLogo);
			tblLogo.name = "TBL"
			tblLogo.buttonMode = true;
			tblLogo.x = 280;
			tblLogo.y += 60;
			var indLogo:INDLogo = new INDLogo();
			indLogo.addEventListener(MouseEvent.CLICK, handleTBLIND)
			indLogo.name = "IND"
			indLogo.buttonMode = true;
			indLogo.x = 525;
			indLogo.y += 60;
			addChild(indLogo);
			filterArray = new Array(indLogo, tblLogo);
			
		}
		function handleTBLIND(event:Event):void{
			clearDisplayList(indtblDisplayList);
			removeFilters(filterArray);
			var mc:MovieClip = event.target as MovieClip;
			switch(mc.name){
				case "IND":
				isTBL = false;
				getChildByName("IND").filters = [glowFilter];
				indicator.setDates(this.dates)
				indicator.x = 400;
				indicator.y = 20;
				indicator.addEventListener("QueryResultReady", handleQueryResult)
				addChild(indicator);
				indtblDisplayList.push(indicator);
				break;
				case "TBL":
				isTBL = true;
				getChildByName("TBL").filters = [glowFilter];;
				tradable.setDates(this.dates)
				tradable.x = 300;
				tradable.y = 20;
				tradable.addEventListener("QueryResultReady", handleQueryResult)
				tradable.addEventListener("DatesRecieved", handleReceivedDates)
				addChild(tradable);
				indtblDisplayList.push(tradable);
				break;
			}
			
			//trace(mc.name);
		}
		function removeFilters(arrayOfClips:Array):void{
			for(var index:int = 0; index < arrayOfClips.length; index++){
				arrayOfClips[index].filters = [];
			}
		}
		function handleReceivedDates(event:CustomEvent):void{
			//trace(event.data + "<<qsbFromTradable")
			dispatch("DatesRecieved", event.data);
		}
		function dispatch(dispatchString:String, data:*){
			dispatchEvent(new CustomEvent(dispatchString, data));
		}
		public function setDates(dates:Array):void{
			this.dates = dates;
			
				tradable.setDates(this.dates);
			
			
				indicator.setDates(this.dates);
			
			
		}
		function handleQueryResult(event:CustomEvent):void{
			
			sendQueryResults(event.data);
		}
		function sendQueryResults(results:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", results));
		}
		function clearDisplayList(displayList:Array):void{
			for each(var mc:MovieClip in displayList){
				removeChild(mc);
			}
			displayList.splice(0);
		}
	}
	
}
