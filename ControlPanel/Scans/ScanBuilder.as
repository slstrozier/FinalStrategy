package ControlPanel.Scans{
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.*;
	import flash.display.Sprite;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.ScrollPolicy;
	import fl.controls.DataGrid;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.filters.DropShadowFilter;
	import flash.net.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import ControlPanel.CommonFiles.Util.*
	import ControlPanel.CommonFiles.DoubleSlider.DoubleSlider;
	import fl.controls.ProgressBar;
	import flash.filters.BlurFilter;

 			
	//This class is handled by StockScans
	public class ScanBuilder extends MovieClip{

		
		public var scanConditionXML:XML;
		public var scanConditionArray:Array;
		public var headerText:TextField
		public var headerClip:Sprite
		public var myDescription:String
		public var scanDataGrid:DataGrid;
		public var scanDataProvider:DataProvider;
		private var _background:MovieClip;
		
		
		private var xLoca:Number;
		private var yLoca:Number;
		private var myStage:MovieClip;
		private var xmlRootName:String;
		
		private var infoLabel:TextField;
		private var maxBet:Number;
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
		private var loadData:String;
		private var _dSlider:DoubleSlider;
		private var fields:String;
		private var addScanTradableClip:MovieClip;
		private var progressBar:ProgressBar;
		

	
		
		public function ScanBuilder(stage:MovieClip, user:String, description:String, data:String, xmlName:String = "Filter") {
			this.xmlRootName = xmlName;
			progressBar = new ProgressBar();
			myStage = stage;
			this.user = user;
			myDescription = description;
			scanConditionArray = new Array();
			databaseComboBox = new ComboBox();
			infoLabel = new TextField  ;
			
			batchResponse  = false;
			loadData = data;
			myTimer  = new Timer(5000, 0)
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			//myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			//^^^^"THIS IS THE TIMER" ^^^^	
			startUpStrategy();
			init();
			
			
		}
		function init():void{
			_dSlider = new DoubleSlider(1950, 2012, 640, true);
			_dSlider.addEventListener(Event.CHANGE, sliderHandler);
			
			this.scaleX = 0.9;
			this.scaleY = 0.9;
			this.x += 20
			this.y += 20
			drawBackground();
			dropShadow = new DropShadowFilter(5,10,20,0.5, 15, 15,1.0);

			createDataBox("Database", 350, 15, "Select Iteration Database", STRATEGY.getCalculatedDB(), new Array(), databaseComboBox, new String(), _database);
			databaseComboBox.width = 210;
			databaseComboBox.dropdownWidth = 200;
			databaseComboBox.addEventListener(Event.CHANGE, databaseChange)
			//this._background.x = 100;
			//this._background.y = 100;
			//setHeaderText();
			scanDataGrid = new DataGrid();
			scanDataGrid.name = myDescription + " Conditions"
			createDataGrid(scanDataGrid, 25,_background.y + 315, myDescription + " Conditions");
			scanDataProvider = new DataProvider();
			scanDataGrid.dataProvider = scanDataProvider;
			
			var runScan:RunScan = new RunScan();
			runScan.x = -60;
			runScan.y = 410
			runScan.filters = [dropShadow]
			runScan.addEventListener(MouseEvent.CLICK, scanRun)
			runScan.buttonMode = true;
			
			_background.addChild(runScan);
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
			textExitClip.addEventListener(MouseEvent.CLICK, close);
			addChild(textExitClip);
			addXmlDisplay();
			expandMe();
			_dSlider.x = 200;
			_dSlider.y = 450;
			_background.addChild(_dSlider)
			myStage.parent.addChild(this);
			_dSlider.setNewDates(new Array(1980, 1996));
		}
		function sliderHandler(event:Event):void {
			var newDates:Array = new Array(_dSlider.minimumValue, _dSlider.maximumValue);
		   	
		}
		function addProgressBar(xloca:Number, yloca:Number):void{
			progressBar.move(xloca, yloca);
			progressBar.height = 20;
			progressBar.mode = "manual";
			progressBar.addEventListener(Event.COMPLETE, handleProgressComplete);
			addChild(progressBar);
			var filter:BlurFilter = new BlurFilter()
			_background.filters = [filter];
		}
		function handleProgressComplete(event:Event = null):void{
			var bgFArray:Array = _background.filters;
			for(var bgFArrayIndex:int = 0; bgFArrayIndex < bgFArray.length; bgFArrayIndex++){
			}
			
		}
		function addXmlDisplay():void{
			xmlDisplay = new TextField();
			xmlDisplay.background = true;
			xmlDisplay.backgroundColor = 0xFFFFFF;
			xmlDisplay.width = 325;
			xmlDisplay.x = 500;
			xmlDisplay.y = 300;
			xmlDisplay.text = breakdownXML(new XML(this.loadData));
			//addChild(xmlDisplay);
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
		function close(event:Event):void
		{
			parent.removeChild(this);
			myTimer.stop();
		}
		function scanRun(event:Event):void{
			
			this.submitXML = new XML(this.setXML());
			pullRequest();
 		}
		function pullRequest():void{
			
			var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/stockscreener?daterange=all&user=" + this.user + "&rand=" +(Math.random()*10000).toString());
			trace("-------------------------------------- The Query submitted was " + xmlScriptLoader.url + "----------------------------------------");
			xmlScriptLoader.data = submitXML;
			trace(submitXML)
			xmlScriptLoader.contentType = "text/xml";
			xmlScriptLoader.method = URLRequestMethod.POST;
			
			var xmlLoader:URLLoader = new URLLoader();
	
			xmlLoader.addEventListener(Event.COMPLETE, handleXMLLoad)
			xmlLoader.load(xmlScriptLoader)
		}
		function handleXMLLoad(event:Event):void{
			pollCount = 0;
			batchNo = Number(event.target.data);
			myTimer.start();
			addProgressBar(350,250);
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
				trace(ready_true);
				var readyTrueSplit:Array = ready_true.split("-");
				progressBar.setProgress(readyTrueSplit[0], 100);
				
			
				if(batchReady(ready_true)){
					trace("batch is ready")
					myTimer.stop();
					var xmlScriptLoader:URLRequest = new URLRequest("http://backend.chickenkiller.com:8080/sample/getscanxml?id=" +_batchNo + "&" + Math.random().toString());
					xmlScriptLoader.contentType = "text/xml";
					xmlScriptLoader.method = URLRequestMethod.POST;
					
					var xmlLoader2:URLLoader = new URLLoader();
					
					xmlLoader2.addEventListener(Event.COMPLETE, handleScanReady)
					xmlLoader2.load(xmlScriptLoader)
					
				}
				
			}
		
		}
		function handleScanReady(event:Event):void{
		
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
		
		function handleSubmit(event:CustomEvent):void{
			var date:Date = new Date;
			dispatchResults(event.data.toString);
			
		}
		function dispatchResults(_result:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", _result));
		}
		function startUpStrategy():void
		{
			STRATEGY = Strategy.getInstance();
			
			

		}
		public function returnEmConditions():DataProvider{
			return scanDataProvider;
		}
		
		function drawBackground():void{
			_background = new MovieClip();
			_background.alpha = 0;
			_background.graphics.lineStyle(1, 0xCCCCBB);
			_background.graphics.beginFill(0xCCCCCC, 1);
			_background.graphics.drawRect(0,0,900,500);
			_background.graphics.endFill();
			
			//addScanTradableClip = PlaceImage("plusmed.png", newScanEntityBuilder, 0.1, 0.1, _background.width - 40, 50)
			//addScanTradableClip.alpha = 0.4;
			//addScanTradableClip.enabled = false;
			//_background.addChild(addScanTradableClip);
			
			//_background.addChild(PlaceImage("next.png", acceptTrigger, 0.1, 0.1, _background.width - 35,  _background.height - 50));
			//_background.addChild(PlaceImage(, acceptTrigger, 0.1, 0.1, _background.width - 35,  _background.height - 50));doubleAmpersand.png
			addChild(_background);
		}
		
		function newScanEntityBuilder(database:Object):void{
			if(getChildByName("ScanEntityBuilder")){
			   removeChild(getChildByName("ScanEntityBuilder"));
			   }
			var entityBuilder:ScanEntityBuilder = new ScanEntityBuilder(database);
			entityBuilder.name = "ScanEntityBuilder";
			addChild(entityBuilder);
			entityBuilder.addEventListener("ConditionAdded", handleAccept)
			//entityBuilder.x += 50;
			entityBuilder.y += 50;			
		}
		function handleAccept(event:CustomEvent):void{
			var array:Array = event.data;
			scanDataProvider.addItem({"Initial Entity": array[0].Summery, "Math Operator": array[0].MathOp, "Second Entity": array[0].SecondEntSummery, XML: array[0].XML})	
			
		}
		public function setXML():XML{
			var databaseXML:XML = new XML(<DB/>)
			databaseXML.appendChild(_database);
			if(scanDataProvider.length > 0)
			{
				scanConditionXML = new XML(<{this.xmlRootName}/>);
				
				var tempXML:XML = new XML(scanDataProvider.getItemAt(0).XML);
				
				scanDataProvider.getItemAt(0).XML = tempXML;
				scanConditionXML.appendChild(scanDataProvider.getItemAt(0).XML);
				for(var scanConditionArrayIndex:Number = 1; scanConditionArrayIndex < scanDataProvider.length; scanConditionArrayIndex++)
				{
					
					scanConditionXML.appendChild(scanDataProvider.getItemAt(scanConditionArrayIndex).XML)
				}
				
			}
			
		scanConditionXML.appendChild(databaseXML);

		return scanConditionXML;
		}
		
		function handleRemove(event:Event):void{
			
			var obj:Object = event.target;
			var index:Number = scanConditionArray.indexOf(event.target);
			scanConditionArray.splice(scanConditionArray.indexOf(event.target), 1)
			for (index; index < scanConditionArray.length; index++)
			{
				scanConditionArray[index].y = scanConditionArray[index].y - obj.height;
			}
			if(scanConditionArray.length == 0){
				reset();
			}
			if(scanConditionArray.length == 0)
			{
				databaseComboBox.enabled = true
				
			}
			
		}
		function reset():void{
			//doneWithScanTradableBtn.enabled = false;
			
		}
		
		/*
		* Assigns properties to a combo box and assigns properties to the datagrid.
		*
		* @ _name. The name given to the combo box
		* @ _control The ComboBox in which to assign properties.
		* @ _xLoc The x location of the ComboBox
		* @ _yLoc The y location of the ComboBox
		* @ _prompt The string for the comboBox to show before any value has been select
		* @ _data The array to fill the comboBox with the selections available.
		* @ _paramenters An array for any selection that has multiple parameter fields. Text fields are added to this Array as well as the movie clip
		* @ parameterString The the string to hold the parameters(if any). The parameters are parsed from the textfields and added to this string.
		* @ selection The the string to hold the selected value.
		*
		* @ return void
		*/
		function createDataBox(_name:String, _xLoca:Number, _yLoca:Number,
		_prompt:String, _data:Array, _paramenters:Array,
		_control:ComboBox, parameterString:String, selection:String):void
		{
			var myFormatBeige:TextFormat = new TextFormat();
			myFormatBeige.font = "Arial";
			myFormatBeige.size = 8;
			myFormatBeige.color = 0x000000;
			_control.name = _name;
			_control.dropdownWidth = 200;
			_control.width = 210;
			_control.move(_xLoca, _yLoca);
			_control.prompt = _prompt;
			_control.dataProvider = new DataProvider(_data);//put the array here
			_control.dataProvider.sortOn("HumanName");
			_control.setStyle("backgroundColor","0x330000");
			_control.labelField = "HumanName";
			_background.addChild(_control);
			
			_control.addEventListener(Event.CHANGE,function(event:Event){changeHandler(event,
			_paramenters, _control, parameterString, selection)});
			_control.alpha = 1;

		}
		function databaseChange(event:Event):void
		{
			
			var database:Object = event.target.selectedItem;
			
			_database = database.DataName;
			newScanEntityBuilder(database);

		
		}
		
		function changeHandler(event:Event, parameterArray:Array, object:Object, parameterString:String, selection:String):void
		{
			var t:Object = event.target.selectedItem;
			selection = t.DataName;
			setLabel(t);
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
		public function returnHeader():Sprite{
			return headerClip;
		}
		function expandHeader(event:MouseEvent):void{
			expandMe();
		}
		public function expandMe():void{
			_background.alpha = 1;
			_background.y = 0;
			_background.enabled = true;
			
		}
		public function collapseMe():void{
			_background.alpha = 0;
			_background.y = 1500;
			_background.enabled = false;
			
		}
		function collapseHeader(event:MouseEvent):void{
			collapseMe();
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
			col2.cellRenderer = MultiLineCell;			var redX:Class = getDefinitionByName("red_X2") as Class;
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
				_container.mouseChildren = false;
				_container.buttonMode = true;
				//_container.addEventListener(MouseEvent.CLICK, _function);
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
		
		function setDates(database:String, entity:String):void{
			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/ServiceFlash?TASK=daterange&DBS="+ database + "&ENTITY=" + entity);
			urlDriver.addEventListener(CustomEvent.QUERYREADY, dateHandler);
		}
		function dateHandler(e:CustomEvent)
		{
			//this.startDateFull = "ALL";
			//this.endDateFull = "NOW";
			var dateD:String = e.data;
			var dateData:Array = dateD.split(",");
			startDateYear = dateData[0].substr(0,4);
			endDateYear = dateData[1].substr(0,4);
			startDateMonth = dateData[0].substr(5,6); 
			endDateMonth = dateData[1].substr(5,5);
			startDateFull = startDateYear + "-" + startDateMonth + "-" + "01"
			endDateFull = endDateYear + "-" + endDateMonth + "-" + "01"			
		}
		
	
		function setDateBoxes():void{
			MonthsArray = new Array("January", "February", "March", "April",
			"May", "June", "July", "August", "September", "October", "November",
			"December");

			begin_monthCB = new ComboBox();
			begin_monthCB.prompt = "Start Month";
			begin_monthCB.x = 145;
			begin_monthCB.y = 450;
			//_background.addChild(begin_monthCB);
			begin_monthCB.dataProvider = new DataProvider(MonthsArray);
			begin_monthCB.addEventListener(Event.CHANGE, SetBeginMonth);
			//begin_monthCB.filters = [fltDropShadow];
			begin_yearCB = new ComboBox();
			begin_yearCB.prompt = "Start Year";
			begin_yearCB.x = 260;
			begin_yearCB.y = 450;
			begin_yearCB.dataProvider = new DataProvider(setStartYears(1990, 2011));
			//begin_yearCB.addEventListener(Event.CHANGE, SetStartYear);
			//_background.addChild(begin_yearCB);
			
			
			end_monthCB = new ComboBox();
			end_monthCB.prompt = "End Month";
			end_monthCB.x = 465;
			end_monthCB.y = 450;
			end_monthCB.dataProvider = new DataProvider(MonthsArray);
			end_monthCB.addEventListener(Event.CHANGE, SetEndMonth);
			//_background.addChild(end_monthCB);

			end_yearCB = new ComboBox();
			end_yearCB.prompt = "End Year";
			end_yearCB.x = 580;
			end_yearCB.y = 450;
			//_background.addChild(end_yearCB);
			end_yearCB.dataProvider = new DataProvider(setStartYears(1975, 2011));
			end_yearCB.addEventListener(Event.CHANGE, SetEndYear);
		}
		
		function SetBeginMonth(e:Event):void
		{
			startDateMonth = (e.currentTarget.selectedIndex + 1).toString();
			startDateFull = startDateYear + "-" + startDateMonth + "-" + "01"
				
		}
		function SetEndMonth(e:Event):void
		{
			endDateMonth = (e.currentTarget.selectedIndex + 1).toString();
			endDateFull = endDateYear + "-" + endDateMonth + "-" + "01"	
		}
		
		function SetEndYear(e:Event):void
		{
			endDateYear = e.currentTarget.value;
			endDateFull = endDateYear + "-" + endDateMonth + "-" + "01"	
			
		}
		
		function setEndYears(startYear:Number, endYear:Number):Array
		{
			var temp:Array = new Array();
			for (var years:Number = endYear; years > startYear - 1; years--)
			{
				temp.push(years.toString());
			}

			return temp;
		}
		function setStartYears(startYear:Number, endYear:Number):Array
		{
			var temp:Array = new Array();
			for (var years:Number = startYear; years < endYear + 1; years++)
			{
				temp.push(years.toString());
			}

			return temp;
		}
	}
	
}
