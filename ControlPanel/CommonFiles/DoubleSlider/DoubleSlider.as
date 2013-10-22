package ControlPanel.CommonFiles.DoubleSlider{

   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.events.TouchEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   /**
    * quick example of a double slider
    * @author Devon O.
    */
   
    // Dispatches Event.CHANGE event
    [Event(name = "change", type = "flash.events.Event")]
    
   public class DoubleSlider extends MovieClip {
      
      private var _min:Number;
      private var _max:Number;
      private var _width:Number;
      private var _liveDragging:Boolean;
      private var _minRect:Rectangle = new Rectangle();
      private var _maxRect:Rectangle = new Rectangle();
      private var startDate:MovieClip;
      private var endDate:MovieClip;
      private var startText:TextField;
      private var endText:TextField;
      private var startThumb:MovieClip;
      private var endThumb:MovieClip;
      private var _track:DisplayObject;
      private var _minimumValue:Number;
      private var _maximumValue:Number;
	  private var startTextMini:TextField;
	  private var endTextMini:TextField;
	  private var dateInput:Array;
	  private var myFormat:TextFormat;
	  private var textFieldsArray:Array;
	  private var myFormatBeige:TextFormat
	  private var header_font;
      
      public function DoubleSlider(min:Number = 0, max:Number = 100, width:Number = 150, liveDragging:Boolean = false) {
         textFieldsArray = new Array;
		 _min = _minimumValue = min;
         _max = _maximumValue = max;
         _width = width;
         _liveDragging = liveDragging;
		 startDate = new MovieClip();
         endDate = new MovieClip();
		 endTextMini = new TextField();
         startTextMini = new TextField();
		 textFieldsArray.push(endTextMini, startTextMini);
		 setTextProperties();
         
         if (stage) init();
         else addEventListener(Event.ADDED_TO_STAGE, init);
      }
      private function init(event:Event = null):void {
         removeEventListener(Event.ADDED_TO_STAGE, init);
         initUI();
         initInteractivity();
		 formatTextFields()
         drawDateText();
      }
      function drawDateText():void{
                  
                  startText = new TextField();
                  with(startDate){
                        
                        graphics.beginFill(0x336600);
                        graphics.lineStyle(2, 0x000000)
                        graphics.drawRoundRect(startThumb.x - 25,startThumb.y + 10, 50, 25, 15, 15);
                        graphics.endFill();
                  }
				  startText.defaultTextFormat = myFormat;
                  startText.textColor = 0xFFFFFF;
                  startText.autoSize = "left";
                  startText.y = 9
                  startText.x = -15
                  startDate.addChild(startText);
                 // addChild(startDate);
                  endText = new TextField();
				
                  with(endDate){
                        graphics.beginFill(0x660000);
                        graphics.lineStyle(2, 0x000000)
                        graphics.drawRoundRect(endThumb.x - 25, endThumb.y - 35, 50, 25, 15, 15);
                        graphics.endFill();
                  }
				  endText.defaultTextFormat = myFormat;
                  endText.textColor = 0xFFFFF6;
                  endText.autoSize = "left";
                  endText.y = -35
                  endText.x = 626;
                  endDate.addChild(endText);
				  textFieldsArray.push(endText, startText);
                  //endDate.x -= 600;
                  //addChild(endDate);
          }
      private function initUI():void {
         _track = new Track(_width);
         addChild(_track);
         
         startThumb = new Thumb();
		 startThumb.addEventListener(Event.ENTER_FRAME, moveStartLabel)

         addChild(startThumb);
         
         endThumb = new Thumb();
         endThumb.addEventListener(Event.ENTER_FRAME, moveEndLabel)
         endThumb.x = _width;

         addChild(endThumb);
      }
	  function setTextProperties():void{
			myFormat = new TextFormat();
			//myFormat.size = 30;
			//myFormat.italic = true;
			//myFormat.bold = true;
			header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			
			myFormatBeige = new TextFormat();
			myFormatBeige.font = "Candara";
			myFormatBeige.size = 12;
			myFormatBeige.color = 0x000000;
		   // myFormatBeige.bold = true;
		}
	  public function move(xLoca:Number, yLoca:Number):void{
		  this.x = xLoca;
		  this.y = yLoca;
	  }
	  public function setNewDates(newDates:Array):void{
		  if(getChildByName("Date Rect")){
				removeChild(getChildByName("Date Rect"));
			}
		  if(getChildByName("Start Text Mini")){
				removeChild(getChildByName("Start Text Mini"));
			}
		  if(getChildByName("End Text Mini")){
				removeChild(getChildByName("End Text Mini"));
			}
		
		 dateInput = newDates;
		 var newStartX:Number = Math.round((newDates[1] - _min) * _width * (1/(_max - _min)));
		 var newEndX:Number = Math.round((newDates[0] - _min) * _width * (1/(_max - _min)));
		 var rectWidth:Number = newEndX - newStartX;
		 drawDateRect(newStartX, rectWidth);
		 
		 
		 
		 //startThumb.x = newEndX;
		// endThumb.x = newStartX
		 setValues();
	  }
	  function drawDateRect(xLoca:Number, width:Number):void{
		 var dateRect:MovieClip = new MovieClip();
		 dateRect.name = "Date Rect"; 
		 dateRect.graphics.beginFill(0x99CCFF, 1)
		 dateRect.graphics.drawRect(xLoca, -2, width, 5);
		 dateRect.graphics.endFill();
		 startTextMini.name = "Start Text Mini";
		 endTextMini.name = "End Text Mini";
		 addChildAt(dateRect, 0);
		 addChild(startTextMini);
		 addChild(endTextMini);
		 startTextMini.text = dateInput[0].toString();
		 endTextMini.text = dateInput[1].toString();
		
		 startTextMini.x = dateRect.getBounds(this).x - 15;
		 startTextMini.y = -25;
		 endTextMini.x = xLoca - 15;
		 endTextMini.y = 5;
		 
		 endTextMini.height = 25;
		 endTextMini.width = 35;

	  }
	  function formatTextFields():void{
		  for each(var tf:TextField in textFieldsArray){
			  tf.defaultTextFormat = myFormat
		  }
	  }
      function moveStartLabel(event:Event):void{
                   var thumb:MovieClip = event.currentTarget as MovieClip;
                        startText.text = _minimumValue.toString();
          }
		  
      function moveEndLabel(event:Event):void{
         var thumb:MovieClip = event.currentTarget as MovieClip;
       // endDate.x = endThumb.x - 645;  
                endText.text = _maximumValue.toString();
                ////(endDate.x - 300)
          }
      private function initInteractivity():void {     
	  startThumb.addChild(startDate);
	  endDate.x -= 645;
		 endThumb.addChild(endDate);
         startThumb.buttonMode = true;
		 startThumb.mouseChildren = false;
         startThumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);      
         endThumb.buttonMode = true;
		 endThumb.mouseChildren = false;
         endThumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
		 
      }
   
      private function thumbDownHandler(event:MouseEvent):void {
         stage.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag);
         stage.addEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
         setRectangles();
         
         var thumb:MovieClip = event.currentTarget as MovieClip;
         if (thumb == startThumb) {
            thumb.startDrag(false, _minRect);
                        //startDate.x = thumb.x;
         } else {
            thumb.startDrag(false, _maxRect);
         }
      }
      
      private function dragHandler(event:MouseEvent):void {
         setValues();
         if (_liveDragging) dispatchEvent(new Event(Event.CHANGE));
         event.updateAfterEvent();
      }
      
      private function stopThumbDrag(event:MouseEvent):void {
         stage.removeEventListener(MouseEvent.MOUSE_UP, stopThumbDrag);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
         startThumb.stopDrag();
         endThumb.stopDrag();
         if (!_liveDragging) dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function setRectangles():void {
         _minRect.width = endThumb.x - (endThumb.width - 45);
         _maxRect.x = startThumb.x + (startThumb.width - 45);
         _maxRect.width = _width - _maxRect.x;
                 
      }
      
      private function setValues():void {
		
         _minimumValue = Math.round((startThumb.x / _width * (_max - _min)) + _min);
         _maximumValue = Math.round((endThumb.x / _width * (_max - _min)) + _min);

      }
      public function get minimumValue():Number { return _minimumValue; }
      
      public function get maximumValue():Number { return _maximumValue; }
   }
}