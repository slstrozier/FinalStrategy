package ControlPanel.CommonFiles.Util {
	import flash.display.MovieClip;
	import fl.data.DataProvider;
	import fl.controls.DataGrid;
	import fl.controls.CheckBox;
	import fl.controls.Button;
	import flash.events.*;
	import flash.text.*;
	import fl.controls.Slider;
	import ControlPanel.CommonFiles.Util.*;
	import fl.controls.dataGridClasses.DataGridColumn;
	import flash.display.Bitmap;
	import fl.controls.ScrollPolicy;
	import flash.utils.getDefinitionByName;
	import flash.filters.*;
	
	public class ReactionSetter extends MovieClip{
		
	
		private var unCheckedReactionsClip:MovieClip;
		private var checkedReactionsClip:MovieClip;
		private var selectConditionsButton:Button;
		private var setConditionsButton:Button;
		private var doneButton:Button;
		private var conditionArray:Array;
		private var slider:Slider
		private var checkedReactions:Array;
		private var unCheckedReactions:Array;
		private var reactionDataGrid:DataGrid;
		private var reactionDataGridDP:DataProvider;
		private var _background:MovieClip;
		
		
		public function ReactionSetter(conditions:DataProvider, maxDaily:Number = 100) {
			
			drawBackground();
			conditionArray = dProviderToArray(conditions);
			conditionArray = displayIConditions(conditionArray);
			reactionDataGridDP = new DataProvider()
			createDataGrid(reactionDataGrid = new DataGrid, 25, 350, "Reactions");
			reactionDataGrid.name = "Reaction DG"
			reactionDataGrid.dataProvider = reactionDataGridDP;
			unCheckedReactionsClip = new MovieClip();
			unCheckedReactionsClip.name = "uncheckedReactionsClip";
			checkedReactionsClip = new MovieClip();
			checkedReactionsClip.name = "checkedReactionsClip";
			
			setButton(setConditionsButton = new Button, "Set Conditions Button", "Set Conditions", 340,300);
			setConditionsButton.addEventListener(MouseEvent.CLICK, handleAcceptReaction) 
			
			setButton(doneButton = new Button, "Done Button", "Done", 900, 475);
			doneButton.addEventListener(MouseEvent.CLICK, handleDone);
			
			
			slider = new Slider();
			_background.addChild(createSlider(slider, 300, 260, new TextField, maxDaily));
		}
		function handleDone(event:Event):void{
			var postReactionXML:XMLList = new XMLList(setXML())
			var xml_DataGrid:Array = new Array({XML:setXML(), "DataProv":this.reactionDataGrid})
			xml_DataGrid.push({XML:setXML(),"DataProv":this.reactionDataGrid})
			
			dispatch("ReactionsSet", xml_DataGrid);
			
		}
		public function updateDG(newDG:DataGrid):void{
			if(_background.getChildByName("Reaction DG")){
				_background.removeChild(_background.getChildByName("Reaction DG"))
			}
			reactionDataGrid = newDG;
			
			_background.addChild(reactionDataGrid);
		}
		function dispatch(dispaString:String, data:*):void{
			dispatchEvent(new CustomEvent(dispaString, data));
		}
		function dProviderToArray(dataP:DataProvider):Array{
			var temp:Array = new Array();
			for(var i:int = 0; i < dataP.length; i++){
				temp.push(dataP.getItemAt(i));
			}
			return temp;
		}
		function setButton(button:Button, bName:String, bText:String, xLoca:Number = 0, yLoca:Number = 0):void{
			if(_background.getChildByName(bName)){
				_background.removeChild(_background.getChildByName(bName));
			}
			button.name = bName;
			button.label = bText;
			button.move(xLoca, yLoca);
			_background.addChild(button);
		}
		function handleAcceptReaction(event:Event):void{
			setDP();
			
		}
		function randomColor():String{
			var colorArray:Array = new Array("yellow", "orange", "red", "green", "purple");
			var randomColorID:Number = Math.floor(Math.random() * (4 - 1 + 0)) + 1;
			return colorArray[randomColorID];
		}
		function setDP():void{
			var randomRowColor:String = randomColor();
			var idNumber:String = (Math.random() * 75834902750.843928).toString();
			//trace(checkedReactions.length + "this is the length of the fixed reactions");
			//trace(checkedReactions[0].XML + "this is the XML inside of the fixed reactions");
			var temp:XML = new XML(checkedReactions[0].XML);
				
				if(checkedReactions.length == 1){
					temp = new XML(checkedReactions[i].XML);
					reactionDataGrid.dataProvider.addItem({"Initial Entity": checkedReactions[i].name, "Second Entity": checkedReactions[i].SecondEntity, "Math Operator": checkedReactions[i].MathOP, "rowColor": randomRowColor, "Percent": slider.value, XML: temp, Rank: "Single", ID: idNumber, OriginalCond: checkedReactions[0]})
				}
				if(checkedReactions.length > 1){
					temp = new XML(checkedReactions[0].XML);
					reactionDataGrid.dataProvider.addItem({"Initial Entity": checkedReactions[i].name, "Second Entity": checkedReactions[i].SecondEntity, "Math Operator": checkedReactions[i].MathOP, "rowColor": randomRowColor, "Percent": slider.value, XML: temp, Rank: "Lead", ID: idNumber, OriginalCond: checkedReactions[0]})
					for(var i:int = 1; i < checkedReactions.length - 1; i++){
						temp = new XML(checkedReactions[i].XML);
						reactionDataGrid.dataProvider.addItem({"Initial Entity": checkedReactions[i].name, "Second Entity": checkedReactions[i].SecondEntity, "Math Operator": checkedReactions[i].MathOP, "rowColor": randomRowColor, "Percent": "", XML: temp, Rank: "Mid", ID: idNumber, OriginalCond: checkedReactions[i]})
					}
					temp  = new XML(checkedReactions[checkedReactions.length - 1].XML);
					reactionDataGrid.dataProvider.addItem({"Initial Entity": checkedReactions[checkedReactions.length - 1].name, "Second Entity": checkedReactions[checkedReactions.length - 1].SecondEntity, "Math Operator": checkedReactions[checkedReactions.length - 1].MathOp, "rowColor": randomRowColor, "Percent": "", XML: temp, Rank: "Last", ID: idNumber, OriginalCond: checkedReactions[i]})
				}
			
				
			
			/*trace ('+ number of DisplayObject: ' + _background.numChildren + '  --------------------------------');
			for (var j:uint = 0; j < _background.numChildren; j++){
				trace ('\t|\t ' +j+'.\t name:' + _background.getChildAt(j).name + '\t type:' + typeof (_background.getChildAt(j))+ '\t' + _background.getChildAt(j));
			}
			trace ('\t+ --------------------------------------------------------------------------------------');*/
			_background.removeChild(_background.getChildByName("checkedReactionsClip"));
			
			/*trace ('+ number of DisplayObject: ' + _background.numChildren + '  --------------------------------');
			for (var j:uint = 0; j < _background.numChildren; j++){
				trace ('\t|\t ' +j+'.\t name:' + _background.getChildAt(j).name + '\t type:' + typeof (_background.getChildAt(j))+ '\t' + _background.getChildAt(j));
			}
			trace ('\t+ --------------------------------------------------------------------------------------');*/
			
			checkedReactions.splice(0);
			
		}
		public function setXML():XMLList{
			var addXML:XML;
			
			var fullTempXML:XMLList = new XMLList();
			
				
					
					for(var i:int = 0; i < reactionDataGridDP.length; i++)
					{
						if(reactionDataGrid.dataProvider.getItemAt(i).Rank == "Single"){
							addXML = new XML(<Add/>)
							var tempXML:XML = new XML(reactionDataGrid.dataProvider.getItemAt(i).XML)
							tempXML["BetStruct"] = "0:" + reactionDataGrid.dataProvider.getItemAt(i).Percent;
							addXML.appendChild(tempXML);
							fullTempXML += addXML;
							
						}
						if(reactionDataGrid.dataProvider.getItemAt(i).Rank == "Lead"){
						addXML = new XML(<Add/>)
						var tempXML:XML = new XML(reactionDataGrid.dataProvider.getItemAt(i).XML)
						tempXML["BetStruct"] = "0:" + reactionDataGrid.dataProvider.getItemAt(i).Percent;
						addXML.appendChild(tempXML);
						
						}
						
						if(reactionDataGrid.dataProvider.getItemAt(i).Rank == "Mid"){
						//addXML = new XML(<Add/>)
						var tempXML:XML = new XML(reactionDataGrid.dataProvider.getItemAt(i).XML)
						tempXML["BetStruct"] = "0:0" + reactionDataGrid.dataProvider.getItemAt(i).Percent;
						addXML.appendChild(tempXML);
						
						}
						if(reactionDataGrid.dataProvider.getItemAt(i).Rank == "Last"){
						var tempXML:XML = new XML(reactionDataGrid.dataProvider.getItemAt(i).XML)
						tempXML["BetStruct"] = "0:0" + reactionDataGrid.dataProvider.getItemAt(i).Percent;
						addXML.appendChild(tempXML);
						
						fullTempXML += addXML;
						}
					}
				
			
			
			
		return fullTempXML;
		}
		function handleSelection(event:Event):void{
			conditionArray = checkReactions();
		}
		function displayIConditions(array:Array):Array{
			
			unCheckedReactionsClip = new MovieClip();
			var yLoca:Number = 25;
			var temp:Array = new Array();
			for(var i:int = 0; i < array.length; i++){
				temp.push(drawSingleCondition(unCheckedReactionsClip, array[i], 0, yLoca));
				yLoca += 50;
			}
			_background.addChild(unCheckedReactionsClip);
			unCheckedReactionsClip.x -= 35;
			setButton(selectConditionsButton = new Button, "Select Conditions Button", "Select Conditions", 50,yLoca);
			selectConditionsButton.addEventListener(MouseEvent.CLICK, handleSelection)
			selectConditionsButton.width = 250;
			return temp;
		}
		function displayConditions(array:Array, _stage:MovieClip, stageName:String, checked:Boolean = false, yLoca:Number = 0, xLoca:Number = -100):MovieClip{
			if(_background.getChildByName(_stage.name)){
			     _background.removeChild(_background.getChildByName(_stage.name));
			   
			}
			_stage = new MovieClip();
			_stage.name = stageName;
			var temp:Array = new Array();
			
			for(var i:int = 0; i < array.length; i++){
				_stage.addChild(array[i])
				array[i].y = yLoca;
				yLoca += 50;
				
			}
			
			_stage.x = xLoca;
			
			
			if(!checked){
				setButton(selectConditionsButton = new Button, "Select Conditions Button", "Select Conditions", 50, yLoca);
				selectConditionsButton.addEventListener(MouseEvent.CLICK, handleSelection)
			}
			return _stage;
		}
		function drawBackground():void{
			_background = new MovieClip();
			//_background.alpha = 0;
			_background.graphics.lineStyle(1, 0xCCCCBB);
			_background.graphics.beginFill(0xFAF0E6, 1);
			_background.graphics.drawRect(0,0,1000,500);
			_background.graphics.endFill();
			var filter = new DropShadowFilter(16,45,20,0.5, 20.0, 20.0,1.0);
			addChild(_background);
		}
		function drawSingleCondition(stage:MovieClip, condition:Object, xLoca:Number, yLoca:Number):MovieClip{
			var singleCondition:MovieClip = new MovieClip;
			var doReaction:CheckBox = new CheckBox();
			doReaction.x += 50;
			doReaction.textField.autoSize = "left"
			doReaction.textField.multiline = true
			var reactionLabel:String = condition["Initial Entity"] + "\n**" + condition["Math Operator"] + "**\n" + condition["Second Entity"]
			//doReaction.label.multiline = true;
			doReaction.label = reactionLabel;
			singleCondition.name = condition["Initial Entity"];
			singleCondition.MathOP = condition["Math Operator"];
			singleCondition.SecondEntity = condition["Second Entity"];
			singleCondition.DoReaction = doReaction;
			singleCondition.XML = new XML(condition.XML);
			singleCondition.y = yLoca;
			singleCondition.addChild(doReaction);
			stage.addChild(singleCondition);
			return singleCondition;
		}
		function handleChecked(event:Event):void{
			var checkButton:CheckBox = event.target as CheckBox;
		}
		function checkReactions():Array{

			checkedReactions = new Array;
			unCheckedReactions = new Array;
			
			for(var i:int = 0; i < conditionArray.length; i++){
					if(conditionArray[i].DoReaction.selected){
						
						checkedReactions.push(conditionArray[i])
					}
					if(!conditionArray[i].DoReaction.selected){
						
						unCheckedReactions.push(conditionArray[i])
					}
				
				}
			/*trace("Checked Reactions Length")
			trace(checkedReactions.length)
			trace("Checked Reactions Length")
			trace("Unchecked Reactions Length")
			trace(unCheckedReactions.length);
			trace("Unchecked Reactions Length")*/
			
			unCheckedReactionsClip = new MovieClip();
			unCheckedReactionsClip.name = "uncheckedReactionsClip";
			checkedReactionsClip = new MovieClip();
			checkedReactionsClip.name = "checkedReactionsClip";
			var drClip:MovieClip = displayConditions(unCheckedReactions, unCheckedReactionsClip, unCheckedReactionsClip.name)
			drClip.x += 60;
			drClip.y += 20;
			_background.addChild(drClip);
			_background.addChild(displayConditions(checkedReactions, checkedReactionsClip, checkedReactionsClip.name, true, 20, 460));
			
			return unCheckedReactions;

		}
		
		public static function removeItem(array: Array, propertyName: String, value: String): Array
		{
			var newArray: Array = [];
			for (var index: int = 0; index < array.length; index++) {
				var item: Object = array[index];
				if (item && item.hasOwnProperty(propertyName)) {
					if (item[propertyName] != value)
						newArray.push(item);
				}
			}
			return newArray;
		}
		function getReactions():DataProvider{
			return new DataProvider
		}
		function createSlider(slider:Slider, _xLoca:Number, _yLoca:Number, _sliderLabel:TextField, _size:Number):MovieClip
		{
			var sliderClip:MovieClip = new MovieClip();
			var sliderText:TextField = new TextField();
			//createSlider(375, 310, sliderLabel = new TextField, maxBet);
			
			sliderClip.addChild(slider)
			sliderClip.addChild(sliderText)
			
			//position slider
			slider.move(_xLoca,_yLoca);
			
			// control if slider updates instantly or after mouse is released
			slider.liveDragging = true;

			//set size of slider
			slider.setSize(200,200);

			//set maximum value
			slider.maximum = _size;

			//set mininum value
			slider.minimum = 0;
			
			slider.enabled = true;
			
			slider.addEventListener(Event.CHANGE, handleSlider);
			var myFormat:TextFormat = new TextFormat;
			myFormat.size = 12
			
			sliderText.defaultTextFormat = myFormat;
			sliderText.autoSize = "left"
			sliderText.x = slider.x + 60;
			sliderText.y = slider.y + 15;
			sliderText.text = "% to risk";
			
					
			function handleSlider(e:Event):void
			{
				sliderText.text = e.target.value + " % ";
			}
			sliderClip.name = "Reaction Slider";
			return sliderClip;
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
			dg.setSize(825, 150);
			dg.columns = ["Initial Entity", "Math Operator", "Second Entity", "Percent"];
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
			
			var col3:DataGridColumn = new DataGridColumn(); 
			col3 = dg.getColumnAt(3); 
			col3.cellRenderer = CustomRowColors;
			
			var redX:Class = getDefinitionByName("red_X2") as Class;
			var red_X:Bitmap = new Bitmap(new redX());
			red_X.scaleX = 0.05;
			red_X.scaleY = 0.05;
			//red_X.x = dg.x + dg.width + 10;
			//red_X.y = yLoc

			var container:MovieClip = new MovieClip();

			container.addChild(red_X);
			container.y = yLoc - dg.height - 200;
			container.x = dg.width + 10;
			container.buttonMode = true;
			container.name = "DG Delete Clip"
			container.addEventListener(MouseEvent.CLICK,
			function(e:MouseEvent){DeleteFromList(e,dg)});
			
			dg.addChild(container);
			_background.addChild(dg)
			
		}
		
		function DeleteFromList(event:Event, dg:DataGrid):void
		{
			if (dg.selectedIndex > -1)
			{
				if (dg.dataProvider.length > 0)
				{
					var currItmID:String = dg.dataProvider.getItemAt(dg.selectedIndex).ID
					
					deleteGroupByID(dg, currItmID);
				}
			}
		}
		function deleteGroupByID(dg:DataGrid, id:String):void{
			/*trace("This is the ID")
			trace(id);
			trace("This is the ID")
			*/
			
			
			var temp:DataProvider = new DataProvider();
			for(var index:int = 0; index < dg.dataProvider.length; index++){
				
				var currID:String = dg.dataProvider.getItemAt(index).ID
				
				if(currID == id){
					
					dg.dataProvider.getItemAt(index).OriginalCond.DoReaction.selected = false;
					
					conditionArray.push(dg.dataProvider.getItemAt(index).OriginalCond)
				}
				else{
					
					temp.addItem(dg.dataProvider.getItemAt(index))
				}
			}
			dg.dataProvider = new DataProvider(temp);
			checkReactions();
		}

	}
	
}
