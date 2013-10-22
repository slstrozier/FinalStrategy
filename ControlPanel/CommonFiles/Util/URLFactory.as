package ControlPanel.CommonFiles.Util
{
	//import ST_Files.CustomEvent
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.Security;
    import flash.system.SecurityPanel;
	//import flash.sampler.Sample;

	public class URLFactory extends MovieClip
	{

		public var loader:URLLoader;
		public var textData:Object;
		public var dataArray:Array;
		public var url:String;
		private var DISPATCHSTRING:String;
		

		/**
		  Constructor. At creation, sets loader and gives it an eventListener
		@param url The address for the url request
		  */
		public function URLFactory(url:String)
		{       
			Security.allowDomain("*");//http://backend.chickenkiller.com:8080/sample/crossdomain.xml
			Security.loadPolicyFile("http://backend.chickenkiller.com:8080/sample/crossdomain.xml");

			this.url = url;
			var rand:String = "&"+(Math.random()*100000000).toString();
			try{
					loader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, HandleComplete);
					loader.load(new URLRequest(url + rand));
					
				}
			catch(error:Error){
			trace("Error");
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, HandleComplete);
			loader.load(new URLRequest("C:/Users/Programmer2/Desktop/Adobe Photoshop CS5.1/FINALSTRATEGY/TestFiles/AllData.txt"));
			}
		}
		/**
		  EventListner. Sets the textData to the data of the URLLoader and calls SetData() to store
		the date into the variable
		  */
		function HandleComplete(e:Event):void
		{
			textData = loader.data;
			//trace(textData);
			dispatchEvent(new CustomEvent(CustomEvent.QUERYREADY, textData));
			//dispatchEvent(new Event("dataReadyE"));
		}

		

	}
}