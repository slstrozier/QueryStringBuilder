package QSB_Files
{
	import flash.display.MovieClip;
	import QSB_Files.Events.CustomEvent;
	import QSB_Files.URLFactory;
	import QSB_Files.QueryBuilder;
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
	public class GUIBuilder extends MovieClip
	{
		private var _UrlDriver:URLFactory;
		private var _QueryDriver:QueryBuilder;
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
		//private var QSBMovieClip:MainClass;
		private var aList:List;
		private var qData:String;
		private var TwClip:MovieClip;
		private var tween:Tween;
		private var _close:Button;
		private var closePic:Bitmap;
		private var bmpContainer:Sprite;
		public function GUIBuilder()
		{
			SetGUI();
			AddQueryDriverEventListeners();
			SetDaysToCalculateBx();
			CreateSubmitBttn();
			SetTreatmentDaysBx();
			SetStartDate();
			SetEndDate();
			SetStartChkBx();
			SetEndChkBx();
			SetTypeBx();
			SetCloseButton();
		}
		/*Sets the GUI*/
		function SetGUI():void{
			//The movie clip used for the tween
			TwClip = new MovieClip();
			TwClip.x = -600;
			const thickness:Number = 1;
			TwClip.graphics.beginFill(0xCCDDFF);
			TwClip.graphics.lineStyle(thickness, 0x080808, 1, true);
			TwClip.graphics.drawRoundRect(-600, 0, 500, 500, 12);
			_QueryDriver = new QueryBuilder("stuff");
			this.addChild(TwClip);
			tween = new Tween(TwClip,"x",Strong.easeIn,TwClip.x,600,1,true);
			tween.start()
		}
		/*Adds the EventListeners to this instance of the QueryDriver*/
		function AddQueryDriverEventListeners():void{
			_QueryDriver.addEventListener("SetDataBase", SetDbBox);
			_QueryDriver.addEventListener("SetTreatments", SetTreatBx);
			_QueryDriver.addEventListener("SetIndicators", SetIndBx);
			_QueryDriver.addEventListener("SetStocks", SetStkBx);
			_QueryDriver.addEventListener("QueryResultReady", RetrieveQueryData);
			
		}
		/*Sets the close button*/
		function SetCloseButton():void{
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
			//END
			
			//TwClip.addChild(closePic);
			TwClip.addChild(bmpContainer);
		}
		//Closes the movie clip
		function CloseClickHandler(e:MouseEvent):void{
			this.removeChild(TwClip);
		}
		///Sets the ComboBox for the type of analysis.
		function SetTypeBx():void
		{
			var typeBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(_QueryDriver.ReturnType());
			typeBx.x = 200 + TwClip.x;
			typeBx.width = 200;
			typeBx.dataProvider = dp;
			typeBx.prompt = "Please Select A Type";
			typeBx.addEventListener(Event.CHANGE, SetType);
			TwClip.addChild(typeBx);
		}
		//Event Handler for the Type Combo Box
		function SetType(e:Event):void
		{
			_QueryDriver.TYPE = e.target.value;
		}


		//DATABASES
		///Sets the ComboBox for the Database to Use.
		function SetDbBox(e:Event):void
		{
			var dbBox:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(_QueryDriver.ReturnDatabases());

			dbBox.y = 75;
			dbBox.x = TwClip.x;
			dbBox.dataProvider = dp;
			dbBox.width = 200;
			dbBox.prompt = "Please Select A Database";
			dbBox.addEventListener(Event.CHANGE, SetDB);
			dispatchEvent(new Event("DataBaseReady"));
			TwClip.addChild(dbBox);
		}
		//Event Listener for the Database comboBox
		function SetDB(e:Event):void
		{
			desc.text = "";
			var temp:String = e.target.value;
			var i:int = temp.indexOf('"');
			_QueryDriver.DATABASE = temp.substr(0,i);
			desc.y = 100;
			desc.x = TwClip.x - 1200;
			desc.autoSize = "left";
			desc.text = temp.substr(i+3, temp.length);
			TwClip.addChild(desc);
			_QueryDriver.UpdateQueryString();
		}

		//TREATMENTS
		function SetTreatBx(e:Event):void
		{//trace("hellO");
			var treatBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(_QueryDriver.ReturnTreatments());
			treatBx.y = 150;
			treatBx.x = TwClip.x;
			treatBx.dataProvider = dp;
			treatBx.width = 200;
			treatBx.prompt = "Please Select A Treatment";
			treatBx.addEventListener(Event.CHANGE, SetTreatments);
			TwClip.addChild(treatBx);
		}
		//Event Listener for the Database comboBox
		function SetTreatments(e:Event):void
		{
			var temp:String = e.target.value;
			var i:int = temp.indexOf('"');
			if (e.target.value == "")
			{
				_QueryDriver.TREATMENT = "";
			}
			if (e.target.value != "")
			{
				_QueryDriver.TREATMENT = temp.substr(0,i) + "-";
			}
			treat_desc.y = 175;
			treat_desc.x = TwClip.x - 1200;
			treat_desc.autoSize = "left";
			treat_desc.text = temp.substr(i+3, temp.length);
			TwClip.addChild(treat_desc);
			_QueryDriver.UpdateQueryString();
		}

		//INDICATORS
		function SetIndBx(e:Event):void
		{//trace("hellO");
			var indBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(_QueryDriver.ReturnIndicators());
			indBx.y = 225;
			indBx.x = TwClip.x;
			indBx.dataProvider = dp;
			indBx.width = 200;
			indBx.prompt = "Please Select An Indicator";
			indBx.addEventListener(Event.CHANGE, SetIndicators);
			TwClip.addChild(indBx);
		}
		//Event Listener for the Database comboBox
		function SetIndicators(e:Event):void
		{
			var temp:String = e.target.value;
			var i:int = temp.indexOf('"');
			_QueryDriver.ENTITY = temp.substr(0,i);
			ind_desc.y = 250;
			ind_desc.x = TwClip.x - 1200;
			ind_desc.autoSize = "left";
			ind_desc.wordWrap = true;
			ind_desc.width = 500;
			ind_desc.text = temp.substr(i+3, temp.length);
			TwClip.addChild(ind_desc);
			_QueryDriver.UpdateQueryString();
		}

		//STOCKLIST
		function SetStkBx(e:Event):void
		{
			var stkBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(_QueryDriver.ReturnStock());
			stkBx.y = 325;
			stkBx.x = TwClip.x;
			stkBx.dataProvider = dp;
			stkBx.width = 200;
			stkBx.prompt = "Please Select A Stock";
			stkBx.addEventListener(Event.CHANGE, SetStocks);
			TwClip.addChild(stkBx);
		}
		//Event Listener for the Database comboBox
		function SetStocks(e:Event):void
		{
			var temp:String = e.target.value;
			var i:int = temp.indexOf('"');
			_QueryDriver.STOCK_INDICATOR = temp.substr(0,i);
			stk_desc.y = 350;
			stk_desc.x = TwClip.x - 1200;
			stk_desc.autoSize = "left";
			stk_desc.text = temp.substr(i+3, temp.length);
			TwClip.addChild(stk_desc);
			_QueryDriver.UpdateQueryString();
		}
		//Creates the submitBttn;
		function CreateSubmitBttn()
		{
			subBtn.x = 350 + TwClip.x;
			subBtn.y = 450;
			subBtn.label = "Submit";
			subBtn.addEventListener(MouseEvent.CLICK, SubmitQuery);
			TwClip.addChild(subBtn);
		}
		//Creates the days to calculate box for the theory testing
		function SetDaysToCalculateBx()
		{
			numbDays.addEventListener(Event.CHANGE, SetDaysToCalculate);
			numbDays.x = 200 + TwClip.x;
			numbDays.y = 150;
			TwClip.addChild(numbDays);
		}
		//Creates the days to calculate box for the theory testing (treatments)
		function SetTreatmentDaysBx()
		{
			treatDays = new TextInput();
			treatDays.addEventListener(Event.CHANGE, SetTreatmentDays);
			treatDays.x = 200 + TwClip.x;
			treatDays.y = 230;
			TwClip.addChild(treatDays);
		}
		//Creates the startdate box (for days to view data)
		function SetStartDate()
		{
			var lbl:Label = new Label();
			lbl.text = "Start";
			lbl.move(300 + TwClip.x,375);
			startDate = new TextInput();
			startDate.x = 275 + TwClip.x;
			startDate.y = 400;
			startDate.text = "";
			startDate.addEventListener(Event.CHANGE, StartDate);
			TwClip.addChild(lbl);
			TwClip.addChild(startDate);
		}
		//Creates the enddate box (for days to view data)
		function SetEndDate()
		{
			var lbl:Label = new Label();
			lbl.text = "End";
			lbl.move(425 + TwClip.x,375);
			endDate = new TextInput();
			endDate.x = 400 + TwClip.x;;
			endDate.y = 400;
			endDate.addEventListener(Event.CHANGE, EndDate);
			TwClip.addChild(lbl);
			TwClip.addChild(endDate);
		}
		function SetStartChkBx()
		{
			from_Btn = new CheckBox();
			from_Btn.y = 425;
			from_Btn.x = 275 + TwClip.x;
			from_Btn.label = "ALL";
			from_Btn.addEventListener(MouseEvent.CLICK, FromClickHandler);
			TwClip.addChild(from_Btn);
		}
		function SetEndChkBx()
		{
			to_Btn = new CheckBox();
			to_Btn.y = 425;
			to_Btn.x = 400 + TwClip.x;
			to_Btn.label = "NOW";
			to_Btn.addEventListener(MouseEvent.CLICK, ToClickHandler);
			TwClip.addChild(to_Btn);

		}
		function SetTreatmentDays(e:Event):void
		{
			_QueryDriver.TREATMENTDAYS = treatDays.text;
		}
		function SetDaysToCalculate(e:Event):void
		{
			_QueryDriver.DAYSTOCALCULATE = numbDays.text;
		}

		function FromClickHandler(e:MouseEvent):void
		{
			if (from_Btn.selected == true)
			{
				_QueryDriver.STARTDATE_STRING = "ALL";
			}
			else
			{
				_QueryDriver.STARTDATE_STRING = startDate.text;
			}

		}
		function ToClickHandler(e:MouseEvent):void
		{
			if (to_Btn.selected == true)
			{
				_QueryDriver.ENDDATE_STRING = "NOW";
			}
			else
			{
				_QueryDriver.ENDDATE_STRING = endDate.text;
			}

		}
		function StartDate(e:Event):void
		{
			startDateString = startDate.text;
			trace(startDateString);
		}

		function EndDate(e:Event):void
		{
			endDateString = endDate.text;
			trace(endDateString);
		}

		function SubmitQuery(e:MouseEvent):void
		{

			if (to_Btn.selected == false && from_Btn.selected == false)
			{
				_QueryDriver.SetEndDate(endDate.text);
				_QueryDriver.SetStartDate(startDate.text);
			}

			trace(_QueryDriver.UpdateQueryString());

			_QueryDriver.SubmitQuery();
		}
		public function RetrieveQueryData(e:Event):void
		{

			qData = _QueryDriver.ReturnQueryData();
			//trace("ReadyForChart");
			//trace(qData + "qData")
			//dispatchEvent(new Event("ReadyForChart"));
			dispatchEvent(new Event("ReadyForChart"));
		}
		public function RetrieveQData():String
		{
			return this.qData;
		}
	}

}