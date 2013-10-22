package 
{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Util.CustomEvent;
	import ControlPanel.TBLCharts.PresetTBLCharts;
	import ControlPanel.INDCharts.PresetINDCharts;
	import ControlPanel.CustomCharts.CustomCharts;
	import ControlPanel.Scans.StockScans;
	import ControlPanel.QSB.QueryStringBuilderGUI;
	import ControlPanel.Signals.Signals;
	import ControlPanel.Login.LoginIn;
	import ControlPanel.CommonFiles.DoubleSlider.DoubleSlider;
	import ControlPanel.CommonFiles.Util.*;
	import flash.events.*;
	import flash.display.DisplayObject;
	import fl.controls.Slider;
	import flash.filters.* 

	import fl.controls.Label;

	import flash.display.Shape;



	public class FinalStrategyGUI extends MovieClip
	{
		private var myBackground:MovieClip;
		private var presetTBLCharts:PresetTBLCharts;
		private var presetINDCharts:PresetINDCharts;
		private var customCharts:CustomCharts;
		private var stockScans:StockScans;
		private var signals:Signals;
		private var logIn:LoginIn;
		private var strategyTester:StrategyTester;
		private var user:String;
		private var queryStringBuilder:QueryStringBuilderGUI;
		private var customChartData:String;
		private var queryResultData:String;
		private var strategyResultData:String;
		private var xLocation:Number;
		private var yLocation:Number;
		private var controlPanelX:Number;
		private var controlPanelY:Number;
		private var strategy:Strategy;
		private var dateSlider:Slider;
		private var _dSlider:DoubleSlider;



		public function FinalStrategyGUI(stage:MovieClip, xLoca:Number, yLoca:Number, controlPanelX:Number, controlPanelY:Number)
		{
			xLocation = xLoca;
			yLocation = yLoca;
			this.controlPanelX = controlPanelX;
			this.controlPanelY = controlPanelY;
			myBackground = new MovieClip();
			//drawBackground();
			stage.addChild(this);
			addChild(myBackground);
			skipLogin();

			//doLogin();


		}
		function setDateSlider():void
		{
			_dSlider = new DoubleSlider(1950,2012,640,true);
			_dSlider.x = 30;
			_dSlider.y = 190;
			_dSlider.addEventListener(Event.CHANGE, sliderHandler);
			myBackground.addChild(_dSlider);
			//_dSlider.setNewDates(new Array(1988, 2009));
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x000000);
			line.graphics.moveTo(0, 230);
			line.graphics.lineTo(700, 230);

			myBackground.addChild(line);
		}

		function sliderHandler(event:Event):void
		{
			var newDates:Array = new Array(_dSlider.minimumValue,_dSlider.maximumValue);

			setAllDates(newDates);
			
		}
		function setAllDates(newDates:Array):void
		{
			
			presetINDCharts.setDates(newDates);
			presetTBLCharts.setDates(newDates);
			stockScans.setDates(newDates);
			queryStringBuilder.setDates(newDates);

		}
		function drawBackground():void
		{
			//_background = new MovieClip();
			myBackground.alpha = 1;
			myBackground.graphics.lineStyle(1, 0x000000);
			myBackground.graphics.beginFill(0xEEEEEE, 1);
			//myBackground.x = controlPanelX;
			//myBackground.y = controlPanelY;
			myBackground.graphics.drawRect(0,0,900,600);
			myBackground.graphics.endFill();
			var strategyTesterClip:StrategyTesterClip = new StrategyTesterClip();
			//strategyTesterClip.scaleX = 1.14;
			//strategyTesterClip.scaleY = 0.4;
			strategyTesterClip.mouseChildren = false;
			strategyTesterClip.x = 777;
			strategyTesterClip.y = 345;
			strategyTesterClip.buttonMode = true;
			strategyTesterClip.addEventListener(MouseEvent.CLICK, openStratTester);
			setDropShadow(strategyTesterClip);
			myBackground.addChild(strategyTesterClip);
			
			var navBox:MovieClip = new MovieClip;
			with(navBox){
				graphics.lineStyle(1);
				graphics.drawRect(800, 440, 200, 60)
				
			}
			addChild(navBox);
			
		}
		function setDropShadow(obj:MovieClip):void{
			
			var dsf:DropShadowFilter = new DropShadowFilter();
			obj.filters =  [dsf]
			obj.filters = [];
		}
		function openStratTester(event:Event):void
		{

			strategyTester = new StrategyTester(this,300,600,"QueryResultReady");
			strategyTester.addEventListener("QueryResultReady", handleStratResultReady);
			addChild(strategyTester);
		}
		
		function doLogin():void
		{
			var movieCli:MovieClip = new MovieClip  ;
			logIn = new LoginIn(movieCli,xLocation,yLocation);
			logIn.addEventListener("LoginSuccesful", checkLogin);
			myBackground.addChild(movieCli);
			movieCli.x = xLocation;
			movieCli.y = yLocation;
		}
		function checkLogin(event:CustomEvent):void
		{

			user = event.data;
			strategy = Strategy.getInstance();
			strategy.addEventListener("StrategyReady", init);

		}
		function skipLogin():void
		{
			user = "user1";
			strategy = Strategy.getInstance();
			strategy.addEventListener("StrategyReady", init);
		}
		function init(event:Event):void
		{

			var mc:MovieClip = new MovieClip();
			//logIn.destroySelf();
			presetTBLCharts = new PresetTBLCharts(myBackground);
			presetTBLCharts.addEventListener("QueryResultReady", handleQueryResult);
			//mc.addChild(presetTBLCharts);

			presetINDCharts = new PresetINDCharts(myBackground);
			presetINDCharts.addEventListener("QueryResultReady", handleQueryResult);
			customCharts = new CustomCharts(myBackground,user);
			customCharts.addEventListener("CustomChartDataReady", handleQueryResultCustomChart);
			stockScans = new StockScans(myBackground,user);
			stockScans.addEventListener("QueryResultReady", handleQueryResult);
			signals = new Signals(myBackground,this.user);
			signals.addEventListener("QueryResultReady", handleQueryResult);
			//signals.addEventListener("QueryResultReady", handleQueryResult);

			queryStringBuilder = new QueryStringBuilderGUI(myBackground);
			queryStringBuilder.addEventListener("QueryResultReady", handleQueryResult);
			queryStringBuilder.addEventListener("DatesRecieved", handleReceivedDates);

			queryStringBuilder.y = 230;
			queryStringBuilder.x = -75;

			mc.addChild(this.myBackground);
			mc.x = controlPanelX;
			mc.y = controlPanelY;
			addChild(mc);
			drawBackground();
			setDateSlider();
			setAllDates(new Array(1950, 2012));
			dispatchEvent(new Event("Load Complete"));
			//dateSlider.setNewDates(new Array(1983, 2009));
		}

		function handleReceivedDates(event:CustomEvent):void
		{
			_dSlider.setNewDates(event.data);

		}
		function handleQueryResult(event:CustomEvent):void
		{
			queryResultData = event.data;
			dispatchEvent(new Event("QueryResultReady"));
		}

		function handleQueryResultCustomChart(event:CustomEvent):void
		{
			customChartData = event.data;
			dispatchEvent(new Event("CustomChartDataReady"));
			
		}
		
		function handleStratResultReady(event:CustomEvent):void{
			
			strategyResultData = event.data;
			dispatchEvent(new Event("StrategyResultReady"));
		}
		public function returnCustomChartData():String
		{
			return this.customChartData;
		}
		public function returnQueryData():String
		{
			return this.queryResultData;
		}
		public function returnStrategyResult():String
		{
			return this.strategyResultData;
		}
		public function createB3Btn(bttnName:String, bttnLabel:String, bttnData:String):void
		{
			customCharts.addNewButton(bttnName, bttnLabel, bttnData);
		}

	}

}