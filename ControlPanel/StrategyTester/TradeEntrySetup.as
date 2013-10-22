package ControlPanel.StrategyTester
{
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.MouseEvent;
	import fl.controls.TextInput;
	import fl.controls.Label;
	import fl.controls.CheckBox;
	import flash.utils.getDefinitionByName;
	import fl.controls.List;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;
	import com.yahoo.astra.fl.controls.AutoComplete;
	import flash.filters.DropShadowFilter;
	import flash.text.*;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.Slider;
	import flash.geom.*;
	import flash.display.*;
	import ControlPanel.CommonFiles.Util.*
	import ControlPanel.CommonFiles.DoubleSlider.DoubleSlider;
	


	public class TradeEntrySetup extends MovieClip
	{
		private var _Strategy:Strategy;
		private var xmlArray:Array;
		private var autoComplete:AutoComplete;
		private var category:String;
		private var tradSelBox:ComboBox;
		
		private var myBackground:MovieClip;
		private var startDateMonth:String;
		private var startDateYear:String;
		private var endDateMonth:String;
		private var endDateYear:String;
		private var startDateFull:String;
		private var endDateFull:String;
		
		private var dataBaseValue;
		private var NEXT_CONTAINER:Sprite;
		private var _xmlLongShort:String;
		private var _xmlStock:String;
		private var _xmlMaxBet:String;
		private var _xmlMaxDaily:String;
		private var _xmlUE:String;
		private var LONG:RadioButton;
		private var SHORT:RadioButton;
		private var long_short:RadioButtonGroup;
		private var from_Btn:CheckBox;
		private var to_Btn:CheckBox;
		private var history:Array;
		public var headerClip:Sprite;
		private var headerText:TextField;
		private var fullClip:MovieClip;
		private var headerX:Number;
		private var headerY:Number;
		private var maxInvest:Slider;
		private var maxDaily:Slider;
		private var maxInvestValue:TextField;
		private var maxDailyValue:TextField;
		private var submitBtn:Button;
		private var myMask:MovieClip;
		private var myFormat:TextFormat;
		private var header_font;
		private var itChk:CheckBox;
		private var dateSlider:DoubleSlider
		private var myFormatBeige:TextFormat

		public function TradeEntrySetup(_headerXLoca:Number, _headerYLoca:Number)
		{
			_Strategy  = Strategy.getInstance();
			setTextProperties();
			headerX = _headerXLoca;
			headerY = _headerYLoca;
			setUp();
			setShortLong();
			//SetStartChkBx();
			//SetEndChkBx();
			expandMe();
			this.name = "Trade Entry Setup";
			
			
		}
		function setTextProperties():void{
			myFormat = new TextFormat();
			//myFormat.size = 30;
			//myFormat.italic = true;
			//myFormat.bold = true;
			header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			
			myFormatBeige = new TextFormat();
			myFormatBeige.font = "Candara";
			myFormatBeige.size = 12;
			myFormatBeige.color = 0x000000;
		   // myFormatBeige.bold = true;
		}
		/*function drawGradient():void
		{
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xFF0000,0x0000FF];
			var alphas:Array = [1,1];
			var ratios:Array = [0x00,0xFF];
			var matr:Matrix = new Matrix();
			//0, 0, 630, 300, 25, 25
			matr.createGradientBox(630, 300, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			this.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			this.graphics.drawRect(0,0,100,100);
		}
*/
		private function setUp():void
		{

			
			fullClip = new MovieClip();
			startDateMonth = "01";
			startDateYear = "1950";
			endDateMonth = "12";
			endDateYear = "2011";
			category = "";
			startDateFull = "ALL";
			endDateFull = "NOW";
			_xmlLongShort = "";
			_xmlStock = "";
			_xmlMaxBet = "";
			_xmlMaxDaily = "";
			_xmlUE = "";

			NEXT_CONTAINER = new Sprite  ;
			var fltDropShadow = new DropShadowFilter(5, 45, 0x000000, 1, 5, 5,
			1, 3, false, false, false);

			myBackground = new MovieClip  ;
			
			submitBtn = new Button();
			submitBtn.label = "Submit"
			submitBtn.emphasized = true;
			submitBtn.setStyle("icon", BulletCheck);
			submitBtn.enabled = false;
			submitBtn.addEventListener(MouseEvent.CLICK, Next);
			myBackground.addChild(submitBtn);
			//PlaceImage(submitBtn, null, Next, myBackground);

			DrawBackground();
			submitBtn.x = myBackground.x + myBackground.width - 140;
			submitBtn.y = myBackground.y + myBackground.height - 90;
			

			var myFont = new Font();

			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 15;
			myFormat.align = TextFormatAlign.CENTER;
			myFormat.font = myFont.fontName;
			
			createSlider(maxInvest = new Slider, 100, 200, 100, "Total Max Portfolio Exposure", maxInvestValue = new TextField);
			maxInvest.addEventListener(Event.CHANGE, handleMaxInvestSlider);
			createSlider(maxDaily = new Slider, 600, 200, maxInvest.maximum, "Max Daily Portfolio Exposure", maxDailyValue = new TextField);
			maxDaily.enabled = false;
			maxDaily.addEventListener(Event.CHANGE, handleMaxDailySlider);
			dateSlider = new DoubleSlider(1950, 2012, 640, true);
			dateSlider.x = 100;
			dateSlider.y = 340;
			myBackground.addChild(dateSlider);
			setTradabelBx();
			addIterateCheck();
			expandMe();
		}
		function addIterateCheck():void{
				
			itChk = new CheckBox();
			itChk.width = 200;
			itChk.move(530, 18)
			itChk.label = "Iterate over an entire database?"
			itChk.addEventListener(Event.CHANGE, iterateBoxHandler);
			myBackground.addChild(itChk);
		}
		function iterateBoxHandler(event:Event):void{
			
			if(event.currentTarget.selected){
				doIterate();
			}
			if(!event.currentTarget.selected){
				doNoIterate();
			}
		}
		function doIterate():void{
			tradSelBox.dataProvider = new DataProvider(_Strategy.GetInitialDatabase());
			this.autoComplete.enabled = false;
			_xmlStock = "ITERATEALL";
			
		}
		function doNoIterate():void{
			tradSelBox.dataProvider = new DataProvider(_Strategy.GetDatabase());
			this.autoComplete.enabled = true;
		}
		
		function doDropShadows():void{
			for(var index:Number = 0; index < myBackground.numChildren; index++)
			{
				addDropShadow(myBackground.getChildAt(index));
			}
		}
		function addDropShadow(mc:DisplayObject):void{
			//First we declare an object, a dropshadow filter and name it
			var my_shadow:DropShadowFilter = new DropShadowFilter();
			//Now we apply some properties to our new filters object, thisfirst property is the color, and we set that to black, as most shadowsare.
			my_shadow.color = 0x000000;
			//These next two properties we set, are the position of ourdropshadow relative to the object,
			//This means 8 px from the object on both the x and y axis.
			my_shadow.blurY = 8;
			my_shadow.blurX = 8;
			//And here we set an angle for the dropshadow, also relative to the object.
			my_shadow.angle = 100;
			//Setting an alpha for the shadow. This is to set the strength ofthe shadow, how "black" it should be.
			my_shadow.alpha = .5;
			//and here we set the distance for our shadow to the object.
			my_shadow.distance = 6;
			//Now we define an array for our filter with its properties to holdit. This will be the final object we refer to when we need to apply itto something.
			var filtersArray:Array = new Array(my_shadow);
			//The last step is to take our movie clip that we made at thebeginning, so we take our object and apply the filtersArray.
			mc.filters = filtersArray;
			
		}
		function expandHeader(event:MouseEvent):void
		{
			expandMe();
		}
		function expandMe():void
		{
			addChild(fullClip);
			fullClip.alpha = 1;
			fullClip.y = 100;
			fullClip.x = 100;
			fullClip.enabled = true;
		}
		function collapseMe():void
		{
			fullClip.alpha = 0;
			fullClip.y = 1500;
			fullClip.enabled = false;
		}
		function collapseHeader(event:MouseEvent):void
		{
			collapseMe();
		}
		function SetStock(event:Event):void
		{
			_xmlStock = event.target.getItemAt(0).DataName;
			checkMaxDaily();
			setDates(category,_xmlStock);
		}
		function setDates(database:String, entity:String):void{ 

			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/ServiceFlash?TASK=daterange&DBS="+ database + "&ENTITY=" + entity);

			urlDriver.addEventListener(CustomEvent.QUERYREADY, dateHandler);
		}
		function dateHandler(e:CustomEvent)
		{
			var dateD:String = e.data;
			var dateData:Array = dateD.split(",");
			var startYearDate:String = dateData[0].substr(0,4);
			var endYearDate:String = dateData[1].substr(0,4);
	
			startDateFull = startYearDate + "-01-01"
			endDateFull = endYearDate + "-12-31"			
			dateSlider.setNewDates(new Array(startYearDate, endYearDate))
		}
		function checkMaxDaily():void{
			if(this.maxDaily.value <= 0)
			{
				submitBtn.enabled = false;
			}
			if(this.maxDaily.value > 0)
			{
				submitBtn.enabled = true;
			}
		}
		
		function Next(e:Event):void
		{
			xmlArray = new Array();
			//trace(this.endDateFull);
			//startDateFull = startDateYear + "-" + startDateMonth + "-01";
			//endDateFull = endDateYear + "-" + endDateMonth + "-01";
			/*if (from_Btn.selected)
			{
				startDateFull = "ALL";
			}
			if (to_Btn.selected)
			{
				endDateFull = "NOW";
			}*/
			collapseMe();
			dispatchEvent(new CustomEvent("setUpXMLReady", setXML()));
			dispatchEvent(new CustomEvent("maxDailySet", this.maxDaily.value));
			

		}
		public function returnHeader():Sprite{
			return headerClip;
		}
		/*function SetStartChkBx()
		{
			from_Btn = new CheckBox();
			from_Btn.y = 255;
			from_Btn.x = 10;
			from_Btn.label = "ALL";
			from_Btn.addEventListener(MouseEvent.CLICK, FromClickHandler);
			myBackground.addChild(from_Btn);
		}
		function SetEndChkBx()
		{
			to_Btn = new CheckBox();
			to_Btn.y = 255;
			to_Btn.x = 300;
			to_Btn.label = "NOW";

			to_Btn.addEventListener(MouseEvent.CLICK, ToClickHandler);
			myBackground.addChild(to_Btn);

		}*/

		function FromClickHandler(e:MouseEvent):void
		{
			if (from_Btn.selected)
			{
				startDateFull = "ALL";
			}

		}
		function ToClickHandler(e:MouseEvent):void
		{

			if (to_Btn.selected)
			{
				endDateFull = "NOW";
			}
		}
		function setXML():XMLList
		{
			startDateFull = dateSlider.minimumValue + "-01-01"
			endDateFull = dateSlider.maximumValue + "-12-31"
			var reportXML:XMLList = new XMLList(
			                <Init>
			                                      <Tactic/>
			                                      <UEDB/>
			                                      <DateBegin/>
			                                      <DateEnd/>
			                                      <UE/>
			                                      <MaxInvest/>
			                                      <MaxBetDaily/>
			                               </Init>);


			var myArray:Array =  new Array();
			myArray.push({xmlNodeName: "Tactic", value: _xmlLongShort});
			myArray.push({xmlNodeName: "UEDB", value: category});
			myArray.push({xmlNodeName: "DateBegin", value: startDateFull});
			myArray.push({xmlNodeName: "DateEnd", value: endDateFull});
			myArray.push({xmlNodeName: "UE", value: _xmlStock});
			myArray.push({xmlNodeName: "MaxBetDaily", value: _xmlMaxDaily});
			myArray.push({xmlNodeName: "MaxInvest", value: _xmlMaxBet});


			for each (var item:Object in myArray)
			{
				reportXML[item.xmlNodeName] = item.value.toString();
			}

			return reportXML;
		}
		function setShortLong():void
		{
			var lngSrt:TextField = new TextField;
			
			lngSrt.y = 18;
			lngSrt.x = 250
			lngSrt.defaultTextFormat = myFormat;
			lngSrt.text = "Trade Type: ";
			lngSrt.autoSize = "left";
			addDropShadow(lngSrt);
			long_short = new RadioButtonGroup("Long or Short");
			myBackground.addChild(lngSrt)
			
			LONG = new RadioButton();
			SHORT = new RadioButton();
			long_short.addEventListener(MouseEvent.CLICK, handleLongShort);
			LONG.group = long_short;
			SHORT.group = long_short;

			
			
			LONG.move(400, 10);
			SHORT.move(400, 30);



			LONG.label = "LONG";
			SHORT.label = "SHORT";



			LONG.value = "LONG";
			SHORT.value = "SHORT";
			long_short.selection = LONG;
			_xmlLongShort = "Long";
			myBackground.addChild(LONG);
			myBackground.addChild(SHORT);


		}
		function handleLongShort(e:Event):void
		{
			_xmlLongShort = long_short.selection.value.toString();

		}
		function SetBeginMonth(e:Event):void
		{
			startDateMonth = (e.currentTarget.selectedIndex + 1).toString();
		}
		function SetEndMonth(e:Event):void
		{
			endDateMonth = (e.currentTarget.selectedIndex + 1).toString();
		}
		function SetStartYear(e:Event):void
		{
			startDateYear = e.currentTarget.value;
			
		}
		function SetEndYear(e:Event):void
		{
			endDateYear = e.currentTarget.value;
			
		}

		
		function DrawBackground():void
		{	
			
			myBackground.graphics.lineStyle(1, 0x6D7B8D);
			//Type of Gradient we will be using
			var fType:String = GradientType.LINEAR;
			//Colors of our gradient in the form of an array
			var colors:Array = [0xCCBB88, 0xFFFFFF];
			//Store the Alpha Values in the form of an array
			var alphas:Array = [0.8, 0.8];
			//Array of color distribution ratios.  
			//The value defines percentage of the width where the color is sampled at 100%
			var ratios:Array = [0, 255];
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix = new Matrix();
				matr.createGradientBox( 730, 300, Math.PI/2, 0, -175 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			//Save typing + increase performance through local reference to a Graphics object
			var g:Graphics = myBackground.graphics;
				g.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod );
				g.drawRect(0, -50, 900, 450);
				
			 fullClip.addChild(myBackground);
			myMask = new MovieClip();
			//myMask.graphics.drawRect(0, 0, 5, 30);
			//myBackground.mask = myMask
			//fullClip.addChild(myMask);
			
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
		function createSlider(_slider:Slider, _xLoca:Number, _yLoca:Number, _size:Number, _description:String, _sliderLabel:TextField):void
		{

			//position slider
			_slider.move(_xLoca,_yLoca);

			// control if slider updates instantly or after mouse is released
			_slider.liveDragging = true;

			//set size of slider
			_slider.setSize(200,0);

			//set maximum value
			_slider.maximum = _size;

			//set mininum value
			_slider.minimum = 0;

			//_slider.addEventListener(Event.CHANGE, handleSlider);
			var sliderText:TextField = new TextField();
			sliderText.defaultTextFormat = this.myFormat;
			sliderText.autoSize = "center";
			sliderText.x = _slider.x + 90;
			sliderText.y = _slider.y + 20;
			sliderText.text = _description;
			sliderText.defaultTextFormat = this.myFormat;
			addDropShadow(sliderText);
			myBackground.addChild(sliderText);

			//_sliderLabel = new TextField();
			_sliderLabel.autoSize = "center";
			_sliderLabel.x = _slider.x + _slider.width + 20;
			_sliderLabel.y = _slider.y - 5;
			_sliderLabel.text = _slider.value.toString();
			myBackground.addChild(_sliderLabel);
			//DrawTextBox(sliderLabel, _xLoca + 75, _yLoca + 25, "0");
			//slider.enabled = false;
			myBackground.addChild(_slider);
		}
		function handleMaxDailySlider(event:Event):void
		{
			_xmlMaxDaily = event.target.value;
			maxDailyValue.text = event.target.value + " % ";
			checkMaxDaily();
		}
		function handleMaxInvestSlider(event:Event):void
		{
			_xmlMaxBet = event.target.value;
			maxInvestValue.text = event.target.value + " % ";
			maxDaily.enabled = true;
			maxDaily.maximum = event.target.value;
			maxDailyValue.text = maxDaily.value.toString();
		}
		public function createDataBox(_name:String, _xLoca:Number, _yLoca:Number,
		_prompt:String, _data:Array, _paramenters:Array,
		_control:ComboBox, parameterString:String, selection:String):void
		{
			_control.dropdownWidth = 125;
			_control.width = 125;
			_control.move(_xLoca, _yLoca);
			_control.prompt = _prompt;
			_control.dataProvider = new DataProvider(_data);//put the array here
			//_control.setStyle("backgroundColor","0x330000");
			_control.labelField = "HumanName";
			_control.textField.setStyle("embedFonts", true);
			_control.textField.setStyle("textFormat", myFormatBeige);
			 
			_control.dropdown.setRendererStyle("embedFonts", true);
			_control.dropdown.setRendererStyle("textFormat", myFormatBeige);
			_control.addEventListener(Event.CHANGE,function(event:Event){changeHandler(event,
			_paramenters, _control, parameterString, selection)});

			_control.alpha = 1;
			addChild(_control);
		}
		function changeHandler(event:Event, parameterArray:Array, object:Object, parameterString:String, selection:String):void
		{
			var t:Object = event.target.selectedItem;
		}
		public function setTradabelBx():void
		{
			
			var traded:TextField = new TextField;
			addDropShadow(traded);
			traded.y = 90;
			traded.x = 95
			traded.defaultTextFormat = myFormat;
			traded.text = "What is being traded?";
			traded.autoSize = "left";
			myBackground.addChild(traded);
			createDataBox("Tradables", 300, 90, "Select Database", _Strategy.GetDatabase(), new Array(), tradSelBox = new ComboBox(), new String(), new String());
			tradSelBox.width = 160;
			tradSelBox.dropdownWidth = 160,
			//tradSelBox.selectedItem = "stock"
			autoComplete = new AutoComplete();
			
			autoComplete.y = 90;
			autoComplete.x = 550;
			autoComplete.width =300;
			autoComplete.setStyle("embedFonts", true);
			autoComplete.setStyle("textFormat", myFormatBeige);
			 
			autoComplete.dropdown.setRendererStyle("embedFonts", true);
			autoComplete.dropdown.setRendererStyle("textFormat", myFormatBeige);
			autoComplete.dropdown.addEventListener(Event.CHANGE, SetStock);
			tradSelBox.addEventListener(Event.CHANGE, StkBxHandler);
			this.addDropShadow(autoComplete);
			myBackground.addChild(tradSelBox);
			myBackground.addChild(autoComplete);
		}
		function StkBxHandler(event:Event):void
		{
			
			var t:Object = event.target.selectedItem;
			category = t.DataName
			autoComplete.labelField = "HumanName";
			
			//Have it fill in the text field with the most likely entry
			autoComplete.autoFillEnabled = true;
			autoComplete.text = "";


			//_Strategy.SetUE(temp);

			if (category.toUpperCase() == "STOCK")
			{
				autoComplete.dataProvider = new DataProvider(_Strategy.GetStocks());
			}
			if (category.toUpperCase() == "COMMODITY")
			{
				autoComplete.dataProvider = new DataProvider(_Strategy.GetCommodities());
			}
			if (category.toUpperCase() == "BOND")
			{
				autoComplete.dataProvider = new DataProvider(_Strategy.GetBonds());
			}
			if (category.toUpperCase() == "CURRENCY")
			{
				autoComplete.dataProvider = new DataProvider(_Strategy.GetCurrencies());
			}
			if (category.toUpperCase() == "INDEX")
			{
				autoComplete.dataProvider = new DataProvider(_Strategy.GetIndex());

			}
			autoComplete.dropdown.addEventListener(Event.CHANGE, SetValue);

		}
		function SetValue(event:Event):void
		{
			dataBaseValue = "";
		}



		function PlaceImage(_container:Sprite, _className:String,
		_function:Function, _stage:MovieClip):void
		{
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());

			_container.name = _className;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.addEventListener(MouseEvent.CLICK, _function);
			_container.scaleX = 0.3;
			_container.scaleY = 0.3;
			//containerList.push(_container);
			_stage.addChild(_container);

		}


	}

}