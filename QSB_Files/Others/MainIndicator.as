package QSB_Files
{
	import flash.display.MovieClip;
	import QSB_Files.Events.CustomEvent;
	import QSB_Files.URLFactory;
	import QSB_Files.QueryBuilder;
	import QSB_Files.Tradable;
	import QSB_Files.Indicator;
	import flash.events.Event;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.MouseEvent;
	import fl.controls.TextInput;
	import fl.controls.Label;
	import fl.controls.CheckBox;
	import fl.controls.List;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class MainIndicator extends MovieClip
	{
		private var _UrlDriver:URLFactory;
		private var _QueryDriver:QueryBuilder;
		private var _Indicator:Indicator;
		private var subBtn:Button = new Button();
		private var numbDays:TextInput = new TextInput();
		private var treatDays:TextInput;
		private var startDate:TextInput;
		private var endDate:TextInput;
		private var from_Btn:CheckBox;
		private var to_Btn:CheckBox;
		private var startDateString:String;
		private var endDateString:String;
		private var desc:Label = new Label();
		private var treat_desc:Label = new Label();
		private var ind_desc:Label = new Label();
		private var stk_desc:Label = new Label();
		private var bgObject:Object;
		private var xCoor:Number;
		private var yCoor:Number;
		private var eventDispatchString:String;
		private var aList:List;
		private var qData:String;
		private var TwClip:MovieClip;
		private var tween:Tween;
		private var _close:Button;
		private var closePic:Bitmap;
		private var bmpContainer:Sprite;
		private var category:String = "hello";
		private var Sdp:DataProvider = new DataProvider();
		private var tempArray2:Array = new Array();
		private var stkBx:ComboBox;
		private var catetory:String;
		private var queryStringText:Label;
		private var indicators_desc:Label = new Label();
		private var databases_desc:Label = new Label();
		public function MainIndicator()
		
		{
			trace("mainIndicatorStarted");
			SetGUI();
			AddQueryDriverEventListeners();
			SetDaysToCalculateBx();
			CreateSubmitBttn();
			SetTreatmentDaysBx();
			SetStartDate();
			SetEndDate();
			SetStartChkBx();
			SetEndChkBx();
			SetCloseButton();
		}
		/*Sets the GUI*/
		function SetGUI():void
		{
			trace("SetGUI");
			//The movie clip used for the tween
			TwClip = new MovieClip();
			TwClip.x = -600;
			const thickness:Number = 1;
			TwClip.graphics.beginFill(0xCCDDFF);
			TwClip.graphics.lineStyle(thickness, 0x080808, 1, true);
			TwClip.graphics.drawRoundRect(-600, 0, 500, 500, 12);
			_QueryDriver = new QueryBuilder("stuff");
			
			_Indicator = new Indicator();
		
			queryStringText = new Label();
			queryStringText.autoSize = "left";
			queryStringText.x = TwClip.x;
			queryStringText.y = 350;			
			this.addChild(TwClip);
			TwClip.addChild(queryStringText);
			tween = new Tween(TwClip,"x",Strong.easeIn,TwClip.x,600,1,true);
			tween.start();
		}
		/*Adds the EventListeners to this instance of the QueryDriver*/
		function AddQueryDriverEventListeners():void
		{
			_Indicator.addEventListener("ImReady", SetIndicatorsBx);
			_Indicator.addEventListener("ImReady", SetTreatBx);
			_Indicator.addEventListener("ImReady", SetDatabaseBx);
			_Indicator.addEventListener("QueryResultReady", RetrieveQueryData);

		}
		function Heard(e:Event):void{
			trace("heard")
		}
		/*Sets the close button*/
		function SetCloseButton():void
		{
			//The bitmap for the close pic
			closePic = new Bitmap(new closeImg(0,0));
			closePic.width = 25;
			closePic.height = 25;
			closePic.x = TwClip.x + TwClip.width - 55;
			closePic.y = 5;
			//
			//Container for the bitmap of the close image
			bmpContainer = new Sprite();// can receive mouse events, for example:
			bmpContainer.addEventListener(MouseEvent.CLICK, CloseClickHandler);
			bmpContainer.buttonMode = true;// this just makes it show the hand cursor, and is not necessary for the mouse events to work
			bmpContainer.addChild(closePic);
			//END;

			//TwClip.addChild(closePic);
			TwClip.addChild(bmpContainer);
		}
		//Closes the movie clip
		function CloseClickHandler(e:MouseEvent):void
		{
			this.removeChild(TwClip);
		}
		
		//TREATMENTS
		function SetTreatBx(e:Event):void
		{
			var treatBx:ComboBox = new ComboBox();
			trace("here");
			var dp:DataProvider = new DataProvider(ExtractDictonaryContents(_Indicator.ReturnTreatments()));
			treatBx.y = 225;
			treatBx.x = TwClip.x;
			treatBx.dataProvider = dp;
			treatBx.width = 200;
			treatBx.prompt = "Please Select A Treatment";
			treatBx.addEventListener(Event.CHANGE, SetTreatments);
			treatBx.addEventListener(Event.CHANGE, DisplayQuery);
			TwClip.addChild(treatBx);
		}
		//Event Listener for the Database comboBox
		function SetTreatments(e:Event):void
		{
			var temp:String = e.target.value;
			trace(temp)
			var i:int = temp.indexOf('"');
			if (e.target.value == "")
			{
				_Indicator.TREATMENT_STRING = "";
			}
			if (e.target.value != "")
			{
				_Indicator.TREATMENT_STRING = temp + "-";
			}
			treat_desc.y = 250;
			treat_desc.x = TwClip.x - 1200;
			treat_desc.autoSize = "left";
			var tD:Dictionary = _Indicator.ReturnTreatments();
			for(var index:Object in tD)
			{
				trace(index)
				}
			treat_desc.text = _Indicator.ReturnTreatments()[e.target.value];
			TwClip.addChild(treat_desc);
			
		}

		//CATAGORIES
		function SetIndicatorsBx(e:Event):void
		{			
			var IndicatorsBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(ExtractDictonaryContents(_Indicator.ReturnIndicators()));
			IndicatorsBx.y = 70;
			IndicatorsBx.x = TwClip.x;
			IndicatorsBx.dataProvider = dp;
			IndicatorsBx.width = 200;
			IndicatorsBx.prompt = "Please Select An Indicator";
			IndicatorsBx.addEventListener(Event.CHANGE, SetIndicators);
			IndicatorsBx.addEventListener(Event.CHANGE, DisplayQuery)
			TwClip.addChild(IndicatorsBx);
			
		}
		//Event Listener for the Database comboBox
		function SetIndicators(e:Event):void
		{
			var temp:String = e.target.value;
			var i:int = temp.indexOf('"');
			_Indicator.INDICATOR = e.target.value.toString();
			indicators_desc.y = 100;
			indicators_desc.x = TwClip.x - 1200;
			indicators_desc.autoSize = "left";
			indicators_desc.wordWrap = true;
			indicators_desc.width = 500;
			trace(temp)
			indicators_desc.text = _Indicator.ReturnIndicators()[e.target.value];
			TwClip.addChild(indicators_desc);
		
		}
		
		function SetDatabaseBx(e:Event):void
		{			
			var dbBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(ExtractDictonaryContents(_Indicator.ReturnTradables()));
			dbBx.y = 150;
			dbBx.x = TwClip.x;
			dbBx.width = 200;
			dbBx.dataProvider = dp;
			dbBx.addEventListener(Event.CHANGE, SetDatabases)
			dbBx.addEventListener(Event.CHANGE, DisplayQuery);
			dbBx.prompt = "Please Select A Database";
			TwClip.addChild(dbBx);
		}
		//Event Listener for the Database comboBox
		function SetDatabases(e:Event):void
		{
			var temp:String = e.target.value;
			var i:int = temp.indexOf('"');
			_Indicator.TRADABLES_DATABASE_STRING = e.target.value.toString();
			var temp2:Dictionary = _Indicator.ReturnTradables();
			
			category = e.target.value.toString().toLocaleLowerCase();
			databases_desc.y = 175;
			databases_desc.x = TwClip.x - 1200;
			databases_desc.autoSize = "left";
			databases_desc.wordWrap = true;
			databases_desc.width = 500;
			indicators_desc.text = _Indicator.ReturnTradables()[category.toString()];
			TwClip.addChild(databases_desc);
		
		}
			/********************THIS WAS A COOL METHOD NOT IMPLEMENTED TO CREATE A METHOD CALL needs work*************
			*var temp:String = category.toLocaleLowerCase();
			var methodString1:String = "_Tradable.";
			var upper:String = temp.charAt(0).toString().toUpperCase();
			temp = upper + temp.slice(1,temp.length)
			//trace(temp);
			var methodString2:String = "Return"
			var methodString3:String = "()"
			var fullMethod:String = methodString1 + methodString2 + temp + methodString3;*//***************
			//trace(fullMethod)
			//var array:Array = new Array(ExtractDictonaryContents(fullMethod.valueOf()))
										//trace(array)
			//var dp:DataProvider = new DataProvider(ExtractDictonaryContents( new String ("methodString1 + methodString2 + temp + methodString3")));
			//trace(fullMethod)
			////*/
			
			
		//}
		function UpdateDataProvider(e:Event):void{
			Sdp = new DataProvider(tempArray2);
		}
		
		//Creates the submitBttn;
		function CreateSubmitBttn()
		{
			subBtn.x = 50 + TwClip.x;
			subBtn.y = 375;
			subBtn.label = "Submit";
			subBtn.addEventListener(MouseEvent.CLICK, SubmitQuery);
			TwClip.addChild(subBtn);
		}
		
		function DisplayQuery(e:Event):void{
			queryStringText.text = _Indicator.UpdateQueryString();
		}
		//Creates the days to calculate box for the theory testing
		function SetDaysToCalculateBx()
		{
			numbDays = new TextInput();
			numbDays.addEventListener(Event.CHANGE, SetDaysToCalculate);
			numbDays.addEventListener(Event.CHANGE, DisplayQuery);
			numbDays.x = 200 + TwClip.x;
			numbDays.y = 70;
			TwClip.addChild(numbDays);
		}
		//Creates the days to calculate box for the theory testing (treatments)
		function SetTreatmentDaysBx()
		{
			treatDays = new TextInput();
			treatDays.addEventListener(Event.CHANGE, SetTreatmentDays);
			treatDays.addEventListener(Event.CHANGE, DisplayQuery);
			treatDays.x = 210 + TwClip.x;
			treatDays.y = 225;
			TwClip.addChild(treatDays);
		}
		//Creates the startdate box (for days to view data)
		function SetStartDate()
		{
			var lbl:Label = new Label();
			lbl.text = "Start";
			lbl.move(10 + TwClip.x,275);
			startDate = new TextInput();
			startDate.x = TwClip.x;
			startDate.y = 290;
			startDate.text = "";
			startDate.addEventListener(Event.CHANGE, StartDate);
			startDate.addEventListener(Event.CHANGE, DisplayQuery);
			TwClip.addChild(lbl);
			TwClip.addChild(startDate);
		}
		//Creates the enddate box (for days to view data)
		function SetEndDate()
		{
			var lbl:Label = new Label();
			lbl.text = "End";
			lbl.move(200 + TwClip.x,275);
			endDate = new TextInput();
			endDate.x = 125 + TwClip.x;;
			endDate.y = 290;
			endDate.addEventListener(Event.CHANGE, EndDate);
			endDate.addEventListener(Event.CHANGE, DisplayQuery);
			TwClip.addChild(lbl);
			TwClip.addChild(endDate);
		}
		function SetStartChkBx()
		{
			from_Btn = new CheckBox();
			from_Btn.y = 325;
			from_Btn.x = TwClip.x;
			from_Btn.label = "ALL";
			from_Btn.addEventListener(MouseEvent.CLICK, FromClickHandler);
			from_Btn.addEventListener(MouseEvent.CLICK, DisplayQuery);
			TwClip.addChild(from_Btn);
		}
		function SetEndChkBx()
		{
			to_Btn = new CheckBox();
			to_Btn.y = 325;
			to_Btn.x = 130 + TwClip.x;
			to_Btn.label = "NOW";
			
			to_Btn.addEventListener(MouseEvent.CLICK, ToClickHandler);
			to_Btn.addEventListener(MouseEvent.CLICK, DisplayQuery);
			TwClip.addChild(to_Btn);

		}
		function SetTreatmentDays(e:Event):void
		{
			_Indicator.DAYSTOCALCULATE = treatDays.text;
		}
		function SetDaysToCalculate(e:Event):void
		{
			_Indicator.TREATMENTDAYS = numbDays.text;
		}

		function FromClickHandler(e:MouseEvent):void
		{
			_Indicator.STARTDATE_STRING = startDate.text;
			
			if (from_Btn.selected == true)
			{
				_Indicator.STARTDATE_STRING = "ALL";
			}

		}
		function ToClickHandler(e:MouseEvent):void
		{
			_Indicator.ENDDATE_STRING = endDate.text;
			if (to_Btn.selected == true)
			{
				_Indicator.ENDDATE_STRING = "NOW";
			}
		}
		function StartDate(e:Event):void
		{
			_Indicator.STARTDATE_STRING = startDate.text;
			
		}

		function EndDate(e:Event):void
		{
			_Indicator.ENDDATE_STRING = endDate.text;
			
		}

		function SubmitQuery(e:MouseEvent):void
		{
			trace(_Indicator.UpdateQueryString());

			_Indicator.SubmitQuery();
		}
		public function RetrieveQueryData(e:Event):void
		{

			qData = _Indicator.ReturnQueryData();
			dispatchEvent(new Event("ReadyForChart"));
		}
		public function RetrieveQData():String
		{
			trace("QDATA");
			return this.qData;
		}
		
		function ExtractDictonaryContents(dictionary:Dictionary):Array
		{
			var temp:Array = new Array();
			for (var index:Object in dictionary)
			{
				temp.push(index.toString().toUpperCase());
			}
			
			temp.sort();
			return temp;

		}
	}

}