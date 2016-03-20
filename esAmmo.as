package  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	public class esAmmo extends Sprite{
		var bitmapData:BitmapData;
		
		public function esAmmo (ESCount:int) {
			drawSprite(ESCount);
		}
		public function drawSprite (ESCount:int) {
			bitmapData = new BitmapData(60, 37,true,0);
			for (var i:int=0;i<ESCount;i++) {
				bitmapData.copyPixels(new image_ESWeapon(13,37),new Rectangle(0,0,13,37),new Point(20*i,0));
			}
			for (var j:int=i;j<3;j++) {
				bitmapData.copyPixels(new image_EmptyES(13,37),new Rectangle(0,0,13,37),new Point(20*j,0));
			}
			
			var bmp:Bitmap = new Bitmap(bitmapData);
			this.addChild(bmp);
			while (this.numChildren > 1) {
				(this.getChildAt(0) as Bitmap).bitmapData.dispose();
				this.removeChildAt(0);
			}
		}

	}
	
}
