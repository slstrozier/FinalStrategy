package 
{

	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.filters.DropShadowFilter;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;


	public class CustomCandle extends MovieClip
	{

		public var y_Change:int;
		public var OPEN_CONTAIN:Sprite;
		public var HIGH_CONTAIN:Sprite;
		public var LOW_CONTAIN:Sprite;
		public var CLOSE_CONTAIN:Sprite;
		public var containerList:Array;
		public var boundary:Rectangle;
		public var openBoundry:Rectangle;
		public var closeBoundry:Rectangle;
		public var lineDrawing:Sprite;
		public var candleBodyInitialY:Number;
		public var candleBodyFinalY:Number;
		public var candleBodyBounds:Rectangle;
		public var x_Change:Number;
		public var OPEN_CLOSE:String = "";
		public var candleBody:Sprite;
		public var Open:TextField = new TextField();

		public function CustomCandle()
		{
			candleBody = new Sprite();
			trace("custom candle");
			lineDrawing = new Sprite();
			candleBodyInitialY = new Number();
			candleBodyBounds = new Rectangle();
			OPEN_CONTAIN = new Sprite();
			HIGH_CONTAIN = new Sprite();
			LOW_CONTAIN = new Sprite();
			CLOSE_CONTAIN = new Sprite();
			containerList = new Array();
			/////////////
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 0;
			dropShadow.angle = 45;
			dropShadow.color = 0x333333;
			dropShadow.alpha = 1;
			dropShadow.blurX = 2;
			dropShadow.blurY = 2;
			dropShadow.strength = 1;
			dropShadow.quality = 15;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;
			filters = new Array(dropShadow);

			
			addEventListener(MouseEvent.MOUSE_UP, GlobalRelease);
			lineDrawing.graphics.lineStyle(1);
			lineDrawing.graphics.beginFill(0x99FFFF);
			lineDrawing.graphics.moveTo(200,50);
			lineDrawing.graphics.lineTo(200, 300);
			addChild(lineDrawing);
			var Open:TextField = new TextField();
			Open.x = 300;
			Open.y = 300;
			addChild(Open);

			
			with (candleBody)
			{
				x = 185;
				y = 150;
				buttonMode = true;
			}
			with (candleBody.graphics)
			{
				beginFill(0xFFFFFF);
				lineStyle(1,0x6699FF);
				drawRect(0, 0, 30, 70);
				candleBodyInitialY = 50;
				candleBodyBounds = getBounds(candleBody);
				openBoundry = new Rectangle(candleBody.x - 60,candleBody.y - 24,0,candleBody.height - 2);
				closeBoundry = new Rectangle(candleBody.x + 25,candleBody.y - 24,0,candleBody.height - 2);
			}
			addChild(candleBody);
			candleBody.addEventListener(MouseEvent.MOUSE_DOWN, CandleMouseDown);
			candleBody.addEventListener(MouseEvent.MOUSE_UP, CandleMouseUp);

			OPEN_CONTAIN.x = candleBody.x - 60;
			OPEN_CONTAIN.y = candleBody.y + 24;
			OPEN_CONTAIN.addEventListener(MouseEvent.MOUSE_DOWN, OpenMouseDown);
			OPEN_CONTAIN.addEventListener(MouseEvent.MOUSE_UP, OpenMouseUp);
			CLOSE_CONTAIN.x = candleBody.x + 25;
			CLOSE_CONTAIN.y = candleBody.y - 24;
			CLOSE_CONTAIN.addEventListener(MouseEvent.MOUSE_DOWN, CloseMouseDown);
			CLOSE_CONTAIN.addEventListener(MouseEvent.MOUSE_UP, CloseMouseUp);
			addEventListener(Event.ENTER_FRAME, Update_Y_Change);
			addEventListener(Event.ENTER_FRAME, CheckOpen);
			boundary = new Rectangle(candleBody.x,70,0,140);

			PlaceImage(OPEN_CONTAIN, "tag_arm_flipped.png", Trace, stage);

			//PlaceImage(HIGH_CONTAIN, "high.png", Trace, this.stage);
			//PlaceImage(LOW_CONTAIN, "low.png", Trace, this.stage);
			PlaceImage(CLOSE_CONTAIN, "tag_arm.png", Trace, stage);
		}
		function GlobalRelease(e:Event):void
		{
			CLOSE_CONTAIN.stopDrag();
			OPEN_CONTAIN.stopDrag();
			HIGH_CONTAIN.stopDrag();
			LOW_CONTAIN.stopDrag();
			candleBody.stopDrag();
		}
		function CloseMouseDown(e:Event):void
		{
			CLOSE_CONTAIN.startDrag(false, closeBoundry);
		}

		function CloseMouseUp(e:Event):void
		{

			CLOSE_CONTAIN.stopDrag();
		}


		function ChangeY(e:Event):void
		{
			OPEN_CONTAIN.y = candleBody.y + 24;
			CLOSE_CONTAIN.y = candleBody.y + 24;

		}
		function Update_Y_Change(e:Event):void
		{
			y_Change = candleBody.y;
			x_Change = candleBody.x;

			//trace("Mouse X: " + mouseX + " Mouse Y: " + mouseY + " CandleBodyBounds = " + candleBodyBounds.top)
		}
		function CandleMouseDown(e:Event):void
		{
			//OPEN_CONTAIN.x = candleBody.x - 60;
			//OPEN_CONTAIN.y = candleBody.y + 24;
			//CLOSE_CONTAIN.x = candleBody.x + 25;
			//CLOSE_CONTAIN.y = candleBody.y + 24;
			OPEN_CONTAIN.addEventListener(Event.ENTER_FRAME, ChangeY);
			CLOSE_CONTAIN.addEventListener(Event.ENTER_FRAME, ChangeY);
			candleBody.startDrag(false, boundary);

		}
		function CandleMouseUp(e:Event):void
		{

			candleBody.stopDrag();
			OPEN_CONTAIN.removeEventListener(Event.ENTER_FRAME, ChangeY);
			OPEN_CONTAIN.removeEventListener(Event.ENTER_FRAME, ChangeY);
			CLOSE_CONTAIN.removeEventListener(Event.ENTER_FRAME, ChangeY);
			CLOSE_CONTAIN.removeEventListener(Event.ENTER_FRAME, ChangeY);
			openBoundry = new Rectangle(candleBody.x - 60,candleBody.y - 24,0,candleBody.height - 2);
			closeBoundry = new Rectangle(candleBody.x + 25,candleBody.y - 24, 0, candleBody.height - 2)
			;
		}


		function OpenMouseDown(e:Event):void
		{
			OPEN_CONTAIN.startDrag(false, openBoundry);
		}

		function OpenMouseUp(e:Event):void
		{

			OPEN_CONTAIN.stopDrag();
		}

		//closeBoundry = new Rectangle(200,50, 0, candleBodyFinalY);



		function CheckOpen(e:Event):void
		{
			if (OPEN_CONTAIN.y > CLOSE_CONTAIN.y)
			{
				OPEN_CLOSE = "OPEN";
				candleBody.transform.colorTransform = new ColorTransform(1,1,1,1,1,1,1,0);


			}
			if (OPEN_CONTAIN.y < CLOSE_CONTAIN.y)
			{
				OPEN_CLOSE = "CLOSED";
				candleBody.transform.colorTransform = new ColorTransform(0,0,1,1,1,175,1,175);
			}
			Open.text = OPEN_CLOSE.toString();
		}

		function Trace(e:Event):void
		{
			trace(e.currentTarget.name + "X= " + e.currentTarget.x + " Y= " + e.currentTarget.y);

		}
		function MouseDownHandler(evt:MouseEvent):void
		{
			evt.currentTarget.startDrag();
		}
		function MouseUpHandler(evt:MouseEvent):void
		{
			evt.currentTarget.stopDrag();
		}
		function PlaceImage(_container:Sprite, _className:String, _function:Function, _stage:Stage):void
		{
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());

			_container.name = _className;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.addEventListener(MouseEvent.CLICK, _function);
			_container.scaleX = 0.1;
			_container.scaleY = 0.1;
			containerList.push(_container);
			_stage.addChild(_container);

		}
	}

}