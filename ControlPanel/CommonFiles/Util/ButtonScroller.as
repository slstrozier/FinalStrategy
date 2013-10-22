package ControlPanel.CommonFiles.Util
{
	import flash.display.MovieClip;
	import ControlPanel.CommonFiles.Scroll.*;
	//import flashx.textLayout.operations.MoveChildrenOperation;
	
	public class ButtonScroller extends MovieClip
	{
		private var _background:MovieClip;
		private var toBeScrolled:MovieClip;
		private var myScroll:MyFlashLabScrollbar;
		private var xLoca:Number;
		private var yLoca:Number;
		private var myWidth:Number;
		private var myHeight:Number;
		
		public function ButtonScroller(toBeScrolled:MovieClip, xLoca:Number, yLoca:Number,  height:Number = 172, width:Number = 925):void
		{
			
			this.xLoca = xLoca;
			this.yLoca = yLoca;
			this.myWidth = width;
			this.myHeight = height;
			myScroll = new MyFlashLabScrollbar(toBeScrolled); // toBeScrolled is the movieclip you want to scroll
			
			// set the scrollbar properties
			myScroll.w = myWidth;
			myScroll.h = myHeight;
			myScroll.speed = 50;
			myScroll.position = MyFlashLabScrollbarPositions.AUTO;
			myScroll.showHandCursor = true;
			
			myScroll.finalize(); // finalize the scrollbar and ready to be shown
			
			myScroll.x = xLoca;
			myScroll.y = yLoca;
			addChild(myScroll);
		}
		
	}
}