package ControlPanel.CommonFiles.Util
{
	import flash.text.TextLineMetrics;

	import fl.controls.CheckBox;

	public class MultilineCheckbox extends CheckBox
	{
		public var myLineMetric:TextLineMetrics;

		public function MultilineCheckbox()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();

			textField.multiline = true;
			textField.wordWrap = true;
			textField.width = this.explicitWidth - 20;
		}

		override protected function measure():void
		{

			if (! isNaN(explicitWidth))
			{
				var w:Number = explicitWidth;
				w -=  getStyle("horizontalGap") + getStyle("paddingLeft") + getStyle("paddingRight");
				textField.width = w;
				textField.y = 0;
			}

			if (this.myLineMetric == null)
			{
				super.measure();
			}
			this.height = myLineMetric.height + 4;
		}

		override public function measureText(s:String):TextLineMetrics
		{
			textField.text = s;
			var lineMetrics:TextLineMetrics = textField.getLineMetrics(0);
			lineMetrics.width = textField.textWidth;
			lineMetrics.height = textField.textHeight;

			if (this.myLineMetric == null)
			{
				this.myLineMetric = lineMetrics;
			}
			this.height = myLineMetric.height + 4;
			return this.myLineMetric;
		}
	}
}