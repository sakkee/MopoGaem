package  {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flashx.textLayout.utils.CharacterUtil;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.display.Bitmap;
	import flash.net.SharedObject;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flashx.textLayout.formats.BackgroundColor;
	
	public class MopoGaem extends MovieClip {
		var keyUP:int = Keyboard.UP;
		var keyDOWN:int =Keyboard.DOWN;
		var keySPACE:int = Keyboard.SPACE;
		var keysPressedARRAY:Array = new Array();
		var keysNotReadyARRAY:Array = new Array();
		
		var alltimebestscore:int;
		var score:int;
		
		var ESinStorage;
		var tipText:TextField = new TextField();
		var theScoreText:TextField = new TextField();
		var bestScoreText:TextField = new TextField();
		var objectSpeed:Number;
		var explodedYet:Boolean;
		var loseControl:Boolean;
		var drawDown:Boolean;
		var drawUp:Boolean;
		var logjump:Boolean;
		var gameoverComing:Boolean;
		var isplaying:Boolean = false;
		var mcContainer:MovieClip = new MovieClip();
		var gameLayer:Sprite = new Sprite();
		var backgroundLayer:Sprite = new Sprite();
		var roadLayer1:Sprite = new Sprite();
		var roadLayer2:Sprite = new Sprite();
		var roadLayer3:Sprite = new Sprite();
		var roadLayer4:Sprite = new Sprite();
		var uiLayer:Sprite = new Sprite();
		var gameoverLayer:Sprite = new Sprite();
		var gameoverRectangle:Shape = new Shape; 
		
		var SaveGame:SharedObject =	SharedObject.getLocal("FGLGame");
		
		var specialSound:Sound;
		var specialChannel:SoundChannel = new SoundChannel();
		var musicChannel:SoundChannel = new SoundChannel();
		var musicSound:Sound = new backgroundMusic;
		var playerJumpSpeed:int;
		var roadLineChange:int;
		var specialeffectROSTER:Array = new Array();
		var effectROSTER:Array = new Array();
		var weaponROSTER:Array = new Array();
		var objectROSTER:Array = new Array();
		var FrameRate:int = 30;
		var gameoverTimer:Timer = new Timer(1000/FrameRate,0);
		var esTimer:Timer = new Timer(1000,0);
		var esThrowingTimer:Timer = new Timer(250,0);
		var explosionTimer:Timer = new Timer(50,0);
		var timer:Timer = new Timer(3000,0);
		var tipTimer:Timer = new Timer(5000,1);
		var laneCount:int = 4;
		var roundNumber:int;
		var bgInt:int;
		var lineInt:int;
		var arrowInt:int;
		var gameTick:Timer = new Timer(1000/FrameRate, 0);
		var gamePause:Timer = new Timer(1000/FrameRate,0);
		var player:object;
		
		var backgroundImg:backgroundImage;
		var roadlinesImg:backgroundImage;
		var esImg:esAmmo;
		
		public function MopoGaem() {
			
		
		stage.addEventListener(KeyboardEvent.KEY_UP,areKeysUP); 
		stage.addEventListener(KeyboardEvent.KEY_DOWN, areKeysDOWN);
		gameStart();
		function saveGame():void {
			SaveGame.data.score = alltimebestscore;
		}
		function clearLayers():void {
			specialeffectROSTER.length=0;
			effectROSTER.length=0;
			weaponROSTER.length=0;
			objectROSTER.length=0;
			clearEverything(roadLayer1);
			clearEverything(roadLayer2);
			clearEverything(roadLayer3);
			clearEverything(roadLayer4);
			clearEverything(uiLayer);
			clearEverything(backgroundLayer);
			clearEverything(gameLayer);
			clearEverything(gameoverLayer);
		}
		function clearEverything(i:DisplayObjectContainer):void{
			while (i.numChildren) {
				try{
					(i.getChildAt(0) as Bitmap).bitmapData.dispose();
				}catch(e){}
				i.removeChildAt(0);
			}
			System.gc();
		}
		function gameStart():void {
			clearLayers();
			loadGame();
			gameTick.addEventListener(TimerEvent.TIMER, world_tick);
			scoreUpload();
			showTips();
			hideEdges();
			if (isplaying==false){
				musicChannel = musicSound.play();
				musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
				isplaying = true;
			}
			
			gameTick.start();
		}
		function loopMusic(e:Event):void{
			musicChannel = musicSound.play();
			musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
					
		}
		function loadGame():void {
			ESinStorage=3;
			score=0;
			alltimebestscore=SaveGame.data.score;
			objectSpeed=15;
			loseControl = false;
			drawDown = false;
			drawUp = false;
			logjump = false;
			gameoverComing = false;
			explodedYet=false;
			
			mcContainer.addChild(backgroundLayer);
			mcContainer.addChild(gameLayer);
			mcContainer.addChild(gameoverLayer);
			addChild(mcContainer);
			gameLayer.addChild(backgroundLayer);
			gameLayer.addChild(roadLayer1);
			gameLayer.addChild(roadLayer2);
			gameLayer.addChild(roadLayer3);
			gameLayer.addChild(roadLayer4);
			gameLayer.addChild(uiLayer);
			
			roadLayer1.y = 380;
			roadLayer2.y = 500;
			roadLayer3.y = 600;
			roadLayer4.y =700;
			
			playerJumpSpeed=0;
			roadLineChange = 0;
			roundNumber = 1;
			
			bgInt = 0;
			lineInt = 0;
			arrowInt = 0;
			
			player = new object(0,2,true);
			player.x=200;
			player.y-=player.height;
			
			backgroundImg = new backgroundImage(0);
			roadlinesImg = new backgroundImage(1);
			esImg = new esAmmo(ESinStorage);
			uiLayer.addChild(esImg);
			esImg.x=player.x+player.width/8;
			esImg.y=500-player.height*1.5;
			backgroundLayer.addChild(backgroundImg);
			roadlinesImg.y=520;
			backgroundLayer.addChild(roadlinesImg);
			roadLayer2.addChild(player);
			
		}
		function hideEdges():void {
			var rectangle:Shape = new Shape; 
			rectangle.graphics.beginFill(0x000000); 
			rectangle.graphics.drawRect(-318, 0, 318,720); 
			rectangle.graphics.endFill(); 
			uiLayer.addChild(rectangle); 
			rectangle.graphics.beginFill(0x000000); 
			rectangle.graphics.drawRect(1280, 0, 318,720);
			rectangle.graphics.endFill(); 
			uiLayer.addChild(rectangle); 
		}
		function world_tick(event:TimerEvent):void {
			roadlinesImg.drawSprite(lineInt,1);
			backgroundImg.drawSprite(bgInt,0);
			if (keysPressedARRAY["" + keyDOWN] && !keysNotReadyARRAY["" + keyDOWN]&&drawDown==false&&drawUp==false&&loseControl==false) {
				keysNotReadyARRAY["" + keyDOWN] = true;
				if (player.laneNumber < 4 ) {
					drawDown = true;
					if (player.laneNumber==1) roadLineChange=120;
					else roadLineChange=100;
					player.laneNumber++;
				}
			}
			else if (keysPressedARRAY["" + keyUP] && !keysNotReadyARRAY["" + keyUP]&&drawUp==false&&drawDown==false&&loseControl==false) {
				keysNotReadyARRAY["" + keyUP] = true;
				if (player.laneNumber > 1) {
					drawUp=true;
					if (player.laneNumber==2) roadLineChange=120;
					else roadLineChange=120;
					player.laneNumber--;
				}
			}
			else if (keysPressedARRAY["" + keySPACE] && !keysNotReadyARRAY[""+keySPACE]&&loseControl==false&&player.throwing==false&&ESinStorage>0) {
				keysNotReadyARRAY[""+keySPACE] = true;
				shootObject();
			}
			if (drawDown==true) {
				switch(player.laneNumber) {
					case 2:
						if (roadLineChange>20) {
							player.y+=20;
							esImg.y+=20;
							roadLineChange-=20;
						}
						else  {
							player.y=-player.height;
							roadLayer1.removeChild(player);
							roadLayer2.addChild(player);
							esImg.y=500-135;
							drawDown=false;
						}
						break;
					case 3:
						if (roadLineChange>20) {
							player.y+=20;
							esImg.y+=20;
							roadLineChange-=20;
						}
						else  {
							player.y=-player.height;
							roadLayer2.removeChild(player);
							roadLayer3.addChild(player);
							esImg.y=600-135;
							drawDown=false;
						}
						break;
					case 4:
						if (roadLineChange>20) {
							player.y+=20;
							esImg.y+=20;
							roadLineChange-=20;
						}
						else  {
							player.y=-player.height;
							roadLayer3.removeChild(player);
							roadLayer4.addChild(player);
							esImg.y=700-135;
							drawDown=false;
						}
						break;
				}
			}
			else if (drawUp==true) {
				switch(player.laneNumber) {
					case 1:
						if (roadLineChange>20) {
							player.y-=20;
							esImg.y-=20;
							roadLineChange-=20;
						}
						else  {
							player.y=-player.height;
							roadLayer2.removeChild(player);
							roadLayer1.addChild(player);
							esImg.y=380-135;
							drawUp=false;
						}
						break;
					case 2:
						if (roadLineChange>20) {
							player.y-=20;
							esImg.y-=20;
							roadLineChange-=20;
						}
						else  {
							player.y=-player.height;
							roadLayer3.removeChild(player);
							roadLayer2.addChild(player);
							esImg.y=500-135;
							drawUp=false;
						}
						break;
					case 3:
						if (roadLineChange>20) {
							player.y-=20;
							esImg.y-=20;
							roadLineChange-=20;
						}
						else  {
							player.y=-player.height;
							roadLayer4.removeChild(player);
							roadLayer3.addChild(player);
							esImg.y=600-135;
							drawUp=false;
						}
						break;
				}
			}
			bgInt+=objectSpeed*(3/4);
			lineInt+=objectSpeed;
			arrowInt+=10;
			if (bgInt>3295) bgInt-=3295;
			if (lineInt>241) lineInt-=241;
			if (arrowInt>=140) arrowInt-=140;
			if(objectSpeed>15) objectSpeed--;
			for each(var effectX:object in effectROSTER) {
				effectX.x -= objectSpeed;
				if(effectX.objectNumber==11) effectX.drawSprite(11,arrowInt);
				if (player.laneNumber == effectX.laneNumber && effectX.x<=player.x+player.width && effectX.x+effectX.width>= player.x) {
					if(effectX.objectNumber==11&&objectSpeed<60) {
						objectSpeed=70;
						specialSound = new turboBoost;
						specialChannel = specialSound.play();
					}
					else if(effectX.objectNumber==12&&effectX.invisible==false) {
						score+=500;
						effectX.invisible=true;
						effectX.drawSprite(12,0);
						theScoreText.text = "SCORE: " + score;
						specialSound = new Star;
						specialChannel = specialSound.play();
					}
					else if(effectX.objectNumber==13&&gameoverComing==false) {
						specialSound = new Bomb;
						specialChannel = specialSound.play();
						effectX.invisible=true;
						effectX.drawSprite(13,0);
						createBoom();
						gameoverComing=true;
						loseControl=true;
					}
					
				}
				
				else if (effectROSTER[0].x<-effectROSTER[0].width) {
					try {while(effectROSTER[0].x<-effectROSTER[0].width) {
						switch (effectROSTER[0].laneNumber) {
							case 1:
								roadLayer1.removeChild(effectROSTER[0]);
								break;
							case 2:
								roadLayer2.removeChild(effectROSTER[0]);
								break;
							case 3:
								roadLayer3.removeChild(effectROSTER[0]);
								break;
							case 4:
								roadLayer4.removeChild(effectROSTER[0]);
								break;
						}
						effectROSTER.shift();
						try {effectROSTER[0].x-=objectSpeed;}catch(e){};
					}}catch(e){};
					
				}
				
				
			}
			for each (var specX:object in specialeffectROSTER) {
				specX.x-=objectSpeed;
				if (explodedYet) specX.drawSprite(15,1);
				
				if (specialeffectROSTER[0].x<-specialeffectROSTER[0].width) {
					try {while(specialeffectROSTER[0].x<-specialeffectROSTER[0].width) {
						switch (specialeffectROSTER[0].laneNumber) {
							case 1:
								roadLayer1.removeChild(specialeffectROSTER[0]);
								break;
							case 2:
								roadLayer2.removeChild(specialeffectROSTER[0]);
								break;
							case 3:
								roadLayer3.removeChild(specialeffectROSTER[0]);
								break;
							case 4:
								roadLayer4.removeChild(specialeffectROSTER[0]);
								break;
						}
						specialeffectROSTER.shift();
						try {specialeffectROSTER[0].x-=objectSpeed;}catch(e){};
					}}catch(e){};
				}
				
			}
			for each (var bulletX:object in weaponROSTER) {
				if(bulletX.spinning<3)bulletX.spinning++;
				else bulletX.spinning=0;
				bulletX.drawSprite(10,0);
				bulletX.x+=objectSpeed*4;
				for each(var objectX2:object in objectROSTER) {
					if (bulletX.laneNumber == objectX2.laneNumber && objectX2.x<=bulletX.x+bulletX.width && objectX2.x+objectX2.width>= bulletX.x) {
						if(objectX2.objectNumber==0&&bulletX.invisible==false&&objectX2.invisible==false) {
							specialSound = new angryJonne;
							specialChannel = specialSound.play();
							bulletX.invisible = true;
							bulletX.drawSprite(bulletX.objectNumber,0);
							objectX2.invisible=true;
							objectX2.drawSprite(objectX2.objectNumber,0);
							score+=100;
						}
						else if(objectX2.objectNumber==1&&bulletX.invisible==false&&objectX2.invisible==false) {
							specialSound = new breakBoxbythrow;
							specialChannel = specialSound.play();
							bulletX.invisible = true;
							bulletX.drawSprite(bulletX.objectNumber,0);
							objectX2.invisible=true;
							objectX2.drawSprite(objectX2.objectNumber,0);
							score+=10;
						}
						else if(objectX2.objectNumber==4&&bulletX.invisible==false&&objectX2.invisible==false) {
							specialSound = new breakBoxbythrow;
							specialChannel = specialSound.play();
							bulletX.invisible = true;
							bulletX.drawSprite(bulletX.objectNumber,0);
							objectX2.invisible=true;
							objectX2.drawSprite(objectX2.objectNumber,0);
							score+=10;
						}
						else if (objectX2.objectNumber==3&&bulletX.invisible==false&&objectX2.broken==false) {
							specialSound = new breakBoxbythrow;
							specialChannel = specialSound.play();
							bulletX.invisible = true;
							bulletX.drawSprite(bulletX.objectNumber,0);
							objectX2.broken = true;
							objectX2.drawSprite(objectX2.objectNumber,0);
							score+=25;
						}
						
						else if (objectX2.broken!=true&&objectX2.invisible!=true) {
							bulletX.invisible = true;
							bulletX.drawSprite(bulletX.objectNumber,0);
						}
						
			theScoreText.text = "SCORE: " + score;
						
					}
				}
				if(bulletX.x>1280) {
					switch (weaponROSTER[0].laneNumber) {
						case 1:
							roadLayer1.removeChild(weaponROSTER[0]);
							break;
						case 2:
							roadLayer2.removeChild(weaponROSTER[0]);
							break;
						case 3:
							roadLayer3.removeChild(weaponROSTER[0]);
							break;
						case 4:
							roadLayer4.removeChild(weaponROSTER[0]);
							break;
						}
						weaponROSTER.shift();
				}
			}
			for each(var objectX:object in objectROSTER) {
				objectX.x -= objectSpeed;
				if(objectX.objectNumber==5)objectX.x-=objectSpeed;
				if (player.laneNumber == objectX.laneNumber && objectX.x<=player.x+player.width && objectX.x+objectX.width>= player.x) {
					
					if (objectX.objectNumber == 2&&objectX.invisible==false) {
						if (ESinStorage<3){
							ESinStorage++;
							esImg.drawSprite(ESinStorage);
						}
						specialSound = new drinkSound;
						specialChannel = specialSound.play();
						objectX.invisible = true;
						objectX.drawSprite(objectX.objectNumber,0);
						player.drinking = true;
						esTimer.addEventListener(TimerEvent.TIMER, stopDrinking);
						esTimer.start();
						player.drawSprite(0,0);
						score+=40;
						theScoreText.text = "SCORE: " + score;
					}
					else if (objectX.objectNumber==3&&objectX.broken==false) {
						specialSound = new driveoverbox;
						specialChannel = specialSound.play();
						objectX.broken = true;
						objectX.drawSprite(objectX.objectNumber,0);
					}
					else if (objectX.objectNumber==1&&objectX.invisible==false&&gameoverComing==false) {
						specialSound = new Crash;
						specialChannel = specialSound.play();
						gameoverComing=true;
						loseControl=true;
					}
					else if (objectX.objectNumber==4 &&logjump==false&&objectX.invisible==false) {
						loseControl=true;
						logjump=true;
						specialSound = new Jump;
						specialChannel = specialSound.play();
						score+=50;
						player.wheeling=true;
						player.drawSprite(0,0);
						playerJumpSpeed=10;
						theScoreText.text = "SCORE: " + score;
					}
					else if(objectX.objectNumber==0 && objectX.invisible==false&&gameoverComing==false) {
						gameoverComing=true;
						loseControl=true;
						specialSound = new Crash;
						specialChannel = specialSound.play();
					}
					else if(objectX.objectNumber==5&&gameoverComing==false) {
						gameoverComing=true;
						loseControl=true;
						specialSound = new Crash;
						specialChannel = specialSound.play();
						}
					else if(objectX.objectNumber==5&&gameoverComing==true) {
						player.x=objectX.x-player.width;
						esImg.x-=objectSpeed;
					}
				}
				else if (objectX.objectNumber==5) {
					for each(var objectX3:object in objectROSTER) {
						if (objectX3.laneNumber == objectX.laneNumber && objectX.x<=objectX3.x+objectX3.width && objectX.x+objectX.width>= objectX3.x&&objectX3.objectNumber!=5) {
							if(objectX3.objectNumber==3) {
								if(objectX3.isPlayed!=true) {
								objectX3.isPlayed=true;
								specialSound = new driveoverbox;
								specialChannel = specialSound.play();
								}
								objectX3.broken = true;
								objectX3.drawSprite(objectX3.objectNumber,0);
							}
							else {
								objectX3.x=objectX.x-objectX3.width;
							}
						}
					}
				}
				else if (objectROSTER[0].x<-objectROSTER[0].width) {
					try {while (objectROSTER[0].x<-objectROSTER[0].width) {
						switch (objectROSTER[0].laneNumber) {
							case 1:
								roadLayer1.removeChild(objectROSTER[0]);
								break;
							case 2:
								roadLayer2.removeChild(objectROSTER[0]);
								break;
							case 3:
								roadLayer3.removeChild(objectROSTER[0]);
								break;
							case 4:
								roadLayer4.removeChild(objectROSTER[0]);
								break;
						}
						objectROSTER.shift();
						objectROSTER[0].x-=objectSpeed;
					}}catch(e){};
					
				}
		
			}
			if (!timer.running) {
				timer = new Timer((3000-roundNumber),0);
				timer.addEventListener(TimerEvent.TIMER, spawnObject);
				timer.start();
			}
			if (roundNumber < 2800) roundNumber++;
			if (gameoverComing==true) {
				if (objectSpeed>0) {
					player.x-=objectSpeed;
					esImg.x-=objectSpeed;
					objectSpeed-=0.25;
				}
				else {
					gameover();
				}
			}
			else if(logjump==true) {
				if(playerJumpSpeed>-10 || player.y<-player.height) {
					esImg.y-=playerJumpSpeed;
					player.y-=playerJumpSpeed;
					playerJumpSpeed--;
				}
				else {
					player.wheeling=false;
					player.drawSprite(0,0);
					switch (player.laneNumber) {
						case 1:
							esImg.y=380-135;
							break;
						case 2:
							esImg.y=500-135;
							break;
						case 3:
							esImg.y=600-135;
							break;
						case 4:
							esImg.y=700-135;
							break;
					}
					player.y=-player.height;
					logjump=false;
					loseControl=false;
					
				}
			}
		}
		
		function createBoom(): void {
			
			explosionTimer.addEventListener(TimerEvent.TIMER,explosion);
			explosionTimer.start();
			specialeffectROSTER.push(new object(15,player.laneNumber,false));
			specialeffectROSTER[specialeffectROSTER.length-1].x=player.x+player.width;
			specialeffectROSTER[specialeffectROSTER.length-1].y-=player.height;
			switch (player.laneNumber) {
				case 1:
					roadLayer1.addChild(specialeffectROSTER[specialeffectROSTER.length-1]);
					break;
				case 2:
					roadLayer2.addChild(specialeffectROSTER[specialeffectROSTER.length-1]);
					break;
				case 3:
					roadLayer3.addChild(specialeffectROSTER[specialeffectROSTER.length-1]);
					break;
				case 4:
					roadLayer4.addChild(specialeffectROSTER[specialeffectROSTER.length-1]);
					break;
			}
		}
		function explosion(e:TimerEvent):void {
			explodedYet = true;
			explosionTimer.removeEventListener(TimerEvent.TIMER,explosion);
			explosionTimer.stop();
		}
		function showTips():void {
			var glowFilter:GlowFilter = new GlowFilter(0x000000,1,18,18,3,3,false,false);
			tipText.autoSize=TextFieldAutoSize.CENTER;
			
			var textFormat = new TextFormat();
			textFormat.font = "Comic Sans MS";
			textFormat.color=0xFFFFFF;
			textFormat.bold = true;
			textFormat.size = 48;
			
			tipText.selectable = false;
			tipText.defaultTextFormat = textFormat;
			tipText.text = "Use ARROW keys to move\nUse SPACE BAR to shoot";
			tipText.x = 1280/2-tipText.width/2;
			tipText.y = 300;
			tipText.filters = [glowFilter];
			tipText.antiAliasType = AntiAliasType.ADVANCED;
			tipTimer.addEventListener(TimerEvent.TIMER, tipHide);
			tipTimer.start();
			gameoverLayer.addChild(tipText);
		}
		function tipHide(e:Event):void {
			tipText.text = "";
			tipTimer.removeEventListener(TimerEvent.TIMER, tipHide);
			tipTimer.stop();
		}
		function scoreUpload():void {
			var glowFilter:GlowFilter = new GlowFilter(0x000000,1,18,18,3,3,false,false);
			bestScoreText.autoSize=TextFieldAutoSize.LEFT;
			theScoreText.autoSize = TextFieldAutoSize.LEFT;
			
			var textFormat = new TextFormat();
			textFormat.font = "Comic Sans MS";
			textFormat.color =0xFFFFFF;
			textFormat.bold = true;
			textFormat.size=42;
			
			var textFormat2 = new TextFormat();
			textFormat2.font = "Comic Sans MS";
			textFormat2.color =0xFFFFFF;
			textFormat2.bold = true;
			textFormat2.size=24;
			
			bestScoreText.selectable = false;
			bestScoreText.defaultTextFormat = textFormat2;
			bestScoreText.text = "Best score: " + alltimebestscore;
			bestScoreText.x = 1280/2-bestScoreText.width/2;
			bestScoreText.y = 100;
			bestScoreText.filters = [glowFilter];
			bestScoreText.antiAliasType = AntiAliasType.ADVANCED;
			gameoverLayer.addChild(bestScoreText);
			
			theScoreText.selectable = false;
			theScoreText.defaultTextFormat = textFormat;
			theScoreText.text = "SCORE: " + score;
			theScoreText.x = 1280/2-theScoreText.width/2-20;
			theScoreText.y = 50;
			theScoreText.filters = [glowFilter];
			theScoreText.antiAliasType = AntiAliasType.ADVANCED;
			gameoverLayer.addChild(theScoreText);
		}
		function gameover():void {
			gameTick.removeEventListener(TimerEvent.TIMER,world_tick);
			gameTick.stop();
			
			if(score>alltimebestscore) {
				alltimebestscore=score;
				saveGame();
			}
			gameoverTimer.addEventListener(TimerEvent.TIMER, gameoverSpray);
			gameoverTimer.start();
			gameoverRectangle.graphics.beginFill(0x000000); 
			gameoverRectangle.graphics.drawRect(0, 0, 1280,720); 
			gameoverRectangle.graphics.endFill(); 
			gameoverRectangle.alpha = 0;
			
			uiLayer.addChild(gameoverRectangle); 
		}
		function gameoverSpray(e:TimerEvent):void {
			gameoverRectangle.alpha+=0.01;
			if (gameoverRectangle.alpha>=0.85) {
				gameoverText();
				gameoverTimer.reset();
				gameoverTimer.removeEventListener(TimerEvent.TIMER, gameoverSpray);
			}
		}
		function pause_Tick(e:TimerEvent):void {
			if (keysPressedARRAY["" + keySPACE] && !keysNotReadyARRAY[""+keySPACE]) {
				keysNotReadyARRAY[""+keySPACE] = true;
				gamePause.removeEventListener(TimerEvent.TIMER,pause_Tick);
				gamePause.stop();
				gameStart();
			}
		}
		function gameoverText():void {
			gamePause.addEventListener(TimerEvent.TIMER,pause_Tick);
			gamePause.start();
			var theTextField:TextField = new TextField();
			var theTextField2:TextField = new TextField();
			var glowFilter:GlowFilter = new GlowFilter(16711680,1,18,18,3,3,false,false);
			theTextField.autoSize = TextFieldAutoSize.LEFT;
			theTextField2.autoSize = TextFieldAutoSize.LEFT;
			
			var textFormat = new TextFormat();
			textFormat.font = "Comic Sans MS";
			textFormat.color =0xFFFFFF;
			textFormat.size=42;
			textFormat.bold = true;
			
			theTextField2.selectable = false;
			theTextField2.defaultTextFormat = textFormat;
			theTextField2.text = "PRESS SPACE FOR A NEW GAME";
			theTextField2.x = 1280/2-theTextField2.width/2;
			theTextField2.y = 600;
			theTextField2.antiAliasType = AntiAliasType.ADVANCED;
			
			theTextField.selectable = false;
			theTextField.defaultTextFormat = textFormat;
			theTextField.text = "GAME OVER";
			theTextField.x = 1280/2-theTextField.width/2;
			theTextField.y = 720/2-theTextField.height/2;
			theTextField.filters = [glowFilter];
			theTextField.antiAliasType = AntiAliasType.ADVANCED;
			gameoverLayer.addChild(theTextField);
			gameoverLayer.addChild(theTextField2);
		}
		function shootObject():void {
			ESinStorage--;
			esImg.drawSprite(ESinStorage);
			player.throwing=true;
			player.drawSprite(0,0);
			esThrowingTimer.addEventListener(TimerEvent.TIMER, throwES);
			esThrowingTimer.start();
			
		}
		function throwES(e:TimerEvent):void {
			player.throwing=false;
			player.drawSprite(0,0);
			weaponROSTER.push(new object(10,player.laneNumber,false));
			weaponROSTER[weaponROSTER.length-1].x=player.x+player.width/2;
			weaponROSTER[weaponROSTER.length-1].y-=weaponROSTER[weaponROSTER.length-1].height*2;
			switch (player.laneNumber) {
				case 1:
					roadLayer1.addChild(weaponROSTER[weaponROSTER.length-1]);
					break;
				case 2:
					roadLayer2.addChild(weaponROSTER[weaponROSTER.length-1]);
					break;
				case 3:
					roadLayer3.addChild(weaponROSTER[weaponROSTER.length-1]);
					break;
				case 4:
					roadLayer4.addChild(weaponROSTER[weaponROSTER.length-1]);
					break;
			}
			esThrowingTimer.removeEventListener(TimerEvent.TIMER, throwES);
			esThrowingTimer.stop();
		}
		function stopDrinking(e:TimerEvent):void {
				player.drinking = false;
				player.drawSprite(0,0);
				esTimer.stop();
				esTimer.removeEventListener(TimerEvent.TIMER,stopDrinking);
			}
			
			function spawnObject(e:TimerEvent):void {
				var objectNum:int;
				var lane:int;
				var randomObjectNumber:Number = Math.random();
				var randomLaneNumber:Number = Math.random();
				var boxCount:Number = Math.random();
				var boxNum:int;
				if(randomObjectNumber<=3/12) objectNum=1;
				else if(randomObjectNumber>3/12&&randomObjectNumber<=6/12) objectNum=3;
				else if(randomObjectNumber>6/12&&randomObjectNumber<=8/12) objectNum=4;
				else if(randomObjectNumber>8/12&&randomObjectNumber<=10/12) objectNum=0;
				else if(randomObjectNumber>10/12&&randomObjectNumber<=11/12) objectNum=2;
				else if(randomObjectNumber>11/12) objectNum=5;
				
				for (var j:int = 0; j < laneCount; j++) {
					if (randomLaneNumber > j/laneCount && randomLaneNumber <= (j+1)/laneCount) {
						lane = j+1;
						
					}
				}
				
				if (objectNum==3) {
					for (var h:int=0;h<3;h++) {
						if (boxCount>h/3 && boxCount<= (h+1)/boxCount) {
							boxNum=h+1;
						}
					}
					switch (boxNum) {
					case 1:
						addObject(lane,objectNum);
						break;
					case 2:
							addObject(lane,objectNum);
						if (lane<4) {
							addObject(lane+1,objectNum);
						}
						else {
							addObject(lane-1,objectNum);
						}
						break;
					case 3:
						addObject(lane,objectNum);
						switch (lane) {
							case 1:
								addObject(lane+1,objectNum);
								addObject(lane+2,objectNum);
								break;
							case 2:
								addObject(lane-1,objectNum);
								addObject(lane+2,objectNum);
								break;
							case 3:
								addObject(lane-2,objectNum);
								addObject(lane+1,objectNum);
								break;
							case 4:
								addObject(lane-1,objectNum);
								addObject(lane-2,objectNum);
								break;
						}
						break;
					}
				}
			
				else addObject(lane,objectNum);
				if (drawUp==false && drawDown==false) {
					switch(player.laneNumber) {
						case 1:
							roadLayer1.removeChild(player);
							roadLayer1.addChild(player);
							break;
						case 2:
							roadLayer2.removeChild(player);
							roadLayer2.addChild(player);
							break;
						case 3:
							roadLayer3.removeChild(player);
							roadLayer3.addChild(player);
							break;
						case 4:
							roadLayer4.removeChild(player);
							roadLayer4.addChild(player);
							break;
					
					}
				}
			
				timer.removeEventListener(TimerEvent.TIMER, spawnObject);
				timer.stop();
			}
		function addObject(lane:int, objectNum:int):void {
			if (objectNum==3) {
				var whichBoxSurprise:Number = Math.random();
				var intBox:int;
				if(whichBoxSurprise<=6/10) intBox=14;
				else if(whichBoxSurprise>6/10&&whichBoxSurprise<=8/10) intBox=11;
				else if(whichBoxSurprise>8/10&&whichBoxSurprise<=9/10) intBox=13;
				else intBox=12;
				effectROSTER.push(new object(intBox,lane,false));
				effectROSTER[effectROSTER.length-1].x=1280;
			}
			objectROSTER.push(new object(objectNum, lane, false));
			objectROSTER[objectROSTER.length-1].x=1280;
			
			if (objectNum==4)objectROSTER[objectROSTER.length-1].y-=objectROSTER[objectROSTER.length-1].height-20;
			else {
				if(objectNum==3)effectROSTER[effectROSTER.length-1].y-=effectROSTER[effectROSTER.length-1].height;
				objectROSTER[objectROSTER.length-1].y-=objectROSTER[objectROSTER.length-1].height;
			}
			switch (lane) {
				case 1:
					if(objectNum==3)roadLayer1.addChild(effectROSTER[effectROSTER.length-1]);
					roadLayer1.addChild(objectROSTER[objectROSTER.length-1]);
					break;
				case 2:
					if(objectNum==3)roadLayer2.addChild(effectROSTER[effectROSTER.length-1]);
					roadLayer2.addChild(objectROSTER[objectROSTER.length-1]);
					break;
				case 3:
					if(objectNum==3)roadLayer3.addChild(effectROSTER[effectROSTER.length-1]);
					roadLayer3.addChild(objectROSTER[objectROSTER.length-1]);
					break;
				case 4:
					if(objectNum==3)roadLayer4.addChild(effectROSTER[effectROSTER.length-1]);
					roadLayer4.addChild(objectROSTER[objectROSTER.length-1]);
					break;
			}
		}
		function areKeysDOWN(event:KeyboardEvent):void{
					switch(event.keyCode){
						case keyUP:
						case keyDOWN:
						case keySPACE:
							keysPressedARRAY[""+event.keyCode] = true; 
							break;
					}
				}
				function areKeysUP(event:KeyboardEvent):void{
					switch(event.keyCode){
						case keyUP:
						case keyDOWN:
						case keySPACE:
							keysPressedARRAY[""+event.keyCode] = false;
							keysNotReadyARRAY[""+event.keyCode] = false;
							break;
					}
				}
		}
	}
	
}
