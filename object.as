package  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class object extends Sprite {
		public var objectNumber:int; // 0=jonne, 1=anvil, 2=ES, 3=Box, 4=Log, 5=Police car , 10=ES Weapon,11=Speed arrow,12=Star,13=TNT, 14=hidden, 15=Explosion
		public var laneNumber:int;
		public var player:Boolean;
		public var drinking:Boolean=false;
		public var broken:Boolean = false;
		public var invisible:Boolean = false;
		public var spinning:int = 0;
		public var throwing:Boolean = false;
		public var wheeling:Boolean = false;
		public var empty:Boolean = true;
		public var isES:Boolean = false;
		public var isPlayed:Boolean = false;
		
		public function object(whichObjectWeWant:int, lane:int, isPlayer:Boolean) {
			laneNumber = lane;
			player = isPlayer;
			drawSprite(whichObjectWeWant,0);
			
		}
		public function drawSprite(whichObjectWeWant:int, printSpeedArrow:int) {
			objectNumber = whichObjectWeWant;
			var bitmapData:BitmapData;
			if (player==true) {
				if (drinking==true) {
					bitmapData = new BitmapData(125,96,true,0);
					bitmapData.copyPixels(new image_PlayerDrinking(),new Rectangle(0,0,124,96),new Point(0,0));
				}
				else if (throwing==true) {
					bitmapData = new BitmapData(124,96,true,0);
					bitmapData.copyPixels(new image_ESThrow(),new Rectangle(0,0,124,96),new Point(0,0));
				}
				else if(wheeling==true) {
					bitmapData = new BitmapData(128,92,true,0);
					bitmapData.copyPixels(new image_playerWheeling(),new Rectangle(0,0,128,92),new Point(0,0));
				}
				else {
					bitmapData = new BitmapData(124,96,true,0);
					bitmapData.copyPixels(new image_Player(),new Rectangle(0,0,124,96),new Point(0,0));
				}
			}
			else {
				switch (objectNumber) {
					case 0:
						if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_Jonnegang(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
							bitmapData = new BitmapData(156,94,true,0);
							bitmapData.copyPixels(new image_Jonnegang(),new Rectangle(0,0,156,94),new Point(0,0));
						}
						break;
					case 1:
					if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_ES(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
						bitmapData = new BitmapData(119,74,true,0);
						bitmapData.copyPixels(new image_Anvil(),new Rectangle(0,0,119,74),new Point(0,0));
						}
						break;
					case 2:
						if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_ES(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
							bitmapData = new BitmapData(26,74,true,0);
							bitmapData.copyPixels(new image_ES(),new Rectangle(0,0,119,74),new Point(0,0));
						}
						break;
					case 3:
						if(broken) {
							bitmapData = new BitmapData(78,78,true,0);
							bitmapData.copyPixels(new image_BoxBroken(),new Rectangle(0,0,78,78),new Point(0,0));
						}
						else {
							bitmapData = new BitmapData(78,82,true,0);
							bitmapData.copyPixels(new image_Jeccubox(),new Rectangle(0,0,78,82),new Point(0,0));
						}
						break;
					case 4:
						if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_ES(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
						bitmapData = new BitmapData(189,93,true,0);
						bitmapData.copyPixels(new image_Log(),new Rectangle(0,0,189,93),new Point(0,0));
						}
						break;
					case 5:
						bitmapData = new BitmapData(318,160,true,0);
						bitmapData.copyPixels(new image_Policecar(),new Rectangle(0,0,318,160),new Point(0,0));
						break;
					
					case 10:
						if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_ESWeapon(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
							bitmapData = new BitmapData(37,37,true,0);
							bitmapData.copyPixels(new image_ESSpin(),new Rectangle(37*spinning,0,37,37),new Point(0,0));
						}
						break;
					case 11:
						bitmapData = new BitmapData(70,21,true,0); 
						bitmapData.copyPixels(new image_Speedbonus(),new Rectangle(140-printSpeedArrow,0,70,21),new Point(0,0));
						break;
					case 12:
						if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_Jonnegang(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
							bitmapData = new BitmapData(60,60,true,0); 
							bitmapData.copyPixels(new image_Star(),new Rectangle(0,0,60,60),new Point(0,0));
						}
						break;
					case 13:
						if (invisible) {
							bitmapData = new BitmapData(1,1,true,0);
							bitmapData.copyPixels(new image_Jonnegang(),new Rectangle(0,0,1,1),new Point(0,0));
						}
						else {
							bitmapData = new BitmapData(60,60,true,0); 
							bitmapData.copyPixels(new image_TNT(),new Rectangle(0,0,60,60),new Point(0,0));
						}
						break;
					case 14:
						bitmapData = new BitmapData(1,1,true,0); 
						bitmapData.copyPixels(new image_ES(),new Rectangle(0,0,1,1),new Point(0,0));
						break;
					case 15:
						bitmapData = new BitmapData(106,103,true,0);
						bitmapData.copyPixels(new image_Boom(),new Rectangle(106*printSpeedArrow,0,106,103),new Point(0,0));
					default:
						break;
						
				}
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
