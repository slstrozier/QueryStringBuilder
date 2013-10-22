package QSB_Files
{
	import flash.display.MovieClip;
	import QSB_Files.Events.CustomEvent;
	import QSB_Files.URLFactory;
	import QSB_Files.QueryBuilder;
	import QSB_Files.Tradable;
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

	public class MainClass extends MovieClip
	{
		private var _UrlDriver:URLFactory;
		private var _QueryDriver:QueryBuilder;

		private var _Tradable:Tradable;

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
		private var tradables_desc:Label = new Label();
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
		private var category:String = "hello";
		private var Sdp:DataProvider = new DataProvider();
		private var tempArray2:Array = new Array();
		private var stkBx:ComboBox;
		private var catetory:String;
		private var queryStringText:Label;
		public function MainClass()
		
		{
			SetGUI();
			AddQueryDriverEventListeners();
			//SetDaysToCalculateBx();
			CreateSubmitBttn();
			SetTreatmentDaysBx();
			SetStartDate();
			SetEndDate();
			SetStartChkBx();
			SetEndChkBx();
			//SetTypeBx();
			SetCloseButton();
		}
		/*Sets the GUI*/
		function SetGUI():void
		{
			//The movie clip used for the tween
			TwClip = new MovieClip();
			TwClip.x = -600;
			const thickness:Number = 1;
			TwClip.graphics.beginFill(0xCCDDFF);
			TwClip.graphics.lineStyle(thickness, 0x080808, 1, true);
			TwClip.graphics.drawRoundRect(-600, 0, 500, 500, 12);
			_QueryDriver = new QueryBuilder("stuff");
			//
			_Tradable = new Tradable();
			//
			queryStringText = new Label();
			queryStringText.autoSize = "left";
			queryStringText.x = TwClip.x + 10;
			queryStringText.y = 350;			
			
			
			this.addChild(TwClip);
			TwClip.addChild(queryStringText);
			tween = new Tween(TwClip,"x",Strong.easeIn,TwClip.x,600,1,true);
			tween.start();
		}
		/*Adds the EventListeners to this instance of the QueryDriver*/
		function AddQueryDriverEventListeners():void
		{
			//
			//_QueryDriver.addEventListener("SetDataBase", SetDbBox);
			//_QueryDriver.addEventListener("SetTreatments", SetTreatBx);
			//_QueryDriver.addEventListener("SetIndicators", SetIndBx);
			//_QueryDriver.addEventListener("SetStocks", SetStkBx);
			//_QueryDriver.addEventListener("QueryResultReady", RetrieveQueryData);
			//;
			//_Tradable.addEventListener("CurrenciesReady", SetTreatBx);
			//_Tradable.addEventListener("SetTradeables", SetCategoriesBx);
			_Tradable.addEventListener("ImReady", SetCategoriesBx);
			_Tradable.addEventListener("ImReady", SetTreatBx);
			_Tradable.addEventListener("QueryResultReady", RetrieveQueryData);
			SetStkBx();
			//SetTreatBx();
			//_Tradable.addEventListener("SetIndexes", SetCategoriesBx);
			//_Tradable.addEventListener("SetStocks", SetStkBx);
			
			
			//_Tradable.addEventListener("StocksReady", SetStkBx);
			//_Tradable.addEventListener("CategoryStringReady", SetStkBx);
			

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
			var dp:DataProvider = new DataProvider(ExtractDictonaryContents(_Tradable.ReturnTreatments()));
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
			var i:int = temp.indexOf('"');
			if (e.target.value == "")
			{
				_Tradable.TREATMENT = "";
			}
			if (e.target.value != "")
			{
				_Tradable.TREATMENT = temp + "-";
			}
			treat_desc.y = 250;
			treat_desc.x = TwClip.x - 1200;
			treat_desc.autoSize = "left";
			treat_desc.text = _Tradable.ReturnTreatments()[e.target.value];
			TwClip.addChild(treat_desc);
			
		}

		//CATAGORIES
		function SetCategoriesBx(e:Event):void
		{			
			var categoriesBx:ComboBox = new ComboBox();
			var dp:DataProvider = new DataProvider(ExtractDictonaryContents(_Tradable.ReturnTradablesDatabase()));
			categoriesBx.y = 70;
			categoriesBx.x = TwClip.x;
			categoriesBx.dataProvider = dp;
			categoriesBx.width = 200;
			categoriesBx.prompt = "Please Select A Catagory";
			categoriesBx.addEventListener(Event.CHANGE, SetCategories);
			categoriesBx.addEventListener(Event.CHANGE, SetStocks)
			categoriesBx.addEventListener(Event.CHANGE, DisplayQuery);
			//categoriesBx.addEventListener(Event.CHANGE, SetStocks);
			TwClip.addChild(categoriesBx);
			
		}
		//Event Listener for the Database comboBox
		function SetCategories(e:Event):void
		{
			var temp:String = e.target.value;
			//SetStocks();
			var i:int = temp.indexOf('"');
			_Tradable.TRADABLES_DATABASE_STRING = e.target.value.toString();
			category = e.target.value.toString();
			tradables_desc.y = 100;
			tradables_desc.x = TwClip.x - 1200;
			tradables_desc.autoSize = "left";
			tradables_desc.wordWrap = true;
			tradables_desc.width = 500;
			tradables_desc.text = _Tradable.ReturnTradablesDatabase()[temp.toLocaleLowerCase()];
			TwClip.addChild(tradables_desc);
		
		}
		//STOCKLIST
		function SetStkBx():void
		{
			
			stkBx = new ComboBox();
			stkBx.y = 150;
			stkBx.x = TwClip.x;
			
			stkBx.width = 200;
			stkBx.prompt = "Please Select A Stock";
			stkBx.addEventListener(Event.CHANGE, StkBxHandler);
			stkBx.addEventListener(Event.CHANGE, DisplayQuery);
			
			TwClip.addChild(stkBx);
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
			
			
		}
		function UpdateDataProvider(e:Event):void{
			Sdp = new DataProvider(tempArray2);
		}
		//Event Listener for the Database comboBox
		function SetStocks(e:Event):void
		{
			catetory = e.target.value;
			var tempArray:Array = new Array();
			if(e.target.value =="STOCK"){
				tempArray = ExtractDictonaryContents(_Tradable.ReturnStock())
			}
			if(e.target.value =="COMMODITY"){
				tempArray = ExtractDictonaryContents(_Tradable.ReturnCommodity())
			}
			if(e.target.value =="BOND"){
				tempArray = ExtractDictonaryContents(_Tradable.ReturnBonds())
			}
			if(e.target.value =="CURRENCY"){
				tempArray = ExtractDictonaryContents(_Tradable.ReturnCurrencies())
			}
			if(e.target.value =="INDEX"){
				tempArray = ExtractDictonaryContents(_Tradable.ReturnIndex())
			}
			stkBx.dataProvider = new DataProvider(tempArray);
						
			//stk_desc.text = temp.substr(i+3, temp.length);
			TwClip.addChild(stkBx);
			TwClip.addChild(stk_desc);
			
		}
		function StkBxHandler(e:Event):void{
			var temp:String = e.target.value;
			var tempDict:Dictionary;
			//var i:int = temp.indexOf('"');
			_Tradable.STOCK_INDICATOR = temp;
			stk_desc.y = 175;
			stk_desc.x = TwClip.x - 1200;
			stk_desc.autoSize = "left";
			if(catetory =="STOCK"){
				tempDict = _Tradable.ReturnStock();
			}
			if(catetory =="COMMODITY"){
				tempDict = _Tradable.ReturnCommodity();
			}
			if(catetory =="BOND"){
				tempDict = _Tradable.ReturnBonds();
			}
			if(catetory =="CURRENCY"){
				tempDict = _Tradable.ReturnCurrencies();
			}
			if(catetory =="INDEX"){
				tempDict = _Tradable.ReturnIndex();
			}
			
			stk_desc.text = tempDict[e.target.value];
			
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
			queryStringText.text = _Tradable.UpdateQueryString();
		}
		
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
			startDate.x = TwClip.x + 10;
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
			from_Btn.x = 10 + TwClip.x;
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
			_Tradable.DAYSTOCALCULATE = treatDays.text;
		}
		function SetDaysToCalculate(e:Event):void
		{
			_Tradable.DAYSTOCALCULATE = numbDays.text;
		}

		function FromClickHandler(e:MouseEvent):void
		{
			_Tradable.STARTDATE_STRING = startDate.text;
			
			if (from_Btn.selected == true)
			{
				_Tradable.STARTDATE_STRING = "ALL";
			}
			

		}
		function ToClickHandler(e:MouseEvent):void
		{
			_Tradable.ENDDATE_STRING = endDate.text;
			if (to_Btn.selected == true)
			{
				_Tradable.ENDDATE_STRING = "NOW";
			}
		

		}
		function StartDate(e:Event):void
		{
			_Tradable.STARTDATE_STRING = startDate.text;
			
		}

		function EndDate(e:Event):void
		{
			_Tradable.ENDDATE_STRING = endDate.text;
			
		}

		function SubmitQuery(e:MouseEvent):void
		{
			trace(_Tradable.UpdateQueryString());

			_Tradable.SubmitQuery();
		}
		public function RetrieveQueryData(e:Event):void
		{

			qData = _Tradable.ReturnQueryData();
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