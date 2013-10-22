package ControlPanel.Login{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.*;
	import flash.display.*;
	import fl.motion.DynamicMatrix;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import fl.controls.Button;
	import flash.events.*;
	import ControlPanel.CommonFiles.Util.*
	
	public class LoginIn extends MovieClip{
		private var myStage:MovieClip;
		private var xPosition:Number;
		private var yPosition:Number;
		private var myBackground:MovieClip;
		private var userName:TextField;
		private var password:TextField;
		private var myFormat:TextFormat;
		private var label_font;
		private var user_passText:TextField;
		
		public function LoginIn(stage:MovieClip, _xLoca:Number, _yLoca:Number) {
			myStage = stage;
			init();
			//this.x = _xLoca;
			//this.y = _yLoca;
			this.name = "Log In";
			addEventListener("LoginSuccesful", destroyMe);
			
		
		}
		function init():void{
			setTextProperties();
			myStage.addChild(this);
			drawBackground();
			drawForeground();
		}
		function drawBackground():void{
			myBackground = new MovieClip;
			myBackground.graphics.lineStyle(1, 0x6D7B8D);
			//Type of Gradient we will be using
			var fType:String = GradientType.LINEAR;
			//Colors of our gradient in the form of an array
			var colors:Array = [0x000000, 0xFFFFFF];
			//Store the Alpha Values in the form of an array
			var alphas:Array = [0.8, 0.8];
			//Array of color distribution ratios.  
			//The value defines percentage of the width where the color is sampled at 100%
			var ratios:Array = [200, 255];
			//Create a Matrix instance and assign the Gradient Box
			var matr:Matrix = new Matrix();
				matr.createGradientBox( this.x, this.y, Math.PI/2, 0, 50 );
			//SpreadMethod will define how the gradient is spread. Note!!! Flash uses CONSTANTS to represent String literals
			var sprMethod:String = SpreadMethod.PAD;
			//Save typing + increase performance through local reference to a Graphics object
			var g:Graphics = myBackground.graphics;
				g.beginGradientFill(fType, colors, alphas, ratios, matr, sprMethod );
				g.drawRect(this.x, this.y, 450, 250);
			
			
			myStage.addChild(myBackground);
			
		}
		function drawForeground():void{
			userName = createCustomTextField(0,0,150,20);
			password = createCustomTextField(0,0,150,20);
			password.displayAsPassword = true;
			
			var userNameClip:MovieClip = new MovieClip();
			var passwordClip:MovieClip = new MovieClip();
			userNameClip.addChild(userName);
			passwordClip.addChild(password);
			addToBackground(userNameClip, 150, 70)
			addToBackground(passwordClip, 150, 150)
			
			var userNameLabel:TextField = new TextField;
			var passLabel:TextField = new TextField;
			userNameLabel.defaultTextFormat = myFormat;
			userNameLabel.text = "Username:";
			userNameLabel.textColor = 0xFFFFFF
			passLabel.defaultTextFormat = myFormat;
			passLabel.text = "Password:";
			passLabel.textColor = 0xFFFFFF
			
			
			var passLabelMC:MovieClip = new MovieClip;
			var userNameLabelMC:MovieClip = new MovieClip;
			passLabelMC.addChild(passLabel);
			userNameLabelMC.addChild(userNameLabel);
			addToBackground(userNameLabelMC, 50, 70)
			addToBackground(passLabelMC, 50, 150)
			
			var butText:Button = new Button();
			butText = new Button();
			butText.label = "Login"
			butText.setSize(75, 25)
			butText.emphasized = true;
			//butText.setStyle("icon", BulletCheck);
			butText.move(180, 200)
			butText.addEventListener(MouseEvent.CLICK, handlePassword);
			myBackground.addChild(butText);
			
			user_passText = new TextField;
			user_passText.textColor = 0xFFFFFF;
			user_passText.autoSize = "left";
			user_passText.defaultTextFormat = myFormat;
			user_passText.text = "Please enter your username and password to login."
			var user_passTextMC:MovieClip = new MovieClip();
			user_passTextMC.addChild(user_passText);
			addToBackground(user_passTextMC, 80, 15)
			user_passText.x = 80;
		 	user_passText.y = 15;
			this.myBackground.addChild(user_passText);
			
		}
		function handlePassword(event:Event):void{
			var loginSuccess:Boolean;
			var un:String = userName.text;
			var ps:String = password.text;

			var urlLoader:URLFactory = new URLFactory("http://backend.chickenkiller.com:8080/sample/login?un=" + un + "&pw=" + ps)

			

			urlLoader.addEventListener(CustomEvent.QUERYREADY, credentialHandler)
			function credentialHandler(event:CustomEvent){
				//trace(event.data)
				var loginSuccess:String = event.data;
				//trace(loginSuccess)
				if(loginSuccess == "true")
				{
					trace(un + " logged in successfully");
					user_passText.text = "Login Complete";
					dispatchEvent(new CustomEvent("LoginSuccesful", un))
				}
				else
				{
					user_passText.autoSize = "center";
					user_passText.text = "Username or password incorrect";
				}
			}
			
		}
		function addToBackground(mc:MovieClip, xLoca:Number, yLoca:Number){
			this.myBackground.addChild(mc);
			mc.x = xLoca;
			mc.y = yLoca;
		}
		
		private function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
            var result:TextField = new TextField();
            result.x = x;
            result.y = y;
            result.width = width;
            result.height = height;
			result.background = true;
			result.defaultTextFormat = myFormat;
			result.backgroundColor = 0xFFFFFF;
			result.type = TextFieldType.INPUT;
            addChild(result);
            return result;
        }
		
		function setTextProperties():void{
			myFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.italic = true;
			label_font = new Candara;
			myFormat.size = 15;
			myFormat.font = label_font.fontName;
		}
		function destroyMe(event:Event){
			destroySelf();
		}
		public function destroySelf():void{
			this.y = 5000;
			myStage.removeChild(this.myBackground);
		}
	}
	
}
