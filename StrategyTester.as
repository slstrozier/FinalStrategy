package {
	import ControlPanel.StrategyTester.StrategyTesterGUI
	import flash.display.MovieClip;
	import flash.events.*;
	import ControlPanel.CommonFiles.Util.*
	import flash.text.*
	//This is where a comment needs to be.
	public class StrategyTester extends MovieClip{
		private var bgObject:MovieClip
		private var xLoca:Number;
		private var yLoca:Number;
		private var DISPATCHSTRING:String;
		private var strategyBuilder:StrategyTesterGUI;
		private var strategy:Strategy;
				
		public function StrategyTester(_bgObject:MovieClip, _xLoca:Number, _yLoca:Number, customEventDispatchString:String) {
		
		strategy = Strategy.getInstance();
		bgObject = _bgObject;
		this.x = _xLoca ;
		this.y = _yLoca;
		DISPATCHSTRING = customEventDispatchString;
		init();
		}
		function init():void{
			strategyBuilder = new StrategyTesterGUI();
			strategyBuilder.addEventListener("ResultReady", getResult)
			bgObject.addChild(strategyBuilder);
			var textExit:TextField = new TextField();
			textExit.text = "[Close]";
			textExit.autoSize = "center";
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.color = 0x0033CC;
			//myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			textExit.setTextFormat(myFormat);
			textExit.x = 617;
			textExit.y = -478;
			
		}
		
		function getResult(event:CustomEvent):void{
			
			dispatchCustomEvent(event.data);
			
		}
		public function sendStrategyResult(_data:String):String{
			return(_data);
		}
		public function destroySelf():void{
			bgObject.removeChild(this);
		}
		public function dispatchCustomEvent(data:String):void{
			
			dispatchEvent(new CustomEvent(DISPATCHSTRING, data));
			
		}

	}
	
}
