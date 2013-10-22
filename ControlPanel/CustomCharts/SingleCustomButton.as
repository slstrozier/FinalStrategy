package ControlPanel.CustomCharts {
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.Label;
	import flash.filters.DropShadowFilter;
	import flash.display.DisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.*
	import flash.geom.ColorTransform;
	import flash.filters.GlowFilter;
	import ControlPanel.CommonFiles.Util.*
	
	
	public class SingleCustomButton extends MovieClip{
		private var buttons:Array;
		private var buttonData:Array;
		

		private var dropShawdow:DropShadowFilter;
		private var textDescription:TextField;
	
		private var buttonDisplayWidth:Number;
		private var user:String;
		private var dispatchString:String;
		private var myStage:MovieClip;
		public var button:MovieClip;
		private var subCatagoriesDisplayList:Array;
		
		
		
		public function SingleCustomButton(stage:MovieClip, user:String, data:Array) {
			
			stage.addChild(this);
			myStage = stage;
			
			//this.dispatchString = dispatchString;
			this.user = user;
			//_isTBL = isTBL;
			buttonDisplayWidth = width;
			this.name = "Single Custom Button";
			buttonData = data;
			textDescription = new TextField();
			buildCustomButtonClip();
			setDropShadow(this);
			
			
			//getBoxInfo();
			
			
		}
		function buildCustomButtonClip():void{
						
			var header_font = new HeaderFont;
			
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 16;
			myFormat.italic = true
			myFormat.font = header_font.fontName;
			
			
			var mcText:TextButton = new TextButton();
			mcText.scaleX = 1.3;
			mcText.scaleY = 1.2
			mcText.DeleteClip = deleteButton(mcText);
			mcText.DeleteClip.y -= 15
			mcText.DeleteClip.x += 55;
			addChild(mcText.DeleteClip)
			var newColorTransform:ColorTransform = mcText.buttonBackground.transform.colorTransform;
			newColorTransform.color = 0xFF6600;
			mcText.buttonBackground.transform.colorTransform = newColorTransform;
			mcText.ButtonData = new Array(buttonData[0])
				
				mcText.mouseChildren = false;
				mcText.buttonMode = true;
				//setDropShadow(mcText);
				//mcText.buttonText.defaultTextFormat = myFormat
				mcText.buttonText.text = buttonData[0].Name;
				mcText.addEventListener(MouseEvent.MOUSE_OVER, description);
				mcText.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
				//mcText.addEventListener(MouseEvent.CLICK, handleButtonClick);
				mcText.DeleteClip = this.deleteButton(mcText);
				
				button = mcText;
				addChild(button);
				
			myStage.addChild(this);
			
		}
		
		function clearDisplayList(displayList:Array):void{
			for(var index:Number = 0; index < displayList.length; index ++)
			{
				removeChild(displayList[index]);
			}
			displayList.splice(0);
		}
		
		function createButtonsList(numButtons:Number):Array{
			buttons = new Array();
			for(var index:Number = 0; index < numButtons; index++){
				var mcText:TextButton = new TextButton();
				
				buttons.push(buttonPropertyGetter(mcText,index));
				//var label:String = removeSpaces(mcText.ButtonData[0].Label)
				mcText.mouseChildren = false;
				mcText.buttonMode = true;
				mcText.scaleX = 1.25;
				mcText.scaleY = 1.2;
			
				var newColorTransform:ColorTransform = mcText.buttonBackground.transform.colorTransform;
				newColorTransform.color = 0xFF6600;
				mcText.buttonBackground.transform.colorTransform = newColorTransform;
				
				setDropShadow(mcText);
				
				mcText.buttonText.text = mcText.ButtonData[0].Label;
				mcText.addEventListener(MouseEvent.MOUSE_OVER, description);
				mcText.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
				mcText.addEventListener(MouseEvent.CLICK, handleButtonClick);
				mcText.DeleteClip = this.deleteButton(mcText);

			}
			
			
			return buttons;
		}
		function setDropShadow(obj:DisplayObject):void{
			
			
			obj.filters = [new DropShadowFilter()]
			
		}
		
		/*Takes a movie clip and adds its propetites. The Index is the index of the main array that holds all of the information from the query.
		* Pass this function a movie clip and an index for its properties and its adds an array of properties for the movie clip
		*/
		function buttonPropertyGetter(mc:MovieClip, index:Number):Object{
			
			
			mc.ButtonData = new Array(buttonData[index]);
			//mc.name = mc.ButtonData[0].Label
			return mc;
		}
		/*Pass this function an array of movie clips and the clips are added to the stage.
		*/
		function placeClips(buttonArray:Array, width:Number, displayList:Array):void{
			clearDisplayList(displayList);
			var yLoca:Number = 50;
			buttonArray[0].x = 10;
			buttonArray[0].y = yLoca;
			
			subCatagoriesDisplayList.push(buttonArray[0]);
			buttonArray[0].DeleteClip.x += 10
			buttonArray[0].DeleteClip.y -= 10
			addChild(buttonArray[0].DeleteClip);
			addChild(buttonArray[0])
			
			for(var index:Number = 1; index < buttonArray.length; index++){
				
				buttonArray[index].x = buttonArray[index - 1].x + (buttonArray[index].width + 10)
				
				if(buttonArray[index].x > width){
					buttonArray[index].x = 10;
					yLoca += 50;
					
				}
				buttonArray[index].y = yLoca;
				buttonArray[index].DeleteClip.x = buttonArray[index].x + 45
				buttonArray[index].DeleteClip.y = buttonArray[index].y - 10
				addChild(buttonArray[index].DeleteClip);
				subCatagoriesDisplayList.push(buttonArray[index]);
				addChild(buttonArray[index])
			}
		}
		/*
		*The eventListener for the movie clips;
		*/
		function handleButtonClick(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			var chartData:String = mc.ButtonData[0].ChartData;
			dispatchEvent(new CustomEvent("CustomButtonClicked", chartData));
		}
		function sendQuery(url:String):void{
			var boxQueryDriver:URLFactory = new URLFactory(url);
			boxQueryDriver.addEventListener(CustomEvent.QUERYREADY, handleQueryResult)
			
		}
		function handleQueryResult(event:CustomEvent):void
		{			
			sendQueryResults(event.data);
		}
		function sendQueryResults(result:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", result));
		}
		
		
		function removeSpaces(string:String):String{
			var pattern:RegExp = /^\s+|\s+$/g;
			string = string.replace(pattern, "")
			return string;
		}
		
		function description(event:Event):void
		{
			var mc:MovieClip = event.target as MovieClip;
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = "arial";
			textDescription.defaultTextFormat = myFormat;
			textDescription.x = mouseX;
			textDescription.y = mouseY + 45;
			textDescription.height = 20;
			textDescription.autoSize = "left";
			textDescription.text = mc.ButtonData[0].Label;
			textDescription.background = true;
			textDescription.alpha = 0;
			var tween:Tween = new Tween(textDescription,
			                       "alpha",None.easeNone,0,1,1,true);

			textDescription.border = true;
			addChild(textDescription);
			this.setChildIndex(textDescription, this.numChildren - 1)

		}
		
		function removeDescription(e:Event):void
		{
			removeChild(textDescription);
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
		
		function deleteMCButton(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			requestDelete(mc.DeleteButton)
			
		}
		function requestDelete(mc:MovieClip):void{
			var deleteString:String = mc.ButtonData[0].Name;
			var urlFactory:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=delete&WHAT=entity&NAME=" + deleteString)
			//trace(urlFactory.url);
			urlFactory.addEventListener(CustomEvent.QUERYREADY, handleButtonDeleted)
			
		}
		function handleButtonDeleted(event:CustomEvent):void{
			/*trace("handleButtonDeleted, in SingleCustomButton")
			trace(event.data)
			trace("handleButtonDeleted, in SingleCustomButton")*/
			dispatch("UserButtonDeleted");
		}
		
		function dispatch(dispatchString:String):void{
			dispatchEvent(new Event(dispatchString));
		}
		public function addNewButton(bttnName:String, bttnLabel:String, bttnData:String):void{
								
				var urlFactory:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=add&WHAT=entity&NAME=" + bttnName + "&DESCR=" + bttnLabel + "&DATA=" + bttnData)
				urlFactory.addEventListener(CustomEvent.QUERYREADY, handleButtonAdd)
		}
		function handleButtonAdd(event:Event):void{
			dispatch("NewButtonAdded")
		}
	}
	
}
