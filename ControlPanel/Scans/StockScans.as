package ControlPanel.Scans
{
	import flash.display.MovieClip;
	import flash.events.*;
	import ControlPanel.CommonFiles.Util.*
	//This class is handled by FinalStrategyGUI
	public class StockScans extends MovieClip
	{

		private var myStage:MovieClip;
		private var scanBuilder:ScanBuilder
		private var singleScan:SingleScan;
		private var scanStage:MovieClip;
		private var buttonData:Array;
		private var buttonScroller:ButtonScroller;
		
		private var dates:Array;
		private var scanList:Array;//the list of scans.
		//private var 
		private var user:String;

		public function StockScans(stage:MovieClip, user:String)
		{
			this.name = "Stock Scans";
			this.user = user;
			myStage = stage;
			dates = new Array("ALL", "NOW");
			scanList = new Array();
			setupOutline();
			init();
		}
		function init():void{
			getBoxInfo();
			placeScansClip();
			addChild(newButtonScroller());
		}
		function placeScansClip():void{
			var stockScans:StockScansClip = new StockScansClip();
			addChild(stockScans);
			stockScans.x = 710;
			stockScans.y = 345;
			stockScans.addEventListener(MouseEvent.CLICK, openScanBuilder)
			stockScans.buttonMode = true;

		}
		function newButtonScroller():MovieClip{
			if(buttonScroller){
				if(buttonScroller.stage){
					removeChild(buttonScroller);
				}
			}
			buttonScroller = new ButtonScroller(scanStage, 3, 150, 190);
			return buttonScroller;
		}
		function setupOutline():void
		{

			myStage.addChildAt(this, 0);
			graphics.lineStyle(1,0x000000, 1);
			graphics.drawRect(700, 150, 200, 190);
		}
		public function getBoxInfo():void
		{
			
			scanStage = new MovieClip();
			scanStage.name = "Scan Stage"
			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttongetter?USER=" + this.user + "&WHAT=customfilter");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, buttonGetter);			
		}
		/*
		*Listener for the urlFactory, on complete sets the buttonData array to the data retrieved. And then calls
		*the setDataProvider method on the list
		*/
		function buttonGetter(event:CustomEvent):String
		{
			
			if(event.data == ""){
				return ""
			}
			
			if(event.data == "-1"){
				trace("No Scans found in Database");
				return ""
			}
			
				buttonData = event.data.split("\n");
				buttonData = setDataProvider(buttonData);
				dispatchEvent(new Event("dataReady"));	
				setAllData(buttonData);
				return "";
		}
		public function stripspaces(originalstring:String):String
		{
			var original:Array=originalstring.split(' ');
			return(original.join(''));
		}
		/*
		*This method takes an array of data, splits and returns an object array containing the data needed for the movie clips.
		*
		*/
		function setDataProvider(data:Array):Array{
			
			var dataProvider:Array = new Array();
			var space:RegExp = /\s/g;
			for(var index:Number = 0; index < data.length; index++){
				
				var tempData:Array = data[index].split('","');
				
				dataProvider.push({Box:tempData[0], Name:tempData[1], Label:tempData[2], SingleScanXML:tempData[3], Destination:tempData[4], IsSignal:tempData[5], SignalValue:tempData[6], isSingleScan:tempData[7], HitTotal:tempData[8], HitStocks: tempData[9].replace(space, "")})
			}
			
			return dataProvider;
			
		}
		function setAllData(dataArray:Array):void{
			
			var yLoca:Number = 10;
			for (var index:Number = 0; index < dataArray.length; index++){
				
				var scanButton:SingleScan = new SingleScan(scanStage, this.user, new Array(dataArray[index]))
				//scanButton.x += 50;
				scanButton.addEventListener("UserScanDeleted", reload)
				scanButton.addEventListener("ScanDataReady", handleScanData)
				scanButton.singleScanButton.addEventListener(MouseEvent.CLICK, loadScanBuilder);
				//scanButton.addEventListener("StartScanBuilder", reload)
				
				
				scanButton.x = 725
				scanButton.y = yLoca;
				yLoca += 50;
				scanList.push(scanButton);
				
			}
	
		}
		
		function handleScanData(event:CustomEvent):void{
			sendQueryResults(event.data);
		}
		function loadScanBuilder(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			scanBuilder = new ScanBuilder(this, user, "Scan Builder", mc.ButtonData[0].SingleScanXML);
			scanBuilder.addEventListener("QueryResultReady", handleQueryResult)
			
		}
		public function setDates(dates:Array):void{
			this.dates = dates;
			for each (var scan:SingleScan in scanList){
				
				  scan.setDate(this.dates);  
		  }
		}
		function dispatchReload(event:Event):void{
			dispatchNewEvent("Reload")
		}
		function reload(event:Event = null):void{
			init();
		}
		function dispatchNewEvent(dispatchString:String):void{
			dispatchEvent(new Event(dispatchString));
		}
		function openScanBuilder(event:Event):void{
			
			scanBuilder = new ScanBuilder(this, user, "Scan Builder", "");
			scanBuilder.addEventListener("QueryResultReady", handleQueryResult)
			
		}

		
		function handleQueryResult(event:CustomEvent):void{
			
			sendQueryResults(event.data);
			
			reload();
		}
		function sendQueryResults(results:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", results));
		}

	}
}