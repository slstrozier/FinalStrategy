package ControlPanel.Signals{
	
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Util.*
	import flash.events.*
	import fl.controls.UIScrollBar; 
	import fl.containers.ScrollPane; 
	import fl.controls.ScrollPolicy; 
	import fl.controls.DataGrid; 
	import fl.data.DataProvider; 
	import flash.text.*

	public class Signals extends MovieClip
	{

		private var myStage:MovieClip;
		private var user:String;
		private var signalBuilder:SignalBuilder;
		private var buttonData:Array;
		private var signalsStage:MovieClip;
		private var buttonScroller:ButtonScroller

		public function Signals(stage:MovieClip, user:String)
		{
			myStage = stage;
			this.user = user;
			buttonData = new Array();
			setupOutline();
			init();
		}
		function init():void{
			getBoxInfo();
			placeSignalClip();
			
			
			//addEventListener("reload", reload);
		}
		function setupOutline():void
		{
			myStage.addChild(this);
			graphics.lineStyle(1,0x000000, 1);
			graphics.drawRect(700, 400, 200,200);
		}
		
		function placeSignalClip():void{
			var signalBuildClip:SignalBuilderClip = new SignalBuilderClip;
			
			signalBuildClip.buttonMode = true;
			signalBuildClip.addEventListener(MouseEvent.CLICK, launchSignal)
			signalBuildClip.y = 345;
			signalBuildClip.x = 845;
			addChild(signalBuildClip);
			
			
			buttonScroller = new ButtonScroller(signalsStage, 3, 400, 200)
			//buttonScroller.addChild(signalsStage);
			addChild(buttonScroller);
			//signalBuildClip.mask = sigMask;

		}
		
		
		function launchSignal(event:Event):void{
			var xmlXML:XML = new XML()
			if(signalBuilder){
				if(signalBuilder.stage){
					removeChild(signalBuilder);
				}
			}
	
			signalBuilder = new SignalBuilder(this, user, "Signal Builder", xmlXML);
			signalBuilder.addEventListener("NewButtonAdded", reload);			
		}

		public function getBoxInfo():void
		{
			signalsStage = new MovieClip();
			
			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttongetter?USER=user1&WHAT=customsignal");
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
				trace("No Signals Found in Database")
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
				
				dataProvider.push({Box: tArray[0], Name: tArray[1], Label: tArray[2], SignalDataXML: tArray[3], Destination: tArray[4], IsSignal: tArray[5], SignalOnOff: tArray[6], IsScan: tArray[7], ScanList: tArray[8]})
			}
			
			return dataProvider;
			
		}
		
		function setAllData(dataArray:Array):void{
			
			var yLoca:Number = 10;
			for (var index:Number = 0; index < dataArray.length; index++){
				var signalButton:SingleSignal = new SingleSignal(signalsStage, this.user, new Array(dataArray[index]))
				signalButton.addEventListener("UserSignalDeleted", reload)
				signalButton.addEventListener("LoadSignalBuilder", loadSignalBuilder)
				signalButton.x = 725
				signalButton.y = yLoca;
				yLoca += 50;
			}
	
		}
		function loadSignalBuilder(event:CustomEvent):void{
			displayXML(event.data);
			//signalBuilder = new SignalBuilder(this.myStage, this.user, "Signal Builder", new XML(event.data))
			//signalBuilder.addEventListener("NewButtonAdded", reload);
			reload(new Event("Reload"));
	
		}
		function displayXML(xmlFile:String, xLoca:Number = 150, yLoca:Number = 100):void{ 
			
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
				text = xmlFile;
				setTextFormat(boldText)
			}
			xmlText.y = this.y + 400;
			xmlText.x = 900
			
		
			var xmlDisplayBox:MovieClip = new MovieClip;
			
			xmlDisplayBox.name = "XML Display Box";
			with(xmlDisplayBox){
				graphics.beginFill(0xFFFFFF, 1)
				graphics.lineStyle(1);
				graphics.drawRoundRect(xmlText.x, xmlText.y, xmlText.width, xmlText.height, 10, 10)
				graphics.endFill();
			}
			xmlDisplayBox.addChild(xmlText);
					
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
		function reload(event:Event):void{
			
			removeChild(buttonScroller);
			init();
		}
		function dispatchNewEvent(dispatchString:String):void{
			dispatchEvent(new Event(dispatchString));
		}
	}
	
}
