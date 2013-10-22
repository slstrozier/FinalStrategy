package ControlPanel.INDCharts{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Util.*
	
	public class PresetINDCharts extends MovieClip{
		
		private var myStage:MovieClip;
		private var indButtons:ButtonCreator;
		private var dates:Array;
		
		public function PresetINDCharts(stage:MovieClip) {
			myStage = stage
			dates = new Array("ALL", "NOW");
			setupOutline();
			addChild(addBoxes());
		}
		function setupOutline():void{			
			myStage.addChild(this);
			graphics.lineStyle(1,0x000000, 1);
			graphics.drawRect(myStage.x + 350,myStage.y,350,150);
		}
		function addBoxes():MovieClip{
			indButtons = new ButtonCreator("ind", 0x6699FF, 0x66EEFF, 325, 375, -45);
			indButtons.addEventListener("QueryResultReady", handleQueryResult)
			return indButtons;
		}
		
		function handleQueryResult(event:CustomEvent):void{
			
			sendQueryResults(event.data);
		}
		function sendQueryResults(results:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", results));
		}
		public function setDates(dates:Array):void{
			indButtons.setDates(dates);
		}

	}
	
}
