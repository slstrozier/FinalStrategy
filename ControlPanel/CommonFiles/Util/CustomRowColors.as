package ControlPanel.CommonFiles.Util{
    import fl.controls.listClasses.CellRenderer;
    import fl.controls.listClasses.ICellRenderer;

    public class CustomRowColors extends CellRenderer implements ICellRenderer {

        public function CustomRowColors():void {
            super();
        }

        public static function getStyleDefinition():Object {
            return CellRenderer.getStyleDefinition();
        }

        override protected function drawBackground():void {
            switch (data.rowColor) {
                case "green" :
                    setStyle("upSkin", CellRenderer_upSkinGreen);
                    break;
                case "red" :
                    setStyle("upSkin", CellRenderer_upSkinRed);
                    break;
				case "yellow" :
                    setStyle("upSkin", CellRenderer_upSkinYellow);
                    break;
                case "orange" :
                    setStyle("upSkin", CellRenderer_upSkinOrange);
                    break;
				 case "purple" :
                    setStyle("upSkin", CellRenderer_upSkinPurple);
                    break;
                
				default :
                    break;
            }
            super.drawBackground();
        }
    }
}
