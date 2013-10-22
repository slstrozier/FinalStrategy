package ControlPanel.CommonFiles.Util
{

	import fl.controls.TextInput;
	import flash.events.*
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.ICellRenderer;
	

	public class LoaderCellRenderer extends TextInput implements ICellRenderer
	{
		protected var _data:Object;
		protected var _listData:ListData;
		protected var _selected:Boolean;
		public static var numData:String;
		public static var _stage;

		
		public var damn:String = "Damn";

		public function LoaderCellRenderer()
		{
			super();
			numData = new String("String")
			restrict = "0-9";
			addEventListener(Event.CHANGE, textChange);
		}

		public function textChange(Event):void
		{
			numData = text;
			trace(text);
		}
	    public function dispatch(_dispatch:String):void{
			this.dispatchEvent(new Event(_dispatch))
		}
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
			
			//text = value.ID;
		}
		public static function retrieveData():String{
			return numData;
		}
		public function get listData():ListData
		{
			return _listData;
		}

		public function set listData(value:ListData):void
		{
			_listData = value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

		public function setMouseState(state:String):void
		{
		}

	}
}