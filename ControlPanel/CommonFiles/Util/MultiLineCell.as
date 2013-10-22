package ControlPanel.CommonFiles.Util
{

	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class MultiLineCell extends CellRenderer
	{

		public function MultiLineCell()
		{
			textField.wordWrap = true;
			textField.autoSize = "left";
			textField.restrict = "0-9"
		}
		override protected function drawLayout():void
		{
			textField.width = this.width;
			super.drawLayout();
		}
				
	}
}