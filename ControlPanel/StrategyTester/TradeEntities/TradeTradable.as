package ControlPanel.StrategyTester.TradeEntities{
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	import fl.controls.TextInput;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.filters.*;
	import flash.utils.getDefinitionByName;
	import fl.controls.Label;
	import flash.text.AntiAliasType;
	import fl.events.SliderEvent;
	import com.yahoo.astra.fl.controls.AutoComplete;
	import flash.text.*
	import fl.controls.Button;
	import ControlPanel.CommonFiles.Util.*
	import ControlPanel.CommonFiles.CandleStick.*

	
	public class TradeTradable extends MovieClip{
		
		private var STRATEGY:Strategy;
		private var CONDITION_STRING:String;
		private var _TradableEntity:String;
		private var _Treatment:String;
		private var _Database:String;
		private var _MathOperator:String;
		private var _OHLCVOperator:String;
		private var _candleOperator:String;
		private var _HumanTradableEntity:String = "";
		private var _HumanTreatment:String = "";
		private var _HumanDatabase:String = "";
		private var _HumanMathOperator:String = "";
		private var _HumanOHLCVOperator:String = "";
		private var _HumancandleOperator:String = "";
		private var mathOpsParameters:Array;
		private var mathOpsParameters_String:String;
		private var treatmentsParameter:Array;
		private var treatmentsParameter_String:String;
		private var textDescription:TextField;
		private var infoLabel:TextField;
		private var databaseComboBox:ComboBox;
		private var mathOpsComboBox:ComboBox;
		private var treatmentComboBox:ComboBox;
		private var ohlcv:ComboBox;
		private var autoComplete:AutoComplete;
		private var isCandle:Boolean;
		private var candleStick:Candlestick;
		public var condition_xml:XML;
		private var discriptionLabel:String;
		private var candlePrameters:String;
		private var isCompared:Boolean;
		private var condEntity:String;
		private var type:String = "Not Selected";
		private var displayText:TextField;
		private var isEntityComparable:Boolean;
		private var isComparedEntity:Boolean;
		
		
		public function TradeTradable(isComparedEntity:Boolean) {
			this.isComparedEntity = isComparedEntity;
			STRATEGY = Strategy.getInstance();
			isCompared = new Boolean(true);
			textDescription = new TextField();
			infoLabel = new TextField  ;
			_TradableEntity = "";
			_Treatment = "";
			_Database = "";
			_MathOperator = "";
			isEntityComparable = new Boolean();
			databaseComboBox = new ComboBox();
			treatmentComboBox = new ComboBox();
			mathOpsComboBox = new ComboBox();
			ohlcv = new ComboBox();
			autoComplete = new AutoComplete();
			addChild(autoComplete);
			autoComplete.width = 200;
			autoComplete.move(175, 15);
			
			mathOpsParameters = new Array();
			treatmentsParameter = new Array();
			mathOpsParameters_String = new String();
			isCandle = false;
			//createTextField("RemoveClip", "[Remove]", 400, 0, remove)
			displayText = createTextField("DisplayClip", "Selections", 400, 50, remove, false);
			init();
			
		}
		public function removeRemoveClip():void{
			if(getChildByName("RemoveClip")){
			   removeChild(getChildByName("RemoveClip"));
			   //dispatch("ComparedEntityRemoved", new Array);
			   }
		}
		public function addRemoveClip():void{
			if(!getChildByName("RemoveClip")){
			   createTextField("RemoveClip", "[Remove]", 400, 0, remove)
			   //dispatch("ComparedEntityRemoved", new Array);
			   }
		}
		public function destroySelf():void{
			if(this.parent){
			parent.removeChild(this);
			}
		}
		function createSummery():String{
			
			var summery:String;
			
			if(isCandle){
				summery = _HumanTradableEntity + " in "+ _HumanDatabase  + " with CandleStick Pattern: " + _candleOperator;
			}
			else{
			_HumanTreatment += " " + this.concactParameters(treatmentsParameter);
			summery =  _HumanTradableEntity + " in " + _HumanDatabase + " with " + _HumanTreatment;
			}
			return summery;
		}
		function formatDisplay():String{
			var string = "Database: " + _HumanDatabase + "\n" + "Entity : " + _HumanTradableEntity + "\n" + "Treatment: " + _HumanTreatment + "\n" + "Type of Data: " + type +  "\n" + "Operator: " + _HumanMathOperator;
			displayText.text = string;
			return string;
		}
		function createTextField(name:String, text:String, xLoca:Number, yLoca:Number, _function:Function, isButton:Boolean = true, color:Number =0x0033CC , fontSize:Number = 15 ):*{
			var entityText:TextField = new TextField();
			entityText.text = text;
			entityText.autoSize = "center";
			var myFormat:TextFormat = new TextFormat();
			//myFormat.size = 30;
			myFormat.color = color;
			//myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = fontSize;
			myFormat.font = header_font.fontName;
			entityText.setTextFormat(myFormat);
			//entityText.x = xLoca;
			//entityText.y = yLoca;
			entityText.alpha = 0;
			entityText.restrict = "0-9";
			entityText.name = "TextClipText";
			//entityText.mouseEnabled = true;
			
			var entityTextClip:MovieClip = new MovieClip();
			entityTextClip.name = name;
			entityTextClip.addChild(entityText);
			if(isButton){
				entityTextClip.mouseChildren = false;
				entityTextClip.buttonMode = true;
				entityTextClip.addEventListener(MouseEvent.CLICK, _function);
				addChild(entityTextClip);
				return entityTextClip;
			}
			else{
				//addChild(entityText);
				return entityText;
			}
			
		}
		public function updateMySettings():void{
			
		}
		function remove(event:Event):void
		{
			dispatch("RemovedButtonClicked", new Array)
			parent.removeChild(this);
		}
		function init():void{
			createDataBox("Database", 0, 15, "Select Database", STRATEGY.GetDatabase(), new Array(), databaseComboBox, new String(), _Database);
			
			addEventListeners();
			
		}
		function strat(event:Event):void{
			init();
			
		}
		
		function clearArrayFromStage(array:Array):void{
			for each(var mv:Object in array){
				if (mv.stage){
					mv.parent.removeChild(mv);
				}
			}
			array.splice(0);
		}
		
		function addEventListeners():void
		{
			databaseComboBox.addEventListener(Event.CHANGE, databaseChange);
			mathOpsComboBox.addEventListener(Event.CHANGE, mathOpsChange);
			treatmentComboBox.addEventListener(Event.CHANGE, treatmentChange);
		}
		
		function databaseChange(event:Event):void
		{
			if(treatmentComboBox.stage){
				resetTreatment();
				removeMathOps();
			}
			var database:Object = event.target.selectedItem;
			dispatchEvent(new CustomEvent("databaseSelected", database));
			_Database = database.DataName;
			_HumanDatabase = database.HumanName;
			setUnderLyingEntities(_Database);
			formatDisplay();
		}
		function resetTreatment():void{
			if(treatmentComboBox.stage){
				removeChild(treatmentComboBox);
				clearArrayFromStage(treatmentsParameter);
				removeFields();
				formatDisplay();
			}
		}
		function mathOpsChange(event:Event):void
		{
			var mathOp:Object = event.target.selectedItem;
			
			
			_MathOperator = mathOp.DataName;
			_HumanMathOperator = mathOp.HumanName;
			formatDisplay();
			dispatch("enableDone", new Array)

		}
		
		function treatmentChange(event:Event):void
		{
			var treatment:Object = event.target.selectedItem;
			dispatchEvent(new CustomEvent("treatmentSelected", treatment));
			_Treatment = treatment.DataName;
			_HumanTreatment = treatment.HumanName;
			retrieveFields(_TradableEntity, _Database, _Treatment);
			formatDisplay();
		}
		
		function changeHandler(event:Event, parameterArray:Array, object:Object, parameterString:String, selection:String):void
		{

			var t:Object = event.target.selectedItem;
			selection = t.DataName;
			var defaults:Array;

			if (t.defaults)
			{
				defaults = t.defaults;
			}
			drawParameterFields(t.parameters, parameterArray,t.paramDescriptions, object, parameterString, defaults);
			setLabel(t);
			//checkHasDatabase(t);

		}
		function addTreatment(data:Array):void{
			
			treatmentComboBox = new ComboBox();
			createDataBox("Treatments", 0, 65, "Select Treatment", data, treatmentsParameter, treatmentComboBox, treatmentsParameter_String = "", _Treatment);
			treatmentComboBox.addEventListener(Event.CHANGE, treatmentChange);			
		}
		function setLabel(obj:Object):void
		{

			infoLabel.autoSize = "left";
			infoLabel.x = -225;
			infoLabel.y = -19;
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
		function setUnderLyingEntities(entityDatabase:String):void
		{

			autoComplete.autoFillEnabled = true;
			autoComplete.text = "";
			autoComplete.dropdown.addEventListener(Event.CHANGE, handleAutoComplete);
			autoComplete.labelField = "HumanName";

			if (entityDatabase =="STOCK")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetStocks());
			}
			if (entityDatabase =="COMMODITY")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetCommodities());

			}
			if (entityDatabase =="BOND")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetBonds());

			}
			if (entityDatabase =="CURRENCY")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetCurrencies());

			}
			if (entityDatabase =="INDEX")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetIndex());
			}

		}
		function handleAutoComplete(event:Event):void
		{
			resetTreatment();
			var tradableEntity:Object = event.target.getItemAt(0) as Object
			_TradableEntity = tradableEntity.DataName;
			_HumanTradableEntity = tradableEntity.HumanName
			retrieveTreatments(this._Database,_TradableEntity);
			formatDisplay();
			dispatchEvent(new CustomEvent("tradableSelected", _TradableEntity));
			
		}
		function createDataBox(_name:String, _xLoca:Number, _yLoca:Number,
		_prompt:String, _data:Array, _paramenters:Array,
		_control:ComboBox, parameterString:String, selection:String):void
		{
			var myFormatBeige:TextFormat = new TextFormat();
			myFormatBeige.font = "Arial";
			myFormatBeige.size = 8;
			myFormatBeige.color = 0x000000;
			_control.name = _name;
			_control.dropdownWidth = 175;
			_control.width = 175;
			_control.move(_xLoca, _yLoca);
			_control.prompt = _prompt;
			_control.dataProvider = new DataProvider(_data);//put the array here
			_control.setStyle("backgroundColor","0x330000");
			_control.labelField = "HumanName";
			addChild(_control);
			if (_control.name != "OHLCV")
			{
				_control.addEventListener(Event.CHANGE,function(event:Event){changeHandler(event,
				_paramenters, _control, parameterString, selection)});
			}



			_control.alpha = 1;

		}
		/**
		* Draws inputText fields. And adds them to an array
		*
		* @param numFields. The number of fields to draw
		* @param fieldArray The the array in which to add the textFields
		*
		* returns nothing.
		*/
		function drawParameterFields(numFields:String, fieldArray:Array,
		parameterDescriptions:Array, object:Object, parameterString:String, defaults:Array = null):void
		{

			if(getChildByName("Entity")){
			   removeChild(getChildByName("Entity"));
			   dispatch("ComparedSingleEntityRemoved", new Array);
			   }
			
			var leadParaNumber:String = "G";
			if (numFields)
			{
					leadParaNumber = numFields.substr(2,1);
					numFields = numFields.substr(0,1);
			}
			//if there are inputFields on the screen already, remove them.
			if (fieldArray.length > 0)
			{
				for (var j:int; j < fieldArray.length; j++)
				{
					removeChild(fieldArray[j]);
				}
			}
			
			//clear the array
			fieldArray.splice(0, fieldArray.length);
			//create and add properties to the fields;
			var xLoca:Number = object.x + object.width + 15;
			for (var i:int = 0; i < Number(numFields); i++)
			{
				
				if(parameterDescriptions[i] == "ENTITY"){
					isEntityComparable = true;
					var entityText:TextField = new TextField();
					entityText.text = "Entity";
					entityText.autoSize = "center";
					var myFormat:TextFormat = new TextFormat();
					myFormat.size = 30;
					myFormat.color = 0x0033CC;
					//myFormat.italic = true;
					var header_font = new HeaderFont;
					myFormat.size = 15;
					myFormat.font = header_font.fontName;
					entityText.setTextFormat(myFormat);
					entityText.x = xLoca;
					entityText.alpha = 0;
					//entityText.y = 5000;
					//xLoca += 50;
					//entityText.mouseEnabled = true;
					
					var entityTextClip:MovieClip = new MovieClip();
					entityTextClip.addChild(entityText);
					entityTextClip.mouseChildren = false;
					entityTextClip.buttonMode = true;
					//entityTextClip.addEventListener(MouseEvent.CLICK, handleEntity);
					entityTextClip.name = "Entity"
					//dispatch("CompareEntity", new Array());
					addChild(entityTextClip);
					dispatch("ComparedSingleEntityAdded", new Array);
				}
				if(parameterDescriptions[i] != "ENTITY") {
						isEntityComparable = false;
						//initialize the input field for the parameter
						var operatorInputField:TextInput = new TextInput ();
				
						var tf:TextFormat = new TextFormat();
						tf.color = 0x000000;
						tf.font = "Verdana";
						tf.size = 12;
						tf.align = "center";
						tf.italic = true;
						operatorInputField.setStyle("textFormat", tf);
		
						operatorInputField.name = parameterDescriptions[i];
						
						//operatorInputField.text = defaults[i];
						operatorInputField.width = 50;
						//operatorInputField.restrict = ;
						operatorInputField.maxChars = 6;
						operatorInputField.y = object.y;
						operatorInputField.x = xLoca;
						xLoca += 50;
						operatorInputField.restrict = "[0-9.\\-]";
						operatorInputField.text = "0";
		
						if (defaults[i])
						{
							operatorInputField.text = defaults[i];
						}
		
						fieldArray.push(operatorInputField);
						if (i.toString() == leadParaNumber)
						{
							
						}
						operatorInputField.addEventListener(MouseEvent.MOUSE_OVER, description);
						operatorInputField.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
						
						addChild(operatorInputField);
				}

			}
			/*for (var j:Number = 0; j < numChildren; j++){
				trace ('\t|\t ' +j+'.\t name:' + getChildAt(j).name + '\t type:' + typeof (getChildAt(j))+ '\t' + getChildAt(j));
			}*/
			
			
			   
			   //isEntityComparable
			
		}
		public function resetMathOps():void{
			addMathOps();
			formatDisplay();
		}
		function handleEntity(event:Event):void{
			dispatch("CompareEntity", new Array());
		}
		function description(e:Event):void
		{
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = "arial";
			textDescription.defaultTextFormat = myFormat;
			textDescription.x = mouseX;
			textDescription.y = mouseY + 45;
			textDescription.height = 20;
			textDescription.autoSize = "left";
			textDescription.text = e.currentTarget.name;
			//textDescription.font = "aral"
			textDescription.background = true;
			textDescription.alpha = 0;
			var tween:Tween = new Tween(textDescription,
			                       "alpha",None.easeNone,0,1,1,true);

			textDescription.border = true;
			addChildAt(textDescription, numChildren - 1);
			setChildIndex(textDescription, numChildren - 1);

			//(textDescription, this.numChildren - 1)

		}
		function retrieveTreatments(database:String, entity:String){

			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/ServiceFlash?TASK=TREATS_FOR_ENTITY&DBS=" + database + "&SYMBOL=" + entity);

			urlDriver.addEventListener(CustomEvent.QUERYREADY, retrieveTreatmentsHandler);
		}
		function retrieveTreatmentsHandler(event:CustomEvent):void{
			
			var treatments:Array = STRATEGY.createTreatmentsDictionary(event.data);
			addTreatment(treatments);
			
		}
		function retrieveFields(symbol:String, database:String, treatment:String):void{
			
			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/ServiceFlash?TASK=DATAFIELDS&SYMBOL=" + symbol + "&DBS="  + database + "&TREAT=" + treatment);

			urlDriver.addEventListener(CustomEvent.QUERYREADY, retrieveFieldsHandler);
			
		}
		function retrieveFieldsHandler(event:CustomEvent):void{
			
			formatDisplay();
			removeMathOps();
			
			addFields(event.data);
		}
		function addFields(fieldData:String):void{
			removeFields();
			formatDisplay();
			if(!fieldData == ""){
				removeMathOps();
				var fieldsArray:Array = parseFieldData(fieldData);
				createDataBox("OHLCV", 0, 115, "Select a Field", fieldsArray, new Array(), ohlcv, "CandleString", _OHLCVOperator);
				ohlcv.addEventListener(Event.CHANGE, handleOHLCVchange)
				ohlcv.labelField = "name";
				ohlcv.width = 150
				ohlcv.dropdownWidth = 100
			}
			else{
			addMathOps();
			formatDisplay();
			}
		}
		public function setIsCompared(_isCompared:Boolean):void{
			this.isCompared = _isCompared;
		}
		function handleOHLCVchange(event:Event):void
		{
			switch(event.currentTarget.selectedItem.name.toLocaleLowerCase())
			{
				
				case "candle":
				
				isCandle = true;
				type = "tbl"
				dispatchEvent(new Event("candle"));
				 doNewCandle();
				 removeMathOps();
				 
				break;
				
				case "open":
				isCandle = false;
				type = "open";
				
					addMathOps()
				
				break;
				
				case "high":
				isCandle = false;
				type = "high";
					addMathOps()
				
				break;
				
				case "low":
				type = "low"
				isCandle = false;
				
					addMathOps()
				
				break;
				
				case "close":
				isCandle = false;
				type = "close"
				
					addMathOps()
				
				break;
				
				case "volume":
				isCandle = false;
				type = "volume"
				
					addMathOps()
				
				break;
				
				case "closevolume":
				isCandle = false;
				type = "closevolume"
				
					addMathOps()
				
				break;
			
			}
			formatDisplay();
			
		}
		function doNewCandle():void
			{
				
				candleStick  = new Candlestick(this);
				addChild(candleStick);
				candleStick.addEventListener("PreSelectedCandle", handlePreSelectedCandle);
				candleStick.addEventListener("customCandleResults", handleCustomCandle);
				candleStick.move(15, 500);
			}
			function handlePreSelectedCandle(event:CustomEvent):void{
			var preSelectedCandleType:String = event.data;
			_candleOperator = preSelectedCandleType;
			candlePrameters = "";
			
			dispatch("CandleCreationComplete", new Array)
		}
		function handleCustomCandle(event:CustomEvent):void{
			var customCandleParameters:String = event.data;
			_candleOperator = "is_custom";
			candlePrameters = customCandleParameters;
			this.dispatch("CandleCreationComplete", new Array)
			//var candleS:Candlestick = new Candlestick(this.myStage);
		}
		function addMathOps():void{
			
			if(!isComparedEntity){
				
					if(getChildByName("Entity")){
					   removeChild(getChildByName("Entity"));
					   dispatch("ComparedEntityRemoved", new Array);
					   }
					removeMathOps();
					createDataBox("Math Operators", 0, 165, "Select a Math Operator", STRATEGY.GetMathOps(), mathOpsParameters, mathOpsComboBox, mathOpsParameters_String, _MathOperator);
					mathOpsComboBox.width = 200;
					mathOpsComboBox.dropdownWidth = 200
			}
		}
		public function updateFieldOptions():void{
			//ohlcv.dataProvider = new DataProvider(); 
			var cbBox:ComboBox = removeFields() as ComboBox;
			var tempDataProvider:DataProvider = cbBox.dataProvider;
			var temp:String = "";
			for(var index:Number = 0; index < tempDataProvider.length; index++){
				temp += cbBox.dataProvider.getItemAt(index).name + ',';
			}
			
		}
		function removeMathOps():void{
			if(mathOpsComboBox.stage){
				clearArrayFromStage(mathOpsParameters);
				removeChild(mathOpsComboBox);
			}
		}
		function parseFieldData(fieldData:String, delim:String = ','):Array{
			var temp:Array = fieldData.split(delim);
			if(isComparedEntity){
				for(var index:Number = 0; index < temp.length; index++){
					if(temp[index] == "tbl"){
				
						temp.pop()
					}
				}
			}
			for(var i:Number = 0; i < temp.length; i++){
				temp[i] = ({name: temp[i]})
			}
			return temp;
		}
		function removeFields():Object{
			if(ohlcv.stage){
				removeChild(ohlcv);
			}
			
			return ohlcv
		}
		function setDateRange(database:String, entity:String):void{

			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/ServiceFlash?TASK=daterange&DBS="+ database + "&ENTITY=" + entity);

			urlDriver.addEventListener(CustomEvent.QUERYREADY, dateHandler);
		}
		function dateHandler(e:CustomEvent)
		{

			var dateD:String = e.data;
			var dateData:Array = dateD.split(",");
			dispatch("DatesRecieved", dateData);
				
		}
		
		function dispatch(dispatchString:String, data:*){
			
			var dateArray:Array = new Array();
			if(data[0]){
			dateArray = (data[0].substring(0,4), data[1].substring(0,4))
			
			}
			
			dispatchEvent(new CustomEvent(dispatchString, dateArray));
		}
		function removeDescription(e:Event):void
		{
			removeChild(textDescription);
		}

		function setParameterValues(event:Event, parameterArray:Array, parameterArray_String:String):void
		{
			//THIS IS WHERE THE VALUES FOR MATH OPERS COME FROM
			for (var object:Object in parameterArray)
			{
				parameterArray_String +=  parameterArray[object].text + ",";
			}
		}
		
		function placeImage(_className:String, _function:Function):MovieClip
		{
			var _container:MovieClip = new MovieClip();
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());
			_container.name = _className;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.addEventListener(MouseEvent.CLICK, _function);
			return _container;
		}
		function closeInfo(event:Event):void
		{
			var object:Object = event.target as Object;
			var tw:Tween = new
			Tween(infoLabel,"alpha",None.easeNone,infoLabel.alpha,0,1,true);

			//removeChild(infoLabel)

		}
		
		public function setXML():Array
		{

			var tPara:String;
			var iPara:String;
			
			if (treatmentsParameter[0] != undefined)
			{


				
				if (treatmentsParameter[0].text != "")
				{
					
					tPara = "-" + concactParameters(treatmentsParameter);
					
				}
			}
			else
			{
				tPara = concactParameters(treatmentsParameter);
			}

			
			
			var myArray:Array =  new Array();
			if(!isCandle){
				condition_xml = new XML(<Condition/>);
				condEntity = _TradableEntity + "()[" + _Treatment + tPara + "]{" + _Database + "}"	
				discriptionLabel = condEntity;
				var fullTreatment:String = _Treatment + tPara;
				myArray.push({xmlNodeName: "CondEntity", value: condEntity});
				myArray.push({xmlNodeName: "CondOperator", value: _MathOperator});
				myArray.push({xmlNodeName: "Parameter", value: concactParameters(mathOpsParameters)});
				
			}
			if(isCandle){
				condition_xml = new XML(<Condition/>);
			    condEntity = _TradableEntity + "()[]{" + _Database + "}"	
				discriptionLabel = "Candle";
				myArray.push({xmlNodeName: "CondEntity", value: condEntity});
				myArray.push({xmlNodeName: "CondOperator", value: _candleOperator});
				myArray.push({xmlNodeName: "Parameter", value: candlePrameters});
							   
			   }
			for each (var item:Object in myArray)
			{
				condition_xml[item.xmlNodeName] = item.value.toString();
			}
			if(this.ohlcv.selectedItem){
				type = this.ohlcv.selectedItem.name;
			}
			if(!this.ohlcv.selectedItem){
				type = "tbl";
			}
			
			var xmlArray:Array
			condition_xml.child("CondEntity"). @ ["type"] = type;
			discriptionLabel += " (" + type + ") " + _MathOperator + " - " + concactParameters(mathOpsParameters)
			dispatchEvent(new CustomEvent("setXML", condition_xml));
			if(isCandle){
				xmlArray = new Array({XML: condition_xml, Summery: createSummery(), MathOp: _candleOperator, Parameters: "Candlestick Pattern"})
			}
			if(!isCandle){
				_MathOperator += " " + concactParameters(mathOpsParameters);
				xmlArray = new Array({XML: condition_xml, Summery: createSummery(), MathOp: _MathOperator, Parameters: concactParameters(mathOpsParameters), Treatment: fullTreatment})
			}
			return xmlArray;
		}
		public function getIsCandle():Boolean{
			return(isCandle);
		}
		function concactParameters(array:Array):String
		{
			
			var temp:String = "";
			if(array[0] != undefined){
				if(array[0].text != "")
				{
					for each (var inputField:Object in array)
					{
						temp +=  inputField.text + ",";
					}
						temp = temp.substring(temp.length - 1, -  temp.length);
				}
				if(array[0].text == "")
				{
					temp = "0";
					
				}
			}
			return temp;
		}
		public function getConditionalEntityArray():Array{
			var temp = new Array(this.type, this.condEntity);
			return temp;
		}
		public function getInfoLabel():String{
			return discriptionLabel;
		}		

	}
	
}
