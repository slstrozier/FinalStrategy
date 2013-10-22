package ControlPanel.TBLCharts{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Util.*
	
	public class PresetTBLCharts extends MovieClip{
		
		private var myStage:MovieClip;
		private var tblButtons:ButtonCreator;
		private var dates:Array;
		
		public function PresetTBLCharts(stage:MovieClip) {
			myStage = stage
			this.name = "Preset TBL Charts";
			dates = new Array("ALL", "NOW")
			setupOutline();
			addChild(addBoxes());
		}
		function setupOutline():void{

			myStage.addChild(this);
			graphics.lineStyle(1,0x000000, 1);
			graphics.drawRect(myStage.x,myStage.y,350,150);
		}
		function addBoxes():MovieClip{
			tblButtons = new ButtonCreator("tbl", 0x66CC22, 0xCCFFCC);
			tblButtons.y = -45
			tblButtons.x = 30;
			tblButtons.addEventListener("QueryResultReady", handleQueryResult)
			
			return tblButtons;
		}
		
		function handleQueryResult(event:CustomEvent):void{
			
			sendQueryResults(event.data);
		}
		public function setDates(dates:Array):void{
			tblButtons.setDates(dates);
		}
		function sendQueryResults(results:String):void{
			dispatchEvent(new CustomEvent("QueryResultReady", results));
		}

	}
	
}
