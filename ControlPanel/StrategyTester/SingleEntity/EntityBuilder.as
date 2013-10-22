package ControlPanel.StrategyTester.SingleEntity{
	import flash.display.MovieClip;
	import flash.events.*
	import fl.controls.Button;
	import ControlPanel.CommonFiles.Util.*
	//uses a SingleEntity
	public class EntityBuilder extends MovieClip{

		private var initialEntity:SingleEntity;
		private var secondEntity:SingleEntity;
		private var submitButton:Button;
		private var inTrade:Boolean;
		
		public function EntityBuilder(inTrade:Boolean = true) {
			this.inTrade = inTrade;
			submitButton = new Button()
			//secondEntity = new SingleEntity(this, true);
			var temp:SingleEntity = createEntity(false);
			initialEntity = temp;
			initialEntity.x += 25;
			initialEntity.addEventListener("ComparedSingleEntityRemoved", handleComparedRemoved);
			initialEntity.addEventListener("ComparedSingleEntityAdded", handleComparedSingleEntityAdded);
			initialEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			initialEntity.addEventListener("enableDone", activateDoneButton);
			initialEntity.addEventListener("RemovedButtonClicked", removeInitialSingleEntity)
			initialEntity.addEventListener("CandleCreationComplete", handleCandleCreationComplete)
			
			addChild(initialEntity);
			
		}
		function handleCandleCreationComplete(event:Event):void{
			initialEntity.updateFieldOptions();
			
			if(!submitButton){
				createSubmitButton();
			}
			if(!submitButton.stage){
				createSubmitButton();
			}
			
		}
		function reset():void{
			//secondEntity = new SingleEntity(this, true);
			var temp:SingleEntity = createEntity(false);
			initialEntity = temp;
			initialEntity.addEventListener("ComparedSingleEntityRemoved", handleComparedRemoved);
			initialEntity.addEventListener("ComparedSingleEntityAdded", handleComparedSingleEntityAdded);
			initialEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			initialEntity.addEventListener("enableDone", activateDoneButton);
			initialEntity.addEventListener("RemovedButtonClicked", removeInitialSingleEntity)
			initialEntity.addEventListener("CandleCreationComplete", handleCandleCreationComplete)
			
			addChild(initialEntity);
		}
		function removeInitialSingleEntity(event:Event):void{
			removeChild(initialEntity);
		}
		function activateDoneButton(event:Event):void{
			createSubmitButton(350, 225);
		}
		function handleRemove(event:Event):void{
			if(secondEntity){
				if(secondEntity.stage){
				removeChild(secondEntity);
				
				}
			}
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
		}
		function handleComparedRemoved(event:Event):void{
			
			removeChild(secondEntity);
			submitButton.move(350, 225);
			
		}
		
		function handleComparedSingleEntityAdded(event:Event):void{
			
			createComparedSingleEntity();
			submitButton.move(800, 225);
			initialEntity.removeRemoveClip();
		}
		
		
		function createEntity(isComparedEntity:Boolean):SingleEntity{
			var tempEnt = new SingleEntity(this, isComparedEntity, this.inTrade);
			return tempEnt;
		}
		function createSubmitButton(xLoca:Number = 350, yLoca:Number = 225):void{
			
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
			submitButton = new Button();
			submitButton.setSize(140, 25);
			submitButton.emphasized = true;
			submitButton.addEventListener(MouseEvent.CLICK, compareEntities);
			submitButton.label = "Save Condition"
			submitButton.move(xLoca, yLoca);
			submitButton.enabled = true;
			addChild(submitButton)
		}
		
		function createComparedSingleEntity():void{
			
			secondEntity = new SingleEntity(this, true, this.inTrade, initialEntity.getType());
			secondEntity.x += 550;
			secondEntity.addEventListener("RemovedButtonClicked", resetInitialMathOps)
			
			addChild(secondEntity);
		}
		function resetInitialMathOps(event:Event):void{
			initialEntity.resetMathOps();
			removeSubmitButton();
		}
		function removeSubmitButton():void{
			if(submitButton.stage){
				removeChild(submitButton);
			}
		}
		function compareEntities(event:Event):void{
			var xmlAndDesc:Array;
			var initialSingleInfo = initialEntity.setXML()[0];
			if(secondEntity){
				if(!secondEntity.stage){
				
				xmlAndDesc = new Array({Summery: initialSingleInfo.Summery, MathOp: initialSingleInfo.MathOp, SecondEntSummery: "No Second Entity", XML:initialSingleInfo.XML});
				}
			}
			if(!secondEntity){
				xmlAndDesc = new Array({Summery: initialSingleInfo.Summery, MathOp: initialSingleInfo.MathOp, SecondEntSummery: "No Second Entity", XML:initialSingleInfo.XML});
			}
			
			if(secondEntity){
				if(secondEntity.stage){

					var comparedSingleInfo = secondEntity.setXML()[0];
					var secondSingleEntityXML:XML = new XML(<SecondEntity/>);
					var secondEntityArray:Array = secondEntity.getConditionalEntityArray();
					var secondEntityType:String = secondEntityArray[0];
					var secondEntityCond:String = secondEntityArray[1];
					var dualEntityXML:XML = initialSingleInfo.XML;
					
					secondSingleEntityXML["SecondEntity"].@ ["type"] = secondEntityType;
					secondSingleEntityXML["SecondEntity"] = secondEntityCond;
					xmlAndDesc = new Array({Summery: initialSingleInfo.Summery, MathOp: initialSingleInfo.MathOp, SecondEntSummery: comparedSingleInfo.Summery, XML:dualEntityXML});
					dualEntityXML.appendChild(secondSingleEntityXML["SecondEntity"]);
				}
			}
			
			dispatchEvent(new CustomEvent("ConditionAdded", xmlAndDesc));
			if(initialEntity.stage){
				removeChild(initialEntity)
			}
			if(secondEntity){
				if(secondEntity.stage){
					removeChild(secondEntity);
					
				}
			}
			
			reset();
		}
		

	}
	
}
