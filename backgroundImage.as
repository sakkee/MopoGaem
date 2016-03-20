package  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	public class backgroundImage extends Sprite {
		var bitmapData:BitmapData;
		public function backgroundImage(choice:int) { //0=background image, 1=road lines
			drawSprite(0, choice);
		}
		public function drawSprite (pixelCount:int, choice:int) {
			switch (choice) {
				case 0:
					bitmapData = new BitmapData(1280, 336,true,0);
					bitmapData.copyPixels(new image_Background(),new Rectangle(pixelCount,0,1280,336),new Point(0,0));
					break;
				case 1:
					bitmapData = new BitmapData(1280, 15,true,0);
					bitmapData.copyPixels(new image_Line(),new Rectangle(pixelCount,0,1280,15),new Point(0,0));
					break;
				
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
