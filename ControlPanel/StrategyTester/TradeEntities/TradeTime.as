package ControlPanel.StrategyTester.TradeEntities {
	import flash.display.MovieClip;
	import flash.text.*
	import fl.controls.*
	import flash.events.*
	import fl.data.DataProvider
	import ControlPanel.CommonFiles.Util.*
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class TradeTime extends MovieClip{

		private var isComparedEntity:Boolean;
		private var STRATEGY:Strategy;
		private var CONDITION_STRING:String;
		private var _TimeOperator:String;
		private var _HumanTimeOperator:String = "";
		private var timeOpsParameters:Array;
		private var timeOpsParameters_String:String;
		private var textDescription:TextField;
		private var infoLabel:TextField;
		private var timeOpsComboBox:ComboBox;
		public var condition_xml:XML;
		private var discriptionLabel:String;
		private var isEntityComparable:Boolean;
		private var days:Array;
		private var dayComboBox:ComboBox;
		private var dayOpsParameters:Array;
		private var dayOpsParameters_String:String;
		private var inTrade:Boolean;
		
		
		public function TradeTime(isComparedEntity:Boolean, inTrade:Boolean = true) {
			this.isComparedEntity = isComparedEntity;
			this.inTrade = inTrade
			trace("The times inTrade value is: " + inTrade);
			
			setDayValues();
			
			STRATEGY = Strategy.getInstance();
			
			textDescription = new TextField();
			infoLabel = new TextField  ;
			_TimeOperator = "The Op Has Not Been Changed";
			isEntityComparable = new Boolean();
		
			timeOpsComboBox = new ComboBox();
			dayComboBox = new ComboBox();
			
			
			timeOpsParameters = new Array();
			timeOpsParameters_String = new String();
			init();
		}
		function setDayValues():Array{
			days = new Array()
			days.push({HumanName: "Sunday", DataName: 1});
			days.push({HumanName: "Monday", DataName: 2});
			days.push({HumanName: "Tuesday", DataName: 3});
			days.push({HumanName: "Wednesday", DataName: 4});
			days.push({HumanName: "Thursday", DataName: 5});
			days.push({HumanName: "Friday", DataName: 6});
			days.push({HumanName: "Saturday", DataName: 7});
			return days;
		}
		function remove(event:Event):void
		{
			dispatch("RemovedButtonClicked", new Array)
			parent.removeChild(this);
		}
		function init():void{
			var timeOps:Array;
			if(inTrade){
				timeOps = STRATEGY.GetInTradeTimeOps();
			}
			else{
				timeOps = STRATEGY.GetTimeOptions();
			}
			
			createDataBox("Time Ops", 0, 15, "Select Time", timeOps, timeOpsParameters, timeOpsComboBox, new String(), _TimeOperator);
			
			addEventListeners();
			
		}
		public function getInfoLabel():String{
			return discriptionLabel;
		}
		public function setXML():Array
		{

			var tPara:String;
			var iPara:String;
			
			var myArray:Array =  new Array();
				condition_xml = new XML(<Condition/>);
				var condEntity = "TIME";
				discriptionLabel = condEntity;
				myArray.push({xmlNodeName: "CondEntity", value: condEntity});
				myArray.push({xmlNodeName: "CondOperator", value: _TimeOperator});
				myArray.push({xmlNodeName: "Parameter", value: concactParameters(timeOpsParameters)});
				
			for each (var item:Object in myArray)
			{
				condition_xml[item.xmlNodeName] = item.value.toString();
			}
			
			var type = "te";
		
			
			condition_xml.child("CondEntity"). @ ["type"] = type;
			discriptionLabel += " (" + type + ") " + _TimeOperator + " - " + concactParameters(timeOpsParameters)
			dispatchEvent(new CustomEvent("setXML", condition_xml));
			
				//trace(_TimeOperator) += " " + concactParameters(timeOpsParameters);
				var xmlArray:Array = new Array({XML: condition_xml, Summery: createSummery(), MathOp: _TimeOperator, Parameters: concactParameters(timeOpsParameters), Treatment: "None"})
				
			trace(condition_xml);
			return xmlArray;
		}
		function createSummery():String{
			
			var summery:String;
			
			if(_HumanTimeOperator == "Day of week"){
				var day:String;
				for each(var dayObj:Object in days){
					if(dayObj.DataName == concactParameters(timeOpsParameters)){
						day = dayObj.HumanName
					}
				}
				_HumanTimeOperator += " " + day;
			}
			if(_HumanTimeOperator == "Date between"){
				_HumanTimeOperator += " " + concactParameters(timeOpsParameters, true);
			}
			if(_HumanTimeOperator == "In trade longer than"){
				_HumanTimeOperator += " " + this.concactParameters(timeOpsParameters) + " Days";
			}
			 
			summery = "Time: " +  _HumanTimeOperator
			
			return summery;
		}
		function concactParameters(array:Array, withSlashes:Boolean = false):String
		{
			var temp:String = "";
			if(array[0])
			{
				
				if(array[0] is TextInput)
				{
					
					if(array[0].text == "")
					{
						temp = "0";
					}
					else
					{
						if(!withSlashes)
						{
								
							for each (var inputField:Object in array)
							{
								var noSlash1:String = inputField.text.replace("/", "")
								var noSlash2:String = noSlash1.replace("/", "")
								temp +=  noSlash2 + ",";
							}
						}
						if(withSlashes)
						{
							for each (var inputField:Object in array)
							{
							
							temp +=  inputField.text + ",";
							
							
							}
							
						}
						temp = temp.substring(temp.length - 1, -  temp.length);
						
					}
					
				}
			
			else
				{
					temp = array[0].toString();
				}
			}
			return temp;
		}
		function createDataBox(_name:String, _xLoca:Number, _yLoca:Number,
		_prompt:String, _data:Array, _paramenters:Array,
		_control:ComboBox, parameterString:String, selection:String, isWeekDay:Boolean = false):void
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
			if(!isWeekDay){
				_control.addEventListener(Event.CHANGE,function(event:Event){changeHandler(event,
				_paramenters, _control, parameterString, selection)});
			}
			

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
			if(selection == "IS_DAYOFWEEK"){
				
				_TimeOperator = ""
				if (parameterArray.length > 0)
				{
					for (var j:int; j < parameterArray.length; j++)
					{
						removeChild(parameterArray[j]);
					}
				}
				
			
				createDataBox("Weekdays", 200, 15, "Select Day", setDayValues(), timeOpsParameters, dayComboBox, new String(), _TimeOperator, true);
				dayComboBox.addEventListener(Event.CHANGE, handleDay);
				
				
			}
			else{
				if(getChildByName("Weekdays")){
				removeChild(getChildByName("Weekdays"))
				}
			drawParameterFields(t.parameters, parameterArray,t.paramDescriptions, object, parameterString, defaults);
			}
			//setLabel(t);
			//checkHasDatabase(t);

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
					if(fieldArray[j].stage){
					removeChild(fieldArray[j]);
					}
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
						operatorInputField.width = 70;
						//operatorInputField.restrict = ;
						operatorInputField.maxChars = 5;
						operatorInputField.y = object.y;
						operatorInputField.x = xLoca;
						xLoca += 80;
						operatorInputField.restrict = "[0-9.\\-\\//]";
						operatorInputField.text = "0";
						if(defaults){
							if (defaults[i])
							{
								operatorInputField.text = defaults[i];
							}
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
		function removeDescription(e:Event):void
		{
			removeChild(textDescription);
		}
		function formatDisplay():String{
			var string = "Type of Data: TIME" + "\n" + "Operator: " + _HumanTimeOperator;
			//displayText.text = string;
			return string;
		}
		function dispatch(dispatchString:String, data:*){
			
			var dateArray:Array = new Array();
			if(data[0]){
			dateArray = (data[0].substring(0,4), data[1].substring(0,4))
			
			}
			
			dispatchEvent(new CustomEvent(dispatchString, dateArray));
		}
		function addEventListeners():void
		{
			timeOpsComboBox.addEventListener(Event.CHANGE, timeOpsChange);
		}
		function handleDay(event:Event):void{
			var day:Object = event.target.selectedItem;
			
			timeOpsParameters = new Array();
			timeOpsParameters.push(day.DataName)
		}
		function timeOpsChange(event:Event):void
		{
			var mathOp:Object = event.target.selectedItem;
			_HumanTimeOperator = mathOp.HumanName;
			_TimeOperator = mathOp.DataName;
			formatDisplay();
			dispatch("enableDone", new Array)
		}
		public function destroySelf():void{
			if(this.parent){
			parent.removeChild(this);
			}
		}

	}
	
}
