package QSB_Files {
	import QSB_Files.IndicatorGUI;
	import QSB_Files.TradableGUI
	import flash.events.Event
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Bitmap;
	import flash.filters.*;
	

	public class QueryStringBuilder extends MovieClip {

		// constructor stuff
		private var bgObject:Object;
		private var xCoor:Number;
		private var yCoor:Number;
		private var eventDispatchString:String;
		private var _IND:IndicatorGUI;
		private var _TBL:TradableGUI;
		private var closePic:Bitmap;
		private var indContainer:Sprite;
		private var tblContainer:Sprite;
		private var bmpContainer:Sprite;
		
		
		import flash.utils.getDefinitionByName;

		
		
		// the rest
		private var QSBMovieClip:MovieClip;
		private var TBL_IND:String;
		
		
		public function QueryStringBuilder(bgObject:Object, xCoor:Number, yCoor:Number, eventDispatchString:String) {
			_TBL = new TradableGUI();
			_IND = new IndicatorGUI();
			QSBMovieClip = new MovieClip();
			var IND:Class = getDefinitionByName("IND") as Class;
			var ind:Bitmap = new Bitmap(new IND(575,430));
			var TBL:Class = getDefinitionByName("TBL") as Class;
			var tbl:Bitmap = new Bitmap(new TBL(575,430));
			var CLOSEPIC:Class = getDefinitionByName("closeB") as Class;
			var closePic2:Bitmap = new Bitmap(new CLOSEPIC());
			 tbl.x = -600;
			 tbl.y = 0;
			 tbl.scaleX = .4;
			 tbl.scaleY = .4;
			 ind.x = -500;
			 ind.y = 0;
			 ind.scaleX = .4;
			 ind.scaleY = .4;
			// closePic2.scaleX = .1;
			//closePic2.scaleY = .1;
			closePic2.x = 190;
			tblContainer = new Sprite();
			tblContainer.addEventListener(MouseEvent.CLICK, TblHandler);
			tblContainer.buttonMode = true;// this just makes it show the hand cursor, and is not necessary for the mouse events to work
			tblContainer.addChild(tbl);
			indContainer = new Sprite();// can receive mouse events, for example:
			indContainer.addEventListener(MouseEvent.CLICK, IndHandler);
			indContainer.buttonMode = true;// this just makes it show the hand cursor, and is not necessary for the mouse events to work
			indContainer.addChild(ind);
			bmpContainer = new Sprite();// can receive mouse events, for example:
			bmpContainer.addEventListener(MouseEvent.CLICK, CloseClickHandler);
			bmpContainer.buttonMode = true;// this just makes it show the hand cursor, and is not necessary for the mouse events to work
			bmpContainer.addChild(closePic2);
			
			
			 
			this.bgObject = bgObject;
			this.xCoor = xCoor;
			this.yCoor = yCoor;
			this.eventDispatchString = eventDispatchString;
			
			
			
			
			this.bgObject.addChild(QSBMovieClip);
			QSBMovieClip.addChild(bmpContainer)

			QSBMovieClip.addChild(indContainer);
			QSBMovieClip.addChild(tblContainer);
			var tween1:Tween = new Tween(tblContainer,"x",Strong.easeOut, tblContainer.x, 600, 2,true);
			var tween2:Tween = new Tween(indContainer,"x",Strong.easeOut, indContainer.x, 600, 2,true);
			
			 //tween1.start();
			 //tween2.start();
			
			
			
			
		}
		function TblHandler(e:MouseEvent):void{
			if(QSBMovieClip.contains(_IND)){
			   QSBMovieClip.removeChild(_IND);
			   }
			   
			
			
			_TBL = new TradableGUI();
			TBL_IND = "TBL";
			
			_TBL.addEventListener("ReadyForChart", fireUpEvent)
			  var myGlow:GlowFilter = new GlowFilter();
			myGlow.alpha=0.5;
			   tblContainer.filters = [myGlow];
			   indContainer.filters = undefined;
			//var tween:Tween = new Tween(_TBL,"alpha",Strong.easeOut, 0, 1, 2,true);
			//tween.start()
			QSBMovieClip.addChildAt(_TBL,QSBMovieClip[3] );
			//QSBMovieClip.removeChild(indContainer)
			
		}
		function IndHandler(e:MouseEvent):void{
			if(QSBMovieClip.contains(_TBL)){
			   QSBMovieClip.removeChild(_TBL);
			   }
			   
			   var myGlow:GlowFilter = new GlowFilter();
			myGlow.alpha=0.5;
			   indContainer.filters = [myGlow];
			   tblContainer.filters = undefined;
			_IND = new IndicatorGUI;
			TBL_IND = "IND";
			_IND.addEventListener("ReadyForChart", fireUpEvent)
			//var tween:Tween = new Tween(_TBL,"alpha",Strong.easeOut, 1, 0, 2,true);
			//tween.start()
			//QSBMovieClip.addChild(_IND);
			QSBMovieClip.addChildAt(_IND,QSBMovieClip[3] );
			//QSBMovieClip.removeChild((_TBL));
			
		}
		private function fireUpEvent(e:Event):void { 
		
			this.dispatchEvent(new Event(this.eventDispatchString)); 
		}
	
		public function sendQueryResult():String {
			if(TBL_IND == "TBL")
			{
			return(_TBL.RetrieveQData());
			}
			
			return _IND.RetrieveQData()
		}
		
		public function destroySelf():void {
			bgObject.removeChild(QSBMovieClip);
		}
		
		/*Sets the close button*/
		function SetCloseButton():void
		{
			
			
			//
			//Container for the bitmap of the close image
			
			//END;

			//TwClip.addChild(closePic);
			this.addChild(bmpContainer);
		}
		//Closes the movie clip
		function CloseClickHandler(e:MouseEvent):void
		{
			this.destroySelf();
		}

	}
	
}
