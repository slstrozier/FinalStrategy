package ControlPanel.Scans{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Util.*
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.text.*
	import flash.events.*
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.geom.ColorTransform;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.*


	
	public class SingleScan extends MovieClip{
		private var myStage:MovieClip;
		private var user:String
		private var urlFactory:URLFactory;
		private var box4Data:String;
		private var buttonData:Array
		private var dropShawdow:DropShadowFilter;
		private var textDescription:TextField;
		public var singleScanButton:MovieClip;
		private var dates:Array;
		private var stocksCB:ComboBox;
		
		public function SingleScan(stage:MovieClip, user:String, data:Array) {
			
			stage.addChild(this);
			myStage = stage;
			dates = new Array("ALL", "NOW")
			this.user = user;
			textDescription = new TextField();
			buttonData = data;
			buildSingleScanClip();
			setDropShadow(singleScanButton);
			//myStage.addChild(this);
			//sendQuery("http://backend.chickenkiller.com:8080/sample//buttongetter?USER=user1&WHAT=CUSTOMFILTER")
		}
		
		function buildSingleScanClip():void{
			stocksCB = new ComboBox();
			stocksCB.addEventListener(Event.CHANGE, handleComboSelect);
			stocksCB.prompt = "Hits";
			
			var stocksList:Array = buttonData[0].HitStocks.split(",")
			stocksCB.dataProvider = new DataProvider(stocksList);
			stocksCB.width = 75;
			stocksCB.move(80,2);
			
			var header_font = new HeaderFont;
			
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 16;
			myFormat.italic = true
			myFormat.font = header_font.fontName;
			
			var numberofHitsText:TextField = new TextField();
			numberofHitsText.defaultTextFormat = myFormat;
			numberofHitsText.embedFonts = true;
			numberofHitsText.antiAliasType = AntiAliasType.ADVANCED;
			numberofHitsText.text = buttonData[0].HitTotal;
			numberofHitsText.x += 15;
			numberofHitsText.y -= 4;
			numberofHitsText.width = 20;
			var mcText:TextButton = new TextButton();
			mcText.scaleX = 1.6;
			mcText.scaleY = 1.2
			mcText.DeleteClip = deleteButton(mcText);
			mcText.DeleteClip.y -= 15
			mcText.DeleteClip.x += 55;
			addChild(mcText.DeleteClip)
			var newColorTransform:ColorTransform = mcText.buttonBackground.transform.colorTransform;
			newColorTransform.color = 0xEDDA74;
			mcText.buttonBackground.transform.colorTransform = newColorTransform;
			mcText.ButtonData = new Array(buttonData[0])
				
				mcText.mouseChildren = false;
				mcText.buttonMode = true;
				//setDropShadow(mcText);
				//mcText.buttonText.defaultTextFormat = myFormat
				mcText.buttonText.text = buttonData[0].Label;
				mcText.addEventListener(MouseEvent.MOUSE_OVER, description);
				mcText.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
				mcText.addEventListener(MouseEvent.CLICK, handleButtonClick);
				mcText.DeleteClip = this.deleteButton(mcText);
				
				singleScanButton = mcText;
				addChild(singleScanButton);
				
				
			numberofHitsText.x += mcText.x + 50;
			addChild(numberofHitsText);
			addChild(stocksCB);
			myStage.addChild(this);
			
		}
		function setDropShadow(obj:DisplayObject):void{
			
			dropShawdow = new DropShadowFilter()
			obj.filters = [dropShawdow]
			stocksCB.filters = [];
			
			
		}
		function handleComboSelect(event:Event):void{
			
			var stock:String = event.currentTarget.value;
			
			var loadString = "http://backend.chickenkiller.com:8080/sample/Servletdd?TYPE=TBL&ENTITY=" + stock + "()[]{stock}&START=ALL&END=NOW"
			
			
			var urlFactory:URLFactory = new URLFactory(updateStartAndEndDates(loadString, dates));
			urlFactory.addEventListener(CustomEvent.QUERYREADY, handleScanQuery);
			
			
		}
		function updateStartAndEndDates(string:String, newDates:Array):String
		{
			var temp:String = string.replace("&START=ALL", "&START=" + String(newDates[0])+ "-01-01")
			var temp2:String = temp.replace("&END=NOW", "&END=" + String(newDates[1]) + "-12-31")
			
			
			return temp2;
		}
		public function setDate(dates:Array):void{
			this.dates = dates
			
		}
		function handleScanQuery(event:CustomEvent):void{
			dispatch("ScanDataReady", event.data);
			
		}
		function deleteButton(mc:MovieClip):MovieClip{
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.italic = true
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			var textF:TextField = new TextField()
			textF.defaultTextFormat = myFormat
			textF.text = "x";
			//textF.y = 40;
			//textF.x = 33;
			var db:MovieClip = new MovieClip();
			db.buttonMode = true;
			db.mouseChildren = false;
			db.addChild(textF);
			db.DeleteButton = mc;
			db.width = 6;
			db.addEventListener(MouseEvent.CLICK, deleteMCButton);
			return db;
		}
		
		/*
		*The eventListener for the movie clips;
		*/
		
		function handleButtonClick(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			var chartData:String = mc.ButtonData[0].ChartData;
			dispatch("StartScanBuilder", mc.ButtonData[0].SingleScanXML)
			//dispatchEvent(new CustomEvent(dispatchString, chartData));
		}
		
		function description(event:Event):void
		{
			var mc:MovieClip = event.target as MovieClip;
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = "arial";
			textDescription.defaultTextFormat = myFormat;
			textDescription.x = mouseX + 500
			textDescription.y = mouseY + 45;
			textDescription.height = 20;
			textDescription.autoSize = "left";
			textDescription.text = mc.ButtonData[0].Label;
			textDescription.background = true;
			textDescription.alpha = 0;
			var tween:Tween = new Tween(textDescription,
			                       "alpha",None.easeNone,0,1,1,true);

			textDescription.border = true;
			myStage.addChildAt(textDescription, 0);
			//setChildIndex(textDescription, numChildren - 1);

		}
		
		function removeDescription(e:Event):void
		{
			myStage.removeChild(textDescription);
		}
		function deleteMCButton(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			
			requestDelete(mc.DeleteButton)
		}
		function requestDelete(mc:MovieClip):void{
			var deleteString:String = mc.ButtonData[0].Name;
			
			var urlFactory:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=delete&WHAT=filter&NAME=" + deleteString)
			urlFactory.addEventListener(CustomEvent.QUERYREADY, handleButtonDeleted)
			
		}
		function handleButtonDeleted(event:CustomEvent):void{
			trace(event.target.url);
			dispatch("UserScanDeleted");
		}
		
		function dispatch(dispatchString:String, data:String = null):void{
			dispatchEvent(new CustomEvent(dispatchString, data));
		}
		public function addNewButton(bttnName:String, bttnLabel:String, bttnData:String):void{
								
				var urlFactory:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=add&WHAT=customfilter&NAME=" + bttnName + "&DESCR=" + bttnLabel + "&DATA=" + bttnData)
				urlFactory.addEventListener(CustomEvent.QUERYREADY, handleButtonAdd)
		}
		function handleButtonAdd(event:Event):void{
			dispatch("NewButtonAdded")
		}

	}
	
}
