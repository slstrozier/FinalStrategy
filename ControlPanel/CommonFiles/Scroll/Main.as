package ControlPanel.CommonFiles.Scroll
{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Scroll.*;
	//import flashx.textLayout.operations.MoveChildrenOperation;
	
	public class Main extends MovieClip
	{
		private var _background:MovieClip;
		private var toBeScrolled:MovieClip;
		private var myScroll:MyFlashLabScrollbar;
		
		public function Main(toBeScrolled:MovieClip):void
		{
			
			// initialize the scrollbar
			myScroll = new MyFlashLabScrollbar(toBeScrolled); // toBeScrolled is the movieclip you want to scroll
			
			// set the scrollbar properties
			myScroll.w = 925;
			myScroll.h = 230;
			myScroll.speed = 25;
			myScroll.position = MyFlashLabScrollbarPositions.AUTO;
			myScroll.showHandCursor = true;
			
			myScroll.finalize(); // finalize the scrollbar and ready to be shown
			
			myScroll.x = 5;
			myScroll.y = 0;
			this.addChild(drawBackground());
			_background.addChild(myScroll);
		}
		
		function drawBackground():MovieClip
		{

			_background = new MovieClip();
			//var _background:MovieClip = new MovieClip();
			_background.graphics.lineStyle(1);
			_background.graphics.beginFill(0xFFFFFF);
			_background.graphics.drawRect(55, 0, 830, 225);
			_background.graphics.endFill();
			return _background;
		}
	}
}