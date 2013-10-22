package ControlPanel.Signals{
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
	import ControlPanel.CommonFiles.Util.*

	//Opened by a Signal
	public class SignalEntityBuilder extends MovieClip{
		
		private var STRATEGY:Strategy;
		private var submitButton:Button;
		private var initialSignalEntity:SignalEntity;
		private var comparedSignalEntity:SignalEntity;
		
	
		
		public function SignalEntityBuilder() {
			STRATEGY = Strategy.getInstance();
			submitButton = new Button()
			//comparedSignalEntity = new SignalEntity(this, true);
			var temp:SignalEntity = createSignalEntity(false);
			initialSignalEntity = temp;
			initialSignalEntity.x += 25;
			initialSignalEntity.addEventListener("ComparedSignalEntityRemoved", handleComparedRemoved);
			initialSignalEntity.addEventListener("ComparedSignalEntityAdded", handleComparedSignalEntityAdded);
			initialSignalEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			initialSignalEntity.addEventListener("enableDone", activateDoneButton);
			initialSignalEntity.addEventListener("RemovedButtonClicked", removeInitialSignalEntity)
			initialSignalEntity.addEventListener("CandleCreationComplete", handleCandleCreationComplete)
			
			addChild(initialSignalEntity);
			
		}
		function handleCandleCreationComplete(event:Event):void{
			initialSignalEntity.updateFieldOptions();
			
			if(!submitButton){
				createSubmitButton();
			}
			if(!submitButton.stage){
				createSubmitButton();
			}

		}
		function reset():void{
			
			var temp:SignalEntity = createSignalEntity(false);
			initialSignalEntity = temp;
			initialSignalEntity.addEventListener("ComparedSignalEntityRemoved", handleComparedRemoved);
			initialSignalEntity.addEventListener("ComparedSignalEntityAdded", handleComparedSignalEntityAdded);
			initialSignalEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			initialSignalEntity.addEventListener("enableDone", activateDoneButton);
			initialSignalEntity.addEventListener("RemovedButtonClicked", removeInitialSignalEntity)
			
			addChild(initialSignalEntity);
		}
		function removeInitialSignalEntity(event:Event):void{
			removeChild(initialSignalEntity);
		}
		function activateDoneButton(event:Event):void{
			createSubmitButton(300, 285);
		}
		function handleRemove(event:Event):void{
			if(comparedSignalEntity){
				if(comparedSignalEntity.stage){
				removeChild(comparedSignalEntity);
				
				}
			}
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
		}
		function handleComparedRemoved(event:Event):void{
			
			removeChild(comparedSignalEntity);
			submitButton.move(300, 285);
			
		}
		
		function handleComparedSignalEntityAdded(event:Event):void{
			
			createComparedSignalEntity();
			submitButton.move(750, 285);
			initialSignalEntity.removeRemoveClip();
		}
		
		
		function createSignalEntity(isComparedEntity:Boolean):SignalEntity{
			var tempEnt = new SignalEntity(this, isComparedEntity);
			return tempEnt;
		}
		function createSubmitButton(xLoca:Number = 300, yLoca:Number = 300):void{
			
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
			submitButton = new Button();
			//submitButton.label = "Compare SignalEntity"
			submitButton.setSize(125, 25);
			submitButton.emphasized = true;
			//submitButton.setStyle("icon", BulletCheck);
			//submitButton.textField.wordWrap = true;
			
			//submitButton.removeEventListener(MouseEvent.CLICK, newSignalEntity);
			submitButton.addEventListener(MouseEvent.CLICK, compareEntities);
			submitButton.label = "Done"
			submitButton.move(xLoca, yLoca);
			submitButton.enabled = true;
			//submitButton.addEventListener(MouseEvent.CLICK, newSignalEntity);
			//submitButton.x = _background.width - 140;
			//submitButton.y = _background.height - 65;
			//initialSignalEntity.addEventListener("mathOpsSelected", newMathOp)
			addChild(submitButton)
		}
		
		function createComparedSignalEntity():void{
			
			
			comparedSignalEntity = new SignalEntity(this, true, initialSignalEntity.getType());
			comparedSignalEntity.x += 550;
			comparedSignalEntity.addEventListener("RemovedButtonClicked", resetInitialMathOps)
			
			addChild(comparedSignalEntity);
		}
		function resetInitialMathOps(event:Event):void{
			initialSignalEntity.resetMathOps();
			removeSubmitButton();
		}
		function removeSubmitButton():void{
			if(submitButton.stage){
				removeChild(submitButton);
			}
		}
		function compareEntities(event:Event):void{
			
			var xmlAndDesc:Array;
			var initialSignalInfo = initialSignalEntity.setXML()[0];
			if(comparedSignalEntity){
				if(!comparedSignalEntity.stage){
				
				xmlAndDesc = new Array({Summery: initialSignalInfo.Summery, MathOp: initialSignalInfo.MathOp, SecondEntSummery: "No Second Entity", XML:initialSignalInfo.XML});
				}
			}
			if(!comparedSignalEntity){
				xmlAndDesc = new Array({Summery: initialSignalInfo.Summery, MathOp: initialSignalInfo.MathOp, SecondEntSummery: "No Second Entity", XML:initialSignalInfo.XML});
			}
			
			if(comparedSignalEntity){
				if(comparedSignalEntity.stage){

					var comparedSignalInfo = comparedSignalEntity.setXML()[0];
					var secondSignalEntityXML:XML = new XML(<SecondEntity/>);
					var comparedSignalEntityArray:Array = comparedSignalEntity.getConditionalEntityArray();
					var comparedSignalEntityType:String = comparedSignalEntityArray[0];
					var comparedSignalEntityCond:String = comparedSignalEntityArray[1];
					var dualEntityXML:XML = initialSignalInfo.XML;
					
					secondSignalEntityXML["SecondEntity"].@ ["type"] = comparedSignalEntityType;
					secondSignalEntityXML["SecondEntity"] = comparedSignalEntityCond;
					xmlAndDesc = new Array({Summery: initialSignalInfo.Summery, MathOp: initialSignalInfo.MathOp, SecondEntSummery: comparedSignalInfo.Summery, XML:dualEntityXML});
					dualEntityXML.appendChild(secondSignalEntityXML["SecondEntity"]);
				}
			}
			dispatchEvent(new CustomEvent("ConditionAdded", xmlAndDesc));
			if(initialSignalEntity.stage){
				removeChild(initialSignalEntity)
			}
			if(comparedSignalEntity){
				if(comparedSignalEntity.stage){
					removeChild(comparedSignalEntity);
					
				}
			}
			
			reset();
		}
		

	}
}
