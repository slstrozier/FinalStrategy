package ControlPanel.CommonFiles.Util
{
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class alterCellRenderer extends CellRenderer
	{
		private var tf:TextFormat;

		public function alterCellRenderer()
		{
			trace("here is the renderer")
		}

		override protected function drawBackground():void
		{
			setStyle("upSkin", CellRenderer_upSkin);
			if (_listData.index % 2 == 0)
			{
				setStyle("upSkin", CellRenderer_upSkin2);
			}
			super.drawBackground();
		}

	}
}