package ControlPanel.Scans{
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
	import flash.text.TextFormat;
	import fl.controls.Button;
	import ControlPanel.CommonFiles.Util.CustomEvent

	
	public class ScanEntityBuilder extends MovieClip{
		
		private var STRATEGY:Strategy;
		private var submitButton:Button;
		private var initialScanEntity:ScanEntity;
		private var comparedScanEntity:ScanEntity;
		private var database:Object;
		
		public function ScanEntityBuilder(database:Object) {
			STRATEGY = Strategy.getInstance();
			this.database = database;
			//comparedScanEntity = new ScanEntity(true, database);
			var temp:ScanEntity = createEntity(false);
			initialScanEntity = temp;
			initialScanEntity.addEventListener("CandleCreationComplete", handleCandle);
			initialScanEntity.addEventListener("mathOpsSelected", handleMathOp);
			initialScanEntity.addEventListener("comparedScanEntityRemoved", handleComparedRemoved);
			initialScanEntity.addEventListener("comparedScanEntityAdded", handleComparedScanEntityAdded);
			initialScanEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			initialScanEntity.addEventListener("enableDone", activateDoneButton);
			initialScanEntity.addEventListener("RemovedButtonClicked", removeinitialScanEntity)
			
			addChild(initialScanEntity);
			
		}
		function reset():void{
			//comparedScanEntity = new ScanEntity(true, this.database);
			var temp:ScanEntity = createEntity(false);
			initialScanEntity = temp;
			//initialScanEntity.iscomparedScanEntity = false;
			//initialScanEntity.addEventListener("CompareEntity", newEntity)
			initialScanEntity.addEventListener("CandleCreationComplete", handleCandle);
			initialScanEntity.addEventListener("mathOpsSelected", handleMathOp);
			initialScanEntity.addEventListener("comparedScanEntityRemoved", handleComparedRemoved);
			initialScanEntity.addEventListener("comparedScanEntityAdded", handleComparedScanEntityAdded);
			initialScanEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			initialScanEntity.addEventListener("enableDone", activateDoneButton);
			initialScanEntity.addEventListener("RemovedButtonClicked", removeinitialScanEntity)
			
			addChild(initialScanEntity);
		}
		function removeinitialScanEntity(event:Event):void{
			removeChild(initialScanEntity);
		}
		function activateDoneButton(event:Event):void{
			createSubmitButton(300, 200);
		}
		function handleRemove(event:Event):void{
			if(comparedScanEntity){
				if(comparedScanEntity.stage){
				removeChild(comparedScanEntity);
				
				}
			}
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
		}
		function handleComparedRemoved(event:Event):void{
			removeChild(comparedScanEntity);
			submitButton.move(300, 200);
			initialScanEntity.addRemoveClip();
			
		}
		function handleComparedScanEntityAdded(event:Event):void{
			createNewEntity(true);
			submitButton.move(700, 200);
			initialScanEntity.removeRemoveClip();
		}
		function handleMathOp(event:CustomEvent):void{
			
			
		}
		function handleCandle(event:Event):void{
			
			initialScanEntity.updateFieldOptions();
			
			if(!submitButton){
				createSubmitButton();
			}
			if(!submitButton.stage){
				createSubmitButton();
			}
			
		}
		function createEntity(isCompared:Boolean):ScanEntity{
			var tempEnt = new ScanEntity(isCompared, this.database);
			return tempEnt;
		}
		function createSubmitButton(xLoca:Number = 300, yLoca:Number = 200):void{
			
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
			submitButton = new Button();
			submitButton.setSize(125, 25);
			submitButton.emphasized = true;
			submitButton.addEventListener(MouseEvent.CLICK, compareEntities);
			submitButton.label = "Done"
			submitButton.move(xLoca, yLoca);
			submitButton.enabled = true;
			addChild(submitButton)
		}
		function createNewEntity(isCompared:Boolean):void{
			var me:MovieClip = createEntity(isCompared);
			addChild(me);
			
			comparedScanEntity = me as ScanEntity;
			comparedScanEntity.x += 400;
			//comparedScanEntity.setIsCompared(false);
			comparedScanEntity.addEventListener("RemovedButtonClicked", resetInitialMathOps)
			
			addChild(comparedScanEntity);
			
		}
		function resetInitialMathOps(event:Event):void{
			initialScanEntity.resetMathOps();
			removeSubmitButton();
		}
		function removeSubmitButton():void{
			if(submitButton.stage){
				removeChild(submitButton);
			}
		}
		function compareEntities(event:Event):void{
			
			var xmlAndDesc:Array;
			var initialScanInfo = initialScanEntity.setXML()[0];
			
			if(comparedScanEntity){
				if(!comparedScanEntity.stage){
				
				xmlAndDesc = new Array({Summery: initialScanInfo.Summery, MathOp: initialScanInfo.MathOp, SecondEntSummery: "No Second Entity", XML:initialScanInfo.XML});
				}
			}
			if(!comparedScanEntity){
				xmlAndDesc = new Array({Summery: initialScanInfo.Summery, MathOp: initialScanInfo.MathOp, SecondEntSummery: "No Second Entity", XML:initialScanInfo.XML});
			}
			
			if(comparedScanEntity){
				if(comparedScanEntity.stage){

				var comparedScanInfo = comparedScanEntity.setXML()[0];
				var secondScanEntityXML:XML = new XML(<SecondEntity/>);
				var comparedScanEntityArray:Array = comparedScanEntity.getConditionalEntityArray();
				var comparedScanEntityType:String = comparedScanEntityArray[0];
				var comparedScanEntityCond:String = comparedScanEntityArray[1];
				var dualEntityXML:XML = initialScanInfo.XML;
				
				secondScanEntityXML["SecondEntity"].@ ["type"] = comparedScanEntityType;
				secondScanEntityXML["SecondEntity"] = comparedScanEntityCond;
				xmlAndDesc = new Array({Summery: initialScanInfo.Summery, MathOp: initialScanInfo.MathOp, SecondEntSummery: comparedScanInfo.Summery, XML:dualEntityXML});
				dualEntityXML.appendChild(secondScanEntityXML["SecondEntity"]);
				}
				
			}
			dispatchEvent(new CustomEvent("ConditionAdded", xmlAndDesc));
			if(initialScanEntity.stage){
				removeChild(initialScanEntity)
			}
			if(comparedScanEntity){
				if(comparedScanEntity.stage){
					removeChild(comparedScanEntity);
				}
			}
			
			reset();
		}
		

	}
}
