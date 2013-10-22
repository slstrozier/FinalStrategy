package ControlPanel.CustomCharts{
	import flash.display.MovieClip;
	import flash.events.*;
	import ControlPanel.CommonFiles.Util.*
	import ControlPanel.CustomCharts.SingleCustomButton
	public class CustomCharts extends MovieClip{
		
		private var myStage:MovieClip;
		private var singleCustomButton:SingleCustomButton
		private var user:String;
		private var buttonScroller:ButtonScroller;
		private var customButtonStage:MovieClip;
		private var buttonData:Array;
		private var customButtonsArray:Array;
		private var dispatchString:String = "CustomChartDataReady";
		
		public function CustomCharts(stage:MovieClip, userName:String) {
			myStage = stage
			user = userName;
			setupOutline();
			init()
		
		}
		function init():void{
			getBoxInfo();
			//addChild(customButtonStage);
			addChild(newButtonScroller(customButtonStage));
		}
		function newButtonScroller(toBeScrolled:MovieClip):MovieClip{
			if(buttonScroller){
				if(buttonScroller.stage){
					removeChild(buttonScroller);
				}
			}
			buttonScroller = new ButtonScroller(toBeScrolled, 3, 0, 150);
			return buttonScroller;
		}
		public function getBoxInfo():void
		{
			customButtonStage = new MovieClip();
			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttongetter?USER="+this.user+"&WHAT=customme");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, buttonGetter);
			
		}
		/*
		*Listener for the urlFactory, on complete sets the buttonData array to the data retrieved. And then calls
		*the setDataProvider method on the list
		*/
		function buttonGetter(event:CustomEvent)
		{
			//trace(event.data)
			if(event.data == ""){
				return ""
			}
			
			if(event.data == "-1"){
				trace("No Saved Charts Found in Database")
				return ""
			}
			
				buttonData = event.data.split("\n");
				buttonData = setDataProvider(buttonData);
				dispatchEvent(new Event("dataReady"));	
				setAllData(buttonData);
				return "";
		}
		/*
		*This method takes an array of data, splits and returns an object array containing the data needed for the movie clips.
		*
		*/
		function setDataProvider(data:Array):Array{
			
			var dataProvider:Array = new Array();
			for(var index:Number = 0; index < data.length; index++){
				
				var tArray:Array = data[index].split('","');
				dataProvider.push({Box: tArray[0], Name: tArray[1], Label: tArray[2], ChartData: tArray[3], Destination: tArray[4], IsSignal: tArray[6], SignalOnOff: tArray[7], IsScan: tArray[8], ScanList: tArray[9]})
			}
			
			return dataProvider;
			
		}
		function setAllData(dataArray:Array):void{
			
			var yLoca:Number = 10;
			var xLoca:Number = 0;
			var stageWidth:Number = 150;
			for (var index:Number = 0; index < dataArray.length; index++){
				
				singleCustomButton = new SingleCustomButton(customButtonStage, this.user, new Array(dataArray[index]))
				singleCustomButton.addEventListener("UserButtonDeleted", reload)
				singleCustomButton.addEventListener("ScanDataReady", handleScanData)
				singleCustomButton.button.addEventListener(MouseEvent.CLICK, handleButtonClick);
				//singleCustomButton.addEventListener("StartScanBuilder", reload)
				
				
				
				singleCustomButton.x = 725
				singleCustomButton.y = yLoca;
				yLoca += 50;
				
				
			}
	
		}
		function handleButtonClick(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			var chartData:String = mc.ButtonData[0].ChartData;
			dispatchEvent(new CustomEvent(dispatchString, chartData));
		}
		function handleScanData(event:CustomEvent):void{
			sendQueryResults(event.data);
		}
		function reload(event:Event = null):void{
			init();
		}
		function setupOutline():void{
			
			myStage.addChild(this);
			graphics.lineStyle(1,0x000000, 1);
			graphics.drawRect(700, myStage.y, 200,150);
		}
		
		
		function handleQueryResult(event:CustomEvent):void{
			
			sendQueryResults(event.data);
		}
		function sendQueryResults(results:String):void{
			dispatchEvent(new CustomEvent("CustomChartDataReady", results));
		}
		function handleCustomButtonDelete(event:Event):void{
			removeChild(singleCustomButton);
			init();
		}
		function handleCustomButtonAdd(event:Event):void{
			removeChild(singleCustomButton);
			init();
		}
		public function addNewButton(bttnName:String, bttnLabel:String, bttnData:String):void{
								
				var urlFactory:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=add&WHAT=entity&NAME=" + bttnName + "&DESCR=" + bttnLabel + "&DATA=" + bttnData)
				urlFactory.addEventListener(CustomEvent.QUERYREADY, handleButtonAdd)
				
		}
		function handleButtonAdd(event:CustomEvent):void{
			dispatch("NewButtonAdded")
			
			init();
		}
	
		function dispatch(dispatchString:String):void{
			dispatchEvent(new Event(dispatchString));
		}
	}
	
}
