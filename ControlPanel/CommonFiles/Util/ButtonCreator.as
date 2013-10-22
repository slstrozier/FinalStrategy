package ControlPanel.CommonFiles.Util {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.*;
	import fl.controls.Label;
	import flash.filters.DropShadowFilter;
	import flash.display.DisplayObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.*
	import flash.geom.ColorTransform;
	import flash.filters.*
	

	//import BoxCreator.*
	
	
	
	public class ButtonCreator extends MovieClip{
		private var buttons:Array;
		private var buttonData:Array;
		private var subCatagoriesDisplayList:Array;
		private var dropShawdow:DropShadowFilter;
		private var textDescription:TextField;
		private var _isTBL:Boolean;
		private var buttonDisplayWidth:Number;
		private var categoryButtons:Array;
		private var categoryButtonsWithClips:Array;
		private var ind_or_tbl:String;
		private var glowFilter:GlowFilter;
		private var allCategories:Array;
		private var mainButtonColor:Number;
		private var subButtonColor:Number;
		private var dates:Array;
		
		
		
		public function ButtonCreator(ind_or_tbl:String, mainButtonColor:Number, subButtonColor:Number, width:Number = 300, xLoca:Number = 0, yLoca:Number = 0) {

			this.x = xLoca;
			this.y = yLoca;
			this.subButtonColor = subButtonColor;
			this.mainButtonColor = mainButtonColor;
			this.ind_or_tbl = ind_or_tbl;
			buttonDisplayWidth = width;
			this.name = "Button Creator";
			textDescription = new TextField();
			subCatagoriesDisplayList = new Array();
			allCategories = new Array();
			glowFilter = new GlowFilter(0xFF6600,.5,20,20,2)
			dates = new Array("ALL", "NOW");
			init();
			
			
		}
		function init():void{
			getBoxInfo();
	
		}
		
		function clearDisplayList(displayList:Array):void{
			for(var index:Number = 0; index < displayList.length; index ++)
			{
				removeChild(displayList[index]);
			}
			displayList.splice(0);
		}
		public function changeDate(date:String):void{
			
		}
		function mainButtonHandler(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			removeGlow(allCategories);
			mc.filters = [glowFilter];
			placeClips(mc.Subcategories, 250, 85, subCatagoriesDisplayList, true);
			
		}
		function removeGlow(clipArray:Array):void{
			for(var index = 0; index < clipArray.length; index++)
			{
				clipArray[index].filters = [dropShawdow];
			}
		}
		public function setDates(dates:Array):void{
			this.dates = dates;
		}
		function createButtonsList(numButtons:Number):Array{
			buttons = new Array();
			for(var index:Number = 0; index < numButtons; index++){
				var mcText:TextButton = new TextButton();
				mcText.scaleX = 1.2;
				mcText.scaleY = 1.2;
			
				var newColorTransform:ColorTransform = mcText.buttonBackground.transform.colorTransform;
				newColorTransform.color = subButtonColor;
				mcText.buttonBackground.transform.colorTransform = newColorTransform;
			
				buttons.push(buttonPropertyGetter(mcText,index));
				//var label:String = removeSpaces(mcText.ButtonData[0].Label)
				mcText.mouseChildren = false;
				mcText.buttonMode = true;
				setDropShadow(mcText);
				var myColor:ColorTransform = mcText.buttonBackground.transform.colorTransform;
				myColor.color = subButtonColor;
				mcText.buttonBackground.transform.colorTransform = myColor;
				mcText.buttonText.text = mcText.ButtonData[0].Label;
				mcText.addEventListener(MouseEvent.MOUSE_OVER, description);
				mcText.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
				mcText.addEventListener(MouseEvent.CLICK, handleQueryButton);
				//mcText.Label.text = "hello";
				
				
			}
			splitCatagories(buttons)
			
			return buttons;
		}
		function setDropShadow(obj:DisplayObject):void{
			
			dropShawdow = new DropShadowFilter()
			obj.filters = [dropShawdow]
			
		}
		//splits the buttons in the buttons array into the subCatagories (Adds the buttons to the specified arrays). 
		function splitCatagories(buttons:Array):void{
			
			
			var tempcategory:String = buttons[0].ButtonData[0].Subcategory;
			categoryButtons = new Array();
			categoryButtons.push(buttons[0].ButtonData[0].Subcategory);
			
			for(var buttonIndex = 0; buttonIndex < buttons.length; buttonIndex++){
				
				if(tempcategory != buttons[buttonIndex].ButtonData[0].Subcategory)
				{
					
					tempcategory = buttons[buttonIndex].ButtonData[0].Subcategory;
					categoryButtons.push(tempcategory);
					
				}
			}
			
			var tArray = createCategoryButtons(categoryButtons);
			
				for each ( var buttWClip:MovieClip in tArray)
				{
					
					var categories:Array = new Array();
						
						for (var buttWoClipIndex = 0; buttWoClipIndex < buttons.length; buttWoClipIndex++)
							{
								if(buttWClip.Name == buttons[buttWoClipIndex].ButtonData[0].Subcategory)
								{
									categories.push(buttons[buttWoClipIndex])
								}
							}
							
							buttWClip.Subcategories = categories;
				}
				
				for(var index = 0; index < tArray.length; index++){
					
					tArray[index].y = 400
					tArray[index].x = 50 * index;
					tArray[index].addEventListener(MouseEvent.CLICK, mainButtonHandler)
					allCategories.push(tArray[index]);
					//addChild(tArray[index])
					
				}
				
				categoryButtons = tArray;
				placeClips(tArray, 250, 10, new Array(), false);
				
		}
		/*Create the text fields to be placed on top of the movie clip. Returns a textfield*/
		function createTextFields(displayName:String):Label{
			var butName:Label = new Label;
			displayName = removeSpaces(displayName)
			butName.text = displayName
			butName.autoSize = "center"
			return butName;
		}
		/*Takes a movie clip and adds its propetites. The Index is the index of the main array that holds all of the information from the query.
		* Pass this function a movie clip and an index for its properties and its adds an array of properties for the movie clip
		*/
		function buttonPropertyGetter(mc:MovieClip, index:Number):Object{
			mc.ButtonData = new Array(buttonData[index]);
			return mc;
		}
		/*Pass this function an array of movie clips and the clips are added to the stage.
		*/
		function placeClips(buttonArray:Array, width:Number, yOffset:Number, displayList:Array, isSubCat:Boolean):void{
			clearDisplayList(displayList);
			var yLoca:Number = 35 + yOffset;
			
			if(isSubCat){
				
				yLoca = categoryButtons[categoryButtons.length - 1].y + 35;
			}
			buttonArray[0].x = 10;
			buttonArray[0].y = yLoca;
			addChild(buttonArray[0])
			displayList.push(buttonArray[0]);
			
			for(var index:Number = 1; index < buttonArray.length; index++){
				
				buttonArray[index].x = buttonArray[index - 1].x + (buttonArray[index].width + 10)
				
				if(buttonArray[index].x > width){
					buttonArray[index].x = 10;
					yLoca += 35;
				}
				buttonArray[index].y = yLoca;
				displayList.push(buttonArray[index]);
				addChild(buttonArray[index])
			}
		}
		/*
		*The eventListener for the movie clips;
		*/
		function handleQueryButton(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			var preQuery:String = "http://backend.chickenkiller.com:8080/sample/"// + mc.ButtonData[0].QueryString;
			var date:String = preQuery + updateStartAndEndDates(mc.ButtonData[0].QueryString, this.dates)
			sendQuery(date);
		}
		function updateStartAndEndDates(string:String, newDates:Array):String
		{
			var temp:String = string.replace("&START=ALL", "&START=" + String(newDates[0])+ "-01-01")
			var temp2:String = temp.replace("&END=NOW", "&END=" + String(newDates[1]) + "-12-31")
			
			return temp2;
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
		/*
		*Queries the database for the data used to create the properties for the movie clips
		*/
		public function getBoxInfo():void
		{
			var urlDriver:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttongetter?USER=user1&WHAT=fixed" + ind_or_tbl);
			urlDriver.addEventListener(CustomEvent.QUERYREADY, buttonGetter);		
		}
		/*
		*Listener for the urlFactory, on complete sets the buttonData array to the data retrieved. And then calls
		*the setDataProvider method on the list
		*/
		function buttonGetter(event:CustomEvent)
		{
			
			buttonData = event.data.split("\n");
			
			buttonData = setDataProvider(buttonData);
			
			//splitCatagories();
			dispatchEvent(new Event("dataReady"));			
			setAllData();
		}
		
		
		/*
		*This method takes an array of data, splits and returns an object array containing the data needed for the movie clips.
		*
		*/
		function setDataProvider(data:Array):Array{
			var dataProvider:Array = new Array();
			for(var index:Number = 0; index < data.length; index++){
				
				var tArray:Array = data[index].split('","');
				
				dataProvider.push({Box: tArray[0], Subcategory: tArray[1], Label: tArray[2], ButtonInfo: tArray[3], QueryString: tArray[4], Destination: tArray[5], IsSignal: tArray[6], SignalOnOff: tArray[7], IsScan: tArray[8], ScanList: tArray[9]})
			}
			
			return dataProvider;
			
		}
		//Listens for the query to the database to complete and calls the createButtonsList and placeClips methods
		function setAllData():void{
			
			createButtonsList(buttonData.length);
		}
		function removeSpaces(string:String):String{
			var pattern:RegExp = /^\s+|\s+$/g;
			string = string.replace(pattern, "")
			return string;
		}
		
		function createCategoryButtons(buttonCategories:Array):Array{
			categoryButtonsWithClips = new Array();
			for(var categoryIndex = 0; categoryIndex < buttonCategories.length; categoryIndex++){
				var mcText:TextButton = new TextButton();
				mcText.scaleX = 1.2;
				mcText.scaleY = 1.4;
				
				var newColorTransform:ColorTransform = mcText.buttonBackground.transform.colorTransform;
				newColorTransform.color = mainButtonColor;
				mcText.buttonBackground.transform.colorTransform = newColorTransform;
				
				mcText.mouseChildren = false;
				mcText.buttonMode = true;
				setDropShadow(mcText);
				mcText.Name = new String(buttonCategories[categoryIndex])
				mcText.ButtonData = new Array({ButtonInfo: mcText.Name}),
				mcText.buttonText.text = mcText.Name;
				mcText.x =  categoryIndex * 55;
				mcText.y = 400
				categoryButtonsWithClips.push(mcText);
				
				//addChild(mcText);
				mcText.addEventListener(MouseEvent.MOUSE_OVER, description);
				mcText.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
				//mcText.addEventListener(MouseEvent.CLICK, handleQueryButton);
			}
			
			return categoryButtonsWithClips;
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
			textDescription.text = mc.ButtonData[0].ButtonInfo;
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

	}
	
}
