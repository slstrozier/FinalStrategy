package ControlPanel.Signals{
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.*;
	import flash.display.Sprite;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.ScrollPolicy;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	import ControlPanel.CommonFiles.Util.*
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.filters.DropShadowFilter;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import fl.controls.UIScrollBar; 

 			
	//Opened by a Signals
	public class SignalBuilder extends MovieClip{

		
		public var signalConditionXML:XML;
		public var signalConditionArray:Array;
		public var headerText:TextField
		public var headerClip:Sprite
		public var myDescription:String
		public var signalBuilderDataGrid:DataGrid;
		public var signalBuilderDataProvider:DataProvider;
		private var _background:MovieClip;
		var _mask:MovieClip; 
		
		private var xLoca:Number;
		private var yLoca:Number;
		private var myStage:MovieClip;
		private var xmlRootName:String;
		
		private var infoLabel:TextField;
		private var STRATEGY:Strategy;
		private var databaseComboBox:ComboBox;
		private var _database:String;
		
		private var begin_monthCB:ComboBox;
		private var end_monthCB:ComboBox;
		private var begin_yearCB:ComboBox;
		private var end_yearCB:ComboBox;
		private var MonthsArray:Array;
		private var startDateMonth:String;
		private var startDateYear:String;
		private var endDateMonth:String;
		private var endDateYear:String;
		private var startDateFull:String;
		private var endDateFull:String;
		private var dropShadow;
		private var xmlDisplay:TextField;
		private var batchNo:Number;
		private var batchResponse:Boolean;
		private var pollCount:Number;
		private var myTimer:Timer;
		private var submitXML:XML;
		private var user:String
		private var loadXML:XML;
		private var saveSignalMC:MovieClip;
		
		
		//private var myStage:MovieClip;
	
		
		public function SignalBuilder(stage:MovieClip, user:String, description:String, data:XML, xmlName:String = "Signal") {
			
			this.xmlRootName = xmlName;
			
			myStage = stage;
			this.user = user;
			myDescription = description;
			signalConditionArray = new Array();
			databaseComboBox = new ComboBox();
			infoLabel = new TextField  ;
			batchResponse  = false;
			this.loadXML = data;
			startUpStrategy();
			myTimer  = new Timer(15000, 0)
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			//^^^^"THIS IS THE TIMER" ^^^^	
			
			
			
		}
		function init():void{
			
			this.scaleX = 0.9;
			this.scaleY = 0.9;
			this.x += 20
			this.y += 20
			drawBackground();
			dropShadow = new DropShadowFilter(5,10,20,0.5, 15, 15,1.0);
			signalBuilderDataGrid = new DataGrid();
			signalBuilderDataGrid.name = myDescription + " Conditions"
			createDataGrid(signalBuilderDataGrid, 100,_background.y + 355, "Signal Builder Conditions");
			signalBuilderDataProvider = new DataProvider();
			signalBuilderDataGrid.dataProvider = signalBuilderDataProvider;
	
			
			addChild(_background);
			var textExit:TextField = new TextField();
			textExit.text = "[Close]";
			textExit.autoSize = "center";
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.color = 0x0033CC;
			//myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			textExit.setTextFormat(myFormat);
			textExit.x = 830;
			textExit.y = 0;
			//textExit.mouseEnabled = true;
			
			var textExitClip:MovieClip = new MovieClip();
			textExitClip.addChild(textExit);
			textExitClip.mouseChildren = false;
			textExitClip.buttonMode = true;
			textExitClip.addEventListener(MouseEvent.CLICK, removeCondition);
			addChild(textExitClip);
			
			addSaveScanButton();
			myStage.parent.addChild(this);
			newSignalEntityBuilder();
			//myStage.addChild(this);
		}
		function newSignalEntityBuilder():void{
			if(getChildByName("SignalEntityBuilder")){
			   removeChild(getChildByName("SignalEntityBuilder"));
			   }
			
			var signalEntityBuilder:SignalEntityBuilder = new SignalEntityBuilder();
			signalEntityBuilder.name = "SignalEntityBuilder";
			addChild(signalEntityBuilder);
			signalEntityBuilder.addEventListener("ConditionAdded", handleAccept)
			signalEntityBuilder.y += 40;
			
		}
		function addSaveScanButton():void{
			saveSignalMC = new BezzleButton();
			saveSignalMC.scaleX = .5
			saveSignalMC.scaleY = .4
			saveSignalMC.y = this.height - 20;
			saveSignalMC.x += 10;
			saveSignalMC.textField.text = "Record Signal"
			saveSignalMC.mouseChildren = false;
			saveSignalMC.buttonMode = true;
			saveSignalMC.addEventListener(MouseEvent.CLICK, scanRun);
			addChild(saveSignalMC);
		}
		function saveSignal(event:Event):void{
			
		}
		public function addNewButton(bttnName:String, bttnLabel:String, bttnData:String):void{

				var url:String = "http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=add&WHAT=signal&NAME=" + bttnName + "&DESCR=" + bttnLabel;

				var urlRequest:URLRequest = new URLRequest(url);
				urlRequest.data = bttnData;
				urlRequest.contentType = "text/xml";
				urlRequest.method = URLRequestMethod.POST;
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(urlRequest);
				urlLoader.addEventListener(Event.COMPLETE, handleButtonAdd)
		}
		function handleButtonAdd(event:Event):void{
			dispatch("NewButtonAdded")
		}
		function createXMLStringFromList(xmlList:XML):String{
			var xmlString:String;
            for each(var item:Object in xmlList) {
                xmlString += item
            }
			xmlString = xmlString.split("\n").join("");
			xmlString = xmlString.split("  ").join("");
			xmlString = xmlString.split(null).join("");
			xmlString = xmlString.replace("type", " type")
			return xmlString;
        
		}
		function dispatch(dispatchString:String, data:String = ""):void{
			dispatchEvent(new CustomEvent(dispatchString, data));
		}
		function addXmlDisplay():void{
			
			xmlDisplay = new TextField();
			xmlDisplay.background = true;
			xmlDisplay.backgroundColor = 0xFFFFFF;
			xmlDisplay.width = 375;
			xmlDisplay.x = 450;
			xmlDisplay.y = 300;
			if(!loadXML == ""){
			xmlDisplay.text = breakdownXML(loadXML);
			}
			var mySb:UIScrollBar = new UIScrollBar(); 
			mySb.direction = "vertical"; 
			// Size it to match the text field. 
			mySb.setSize(xmlDisplay.width, xmlDisplay.height);  
			 
			// Move it immediately below the text field. 
			mySb.move(xmlDisplay.x + xmlDisplay.width, xmlDisplay.y); 
			mySb.scrollTarget = xmlDisplay;
			// put them on the Stage 
			//addChild(myTxt); 
			addChild(mySb); 
			addChild(xmlDisplay);
		}
		function breakdownXML(xml:XML):String{
			
			var type = "Field: " + xml.Condition.CondEntity.@type
			var condEntity = xml.Condition.CondEntity
			var condOperator = "Operator: "+ xml.Condition.CondOperator
			var parameter = "Operator Parameter: " + xml.Condition.Parameter
			var db = "Database: " + xml.DB;
			var  fullDisplay:String = type + "\n" + condEntity + "\n" + condOperator + "\n" + parameter + "\n" + db
			
			return fullDisplay;
		}
		function removeCondition(event:Event):void
		{
			parent.removeChild(this);
		}
		function scanRun(event:Event):void{
			submitXML = setXML();
			
			var temp:String = submitXML.Condition.CondEntity;
			
			var type = temp.substring(0, temp.indexOf("(",0));
			var scanName:String;
			var messageBox:MessageBox = new MessageBox(_background, "Save Signal", "Please Enter a name for your Signal", 200, true) 
			messageBox.move(250,100);
			messageBox.addEventListener("OK", handleScanSave);
			function handleScanSave(event:CustomEvent):void{
				scanName = event.data;
				var namedXml:XML = new XML(<ScanName/>)
				namedXml["ScanName"] =  scanName;
				trace(namedXml + "This is the namesd X<:)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))*IIIIIIIIIIIIIIIUU&U&U&U&U&U&U&U&U&U&U&U&U&")
				/*var nameOfSignalXML:XML = new XML(<SignalName/>);
				nameOfSignalXML["SignalName"] = scanName;
				namedXml.push(nameOfSignalXML)
				trace(namedXml + "This is the signalName");*/
				addNewButton(scanName, namedXml, namedXml)
			}
			
						
 		}
		function pullRequest():void{
			//var rand:String = "&"+(Math.random()*100000000).toString();

			var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/stockscreener?daterange=all&user=" + this.user + "&rand=" +(Math.random()*10000).toString());

			trace("-------------------------------------- The Query submitted was " + xmlScriptLoader.url + "----------------------------------------");
			xmlScriptLoader.data = submitXML;
			trace("-------------------------------------- The XML submitted was " + submitXML.toXMLString() + "----------------------------------------");
			xmlScriptLoader.contentType = "text/xml";
			xmlScriptLoader.method = URLRequestMethod.POST;
			
			var xmlLoader:URLLoader = new URLLoader();
	
			xmlLoader.addEventListener(Event.COMPLETE, handleSignalReady)
			xmlLoader.load(xmlScriptLoader)
		}
		function handleXMLLoad(event:Event):void{
			pollCount = 0;
			trace(event.target.data);
			//myTimer.start();
		}

		function checkBatchReady(_batchNo:Number):void{
			
			pollCount++;
			var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/getscanresult?id=" +_batchNo+ "&rand=" + (Math.random()*1000).toString());

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
				
				var ready_true:String = event.target.data;
						
				if(batchReady(ready_true)){
					trace("batch is ready")
					myTimer.stop();
					var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/getscanxml?id=" +_batchNo + "&" + Math.random().toString());

					xmlScriptLoader.contentType = "text/xml";
					xmlScriptLoader.method = URLRequestMethod.POST;
					
					var xmlLoader2:URLLoader = new URLLoader();
					
					xmlLoader2.addEventListener(Event.COMPLETE, handleSignalReady)
					xmlLoader2.load(xmlScriptLoader)
					
				}
				
			}
		
		}
		function handleSignalReady(event:Event):void{
			trace("+++++++++++++++++++++++++++++++++++++++++++Signal Ready++++++++++++++++++++++++++++++++++++++++++++")
			trace(event.target.data);
			trace("+++++++++++++++++++++++++++++++++++++++++++Signal Ready++++++++++++++++++++++++++++++++++++++++++++")
			dispatchResults(event.target.data);
		}
		function batchReady(isReady:String):Boolean{
			
			
			if(isReady == "ready")
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
		function completeHandler(event:Event):void{
			
		}
		function handleSubmit(event:CustomEvent):void{
			var date:Date = new Date;
			trace("-------------------------------------- Response from Server @ " + date.toTimeString() + "----------------------------------------");
			
			dispatchResults(event.data.toString);
			
		}
		function dispatchResults(_result:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", _result));
		}
		function startUpStrategy():void
		{
			STRATEGY = Strategy.getInstance();
			init();
			

		}
		public function returnEmConditions():DataProvider{
			return signalBuilderDataProvider;
		}
		
		function drawMask():void
		{

			_mask = new MovieClip();
			
			
			_mask.graphics.drawRect(25, 75, 1050, 500);
			
			_background.addChild(_mask);
		}
		function drawBackground():void{
			_background = new MovieClip();
			//_background.alpha = 0;
			_background.graphics.lineStyle(1, 0xCCCCBB);
			_background.graphics.beginFill(0xCCCCCC, 1);
			_background.graphics.drawRect(0,0,975,500);
			_background.graphics.endFill();
			var filter = new DropShadowFilter(16,45,20,0.5, 20.0, 20.0,1.0);
			_background.filters = [filter];
			//_background.addChild(PlaceImage("plusmed.png", newSignalEntity, 0.1, 0.1, _background.width - 40, 50));
			//_background.addChild(PlaceImage("next.png", acceptTrigger, 0.1, 0.1, _background.width - 35,  _background.height - 50));
			//_background.addChild(PlaceImage(, acceptTrigger, 0.1, 0.1, _background.width - 35,  _background.height - 50));doubleAmpersand.png
			addChild(_background);
		}
		
		
		function handleAccept(event:CustomEvent):void{
			//trace(event.data[1])
			var array:Array = event.data;
			var s:String = this.myDescription + " Conditions"
			signalBuilderDataProvider.addItem({"Initial Entity": array[0].Summery, "Math Operator": array[0].MathOp, "Second Entity": array[0].SecondEntSummery, XML: array[0].XML})	
		}
		public function setXML():XML{
			
			if(signalBuilderDataProvider.length > 0)
			{
				signalConditionXML = new XML(<{this.xmlRootName}/>);
				
				for(var signalConditionArrayIndex:Number = 0; signalConditionArrayIndex < signalBuilderDataProvider.length; signalConditionArrayIndex++)
				{
					//signalConditionArray[signalConditionArrayIndex].acceptMe()
					signalConditionXML.appendChild(signalBuilderDataProvider.getItemAt(signalConditionArrayIndex).XML)
				}
				
			}
		trace("+++++++++++++++++++++++++++This is the XML from setXML++++++++++++++++++++++++++++++")
		trace(signalConditionXML)
		trace("+++++++++++++++++++++++++++This is the XML from setXML++++++++++++++++++++++++++++++")
		return signalConditionXML;
		}
		
		function setLabel(obj:Object):void
		{

			infoLabel.autoSize = "left";
			infoLabel.x = 0;
			infoLabel.y = 0;
			infoLabel.textColor = 0x000000;
			infoLabel.text = obj.description;
			infoLabel.wordWrap = true;
			infoLabel.background = true;
			infoLabel.backgroundColor = 0xF6DDBC;
			infoLabel.border = true;
			infoLabel.borderColor = 0xC0C0C0;
			infoLabel.width = 250;
			infoLabel.antiAliasType = AntiAliasType.ADVANCED;
			var tw:Tween = new
			Tween(infoLabel,"alpha",None.easeNone,infoLabel.alpha,1,1,true);
		}
		
		/*
		* Assigns properties to a datagrid and assigns properties to the datagrid.
		*
		* @dg The Datagrid in which to assign properties.
		* @xLoc The x location of the datagrid
		* @yLoc The y location of the datagrid
		* @dataName The name of the lead column of the datagrid
		*
		* @ return void
		*/
		function createDataGrid(dg:DataGrid, xLoc:Number, yLoc:Number,
		dataName:String):void
		{
			var i:uint;
			var totalRows:uint = 5;
			dg.x = xLoc;
			dg.y = yLoc;
			dg.name = dataName;
			dg.setSize(825, 125);
			dg.columns = ["Initial Entity", "Math Operator", "Second Entity"];
			//dg.columns = ["Math Operator"];
			//dg.columns = ["Second Entity"];
			dg.rowHeight = 40;
			dg.resizableColumns = true; 
			dg.verticalScrollPolicy = ScrollPolicy.AUTO; 
			var col0:DataGridColumn = new DataGridColumn(); 
			col0 = dg.getColumnAt(0); 
			col0.cellRenderer = MultiLineCell;
			var col1:DataGridColumn = new DataGridColumn(); 
			col1 = dg.getColumnAt(1); 
			col1.cellRenderer = MultiLineCell;
			var col2:DataGridColumn = new DataGridColumn(); 
			col2 = dg.getColumnAt(2); 
			col2.cellRenderer = MultiLineCell;
			var redX:Class = getDefinitionByName("red_X2") as Class;
			var red_X:Bitmap = new Bitmap(new redX());
			
			red_X.scaleX = 0.05;
			red_X.scaleY = 0.05;
			//red_X.x = dg.x + dg.width + 10;
			//red_X.y = yLoc

			var container:MovieClip = new MovieClip();

			container.addChild(red_X);
			container.y = yLoca;
			container.x = dg.width + 10;
			container.buttonMode = true;
			container.addEventListener(MouseEvent.CLICK,
			function(e:MouseEvent){DeleteFromList(e,dg)});
			
			dg.addChild(container);
			_background.addChild(dg)
			
		}
		function PlaceImage(_className:String, _function:Function, _xScale:Number = 1, _yScale:Number = 1, _xLoca:Number = 0, _yLoca:Number = 0):MovieClip
			{
				var _container:MovieClip = new MovieClip();
				var tempClass:Class = getDefinitionByName(_className) as Class;
				var tempBitmap:Bitmap = new Bitmap(new tempClass());
				_container.name = _className;
				_container.scaleX = _xScale;
				_container.scaleY = _yScale;
				_container.x = _xLoca;		
				_container.y = _yLoca;
				_container.addChild(tempBitmap);
				_container.buttonMode = true;
				_container.addEventListener(MouseEvent.CLICK, _function);
				return _container;
			}
		function DeleteFromList(event:Event, dg:DataGrid):void
		{
			if (dg.selectedIndex > -1)
			{
				if (dg.dataProvider.length > 0)
				{
					dg.dataProvider.removeItemAt(dg.selectedIndex);
				}
			}
		}
		
		
	}
	
}
