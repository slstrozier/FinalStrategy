package ControlPanel.CommonFiles.Util {
	import flash.display.MovieClip;
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.DropShadowFilter;
	import ControlPanel.CommonFiles.DoubleSlider.DoubleSlider;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.controls.Button;
	import ControlPanel.CommonFiles.Util.*;
	
	public class MessageBox extends MovieClip{
		
		private var myStage:MovieClip;
		private var myHeight:Number;
		private var isInput:Boolean;
		private var textForHeader:String;
		private var messageText:String;
		private var textInput:TextField;
		
		
		public function MessageBox(_stage:MovieClip, _headerText:String = "", _messageText:String = "No Message Entered", _height:Number = 250, _isInput:Boolean = false) {
			_stage.addChildAt(this, 0);
			this.name = "Message Box";
			myHeight = _height;
			myStage = _stage;
			isInput = _isInput;
			textForHeader = _headerText;
			messageText = _messageText;
			createBody();
			
		}
		function createBody():void{
			
			
			var fType:String = GradientType.LINEAR;
			
			var colors:Array = [ 0xBFEFFF, 0xFFFFFF];
			
			var alphas:Array = [ 1, 1 ];
			
			var ratios:Array = [ 255, 0 ];
			
			var matr:Matrix = new Matrix();
				matr.createGradientBox( 20, 20, 0, 0, 0 );
			
			var sprMethod:String = SpreadMethod.PAD;
			
			var sprite:Sprite = new Sprite();
			
			graphics.lineStyle(1, 0x000000, 1);
			graphics.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );
			graphics.drawRoundRect(0, 0, 400, myHeight, 10, 10)
			graphics.endFill();
			
			var dsFilter:DropShadowFilter = new DropShadowFilter(0,0,0,1,18.0,18.0);
			this.filters = [dsFilter]
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Calibri"
			tf.size = 15;
			var headerText:TextField = new TextField();
			headerText.defaultTextFormat = tf;
			headerText.autoSize = "left"
			headerText.text = textForHeader;
			addChild(headerText)
			
			var closeMe:MovieClip = new CloseXButton;
			addChild(closeMe);
			closeMe.x = this.width - 31
			closeMe.scaleX = 0.8;
			closeMe.scaleY = 0.8;
			closeMe.buttonMode = true;
			closeMe.addEventListener(MouseEvent.CLICK, handleClose)
			
			var okButton:Button = new Button;
			okButton.label = "OK";
			addChild(okButton)
			okButton.move(this.width - okButton.width - 15, this.height - 40)
			var cancelButton:Button = new Button;
			okButton.addEventListener(MouseEvent.CLICK, handleOK)
			cancelButton.label = "Cancel"
			if(isInput)
			{
				graphics.lineStyle(1, 0xC0C0C0, 1);
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(5, 35, this.width - 11, this.height - 175)
				graphics.endFill();
				
				textInput = new TextField();
				addChild(textInput);
				textInput.border = true;
				textInput.background = true;
				textInput.defaultTextFormat = tf;
				textInput.borderColor = 0xC0C0C0
				textInput.backgroundColor = 0xFFFFFF;
				textInput.height = 20;
				textInput.width = this.width - 10;
				textInput.type = "input"
				textInput.x = 5
				textInput.y = okButton.y - 25
			}
			else{
				graphics.lineStyle(1, 0xC0C0C0, 1);
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(5, 35, this.width - 11, this.height - 100)
				graphics.endFill();
			}
			
			var messageTextField:TextField = new TextField();
			messageTextField.defaultTextFormat = tf;
			messageTextField.text = messageText;
			addChild(messageTextField);
			messageTextField.wordWrap = true;
			messageTextField.x = 8;
			messageTextField.y = 40
			messageTextField.width = this.width - 11
			
		}
		function handleOK(event:Event):void{
			trace("OK Button Clicked")
			if(isInput){
				dispatch("OK", textInput.text);
			}
			close();
		}
		function handleClose(event:Event):void{
			close();
		}
		public function close():void{
			myStage.removeChild(this);
		}
		public function dispatch(dispatchString:String, data:*):void{
			dispatchEvent(new CustomEvent(dispatchString, data));
		}
		public function move(xLoca:Number, yLoca:Number):void{
			this.x = xLoca;
			this.y = yLoca;
		}
							 
	}
	
}
