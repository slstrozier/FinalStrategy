package ControlPanel.Signals{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.filters.BitmapFilterQuality; 
	import flash.filters.* 
	import flash.display.*;
	import flash.events.*;
	import flash.text.*
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import ControlPanel.CommonFiles.Util.*

	public class SingleSignal extends MovieClip{

		private var myStage:MovieClip
		private var on_offMC:MovieClip;
		private var buttonData:Array;
		private var user:String;
		private var textDescription:TextField;
		private var dropShawdow:DropShadowFilter;
		public var signalButton:MovieClip;
			
		
		public function SingleSignal(stage:MovieClip, user:String, data:Array) {
			
			myStage = stage;
			this.user = user;
			myStage.addChild(this);
			textDescription = new TextField();
			buttonData = data;
			setSignal();
		}
		function setSignal():void{
			var textButton:TextButton = new TextButton();
			textButton.scaleX = 1.6;
			textButton.scaleY = 1.2;
			
			var newColorTransform:ColorTransform = textButton.buttonBackground.transform.colorTransform;
			newColorTransform.color = 0x336699;
			textButton.buttonBackground.transform.colorTransform = newColorTransform;
			
			textButton.ButtonData = this.buttonData;
			textButton.buttonText.text = textButton.ButtonData[0].Name
			textButton.DeleteClip = deleteButton(textButton);
			textButton.DeleteClip.y -= 15
			textButton.DeleteClip.x += 55;
			addChild(textButton.DeleteClip)
			setOnOff(80, 13);
			toggleOnOff(textButton.ButtonData[0].SignalOnOff);
			textButton.mouseChildren = false;
			textButton.buttonMode = true;
			textButton.addEventListener(MouseEvent.CLICK, handleButtonClick);
			textButton.addEventListener(MouseEvent.MOUSE_OVER, description);
			textButton.addEventListener(MouseEvent.MOUSE_OUT, removeDescription);
			signalButton = textButton;
			addChild(signalButton);
			setDropShadow(signalButton);
		}
		function handleButtonClick(event:Event):void{
			var mcButton:MovieClip = event.target as MovieClip;
			
			var signalXML:XML = new XML(mcButton.ButtonData[0].SignalDataXML)
			dispatch("LoadSignalBuilder", signalXML)
			
		}
		function setDropShadow(obj:DisplayObject):void{
			
			dropShawdow = new DropShadowFilter()
			obj.filters = [dropShawdow]
			
		}
		function description(event:Event):void
		{
			var mc:MovieClip = event.target as MovieClip;
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = "arial";
			textDescription.defaultTextFormat = myFormat;
			textDescription.x = mouseX + 500;
			textDescription.y = mouseY + 45;
			textDescription.height = 20;
			textDescription.autoSize = "left";
			textDescription.text = mc.ButtonData[0].Label;
			textDescription.background = true;
			textDescription.alpha = 0;
			var tween:Tween = new Tween(textDescription,
			                       "alpha",None.easeNone,0,1,0.5,true);

			textDescription.border = true;
			myStage.addChildAt(textDescription, 0);
			//this.myStage.setChildIndex(textDescription, numChildren - 1);

		}
		
		function removeDescription(e:Event):void
		{
			myStage.removeChild(textDescription);
		}
		function setOnOff(xLoca:Number = 0, yLoca:Number = 0):void{
			on_offMC = new MovieClip();
			var glow:GlowFilter = new GlowFilter(); 
			with (glow){
				color = 0x009922; 
				alpha = 1; 
				blurX = 25; 
				blurY = 25; 
				quality = BitmapFilterQuality.MEDIUM; 
			}
			with (on_offMC){
			graphics.beginFill(0xff0000);
			graphics.drawCircle(xLoca, yLoca, 5);
			graphics.endFill();
			filters = [glow]
			}
			addChild(on_offMC);
		}
		function toggleOnOff(isOn:String):void{
			
			var colorArray:Array = new Array(0x33EE11/*green*/, 0x990011/*red*/);
			var newColorTransform:ColorTransform = on_offMC.transform.colorTransform;
			if(isOn == "true")
			{
				
				newColorTransform.color = colorArray[0];
				on_offMC.transform.colorTransform = newColorTransform;
			}
			if(isOn == "false")
			{
				
				newColorTransform.color =  colorArray[1];
				on_offMC.transform.colorTransform = newColorTransform;
			}
		}
		
		function deleteButton(mc:MovieClip):MovieClip{
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.italic = true
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			var textF:TextField = new TextField()
			textF.defaultTextFormat = myFormat
			textF.text = "x";
			//textF.y = 40;
			//textF.x = 33;
			var db:MovieClip = new MovieClip();
			db.buttonMode = true;
			db.mouseChildren = false;
			db.addChild(textF);
			db.DeleteButton = mc;
			db.width = 6;
			db.addEventListener(MouseEvent.CLICK, deleteMCButton);
			return db;
		}
		
		function deleteMCButton(event:Event):void{
			var mc:MovieClip = event.target as MovieClip;
			requestDelete(mc.DeleteButton)
		}
		function requestDelete(mc:MovieClip):void{
			var deleteString:String = mc.ButtonData[0].Name;
			
			var urlFactory:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/buttontasks?USER=" + this.user + "&TASK=delete&WHAT=signal&NAME=" + deleteString)
			urlFactory.addEventListener(CustomEvent.QUERYREADY, handleButtonDeleted)
			
		}
		function handleButtonDeleted(event:Event):void{
			dispatch("UserSignalDeleted");
			
		}
		
		function dispatch(dispatchString:String, data:String = ""):void{
			dispatchEvent(new CustomEvent(dispatchString, data));
		}
		
		
		

	}
	
}
