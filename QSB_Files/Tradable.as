package QSB_Files
{

	import flash.display.MovieClip;

	import flash.events.Event;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	import fl.controls.TextInput;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.filters.*;
	import flash.utils.getDefinitionByName;
	import fl.controls.Label;
	import flash.text.AntiAliasType;
	import fl.events.SliderEvent;
	import com.yahoo.astra.fl.controls.AutoComplete;
	import QSB_Files.Events.CustomEvent;

	public class Tradable extends MovieClip
	{

		private var STRATEGY:Strategy;
		private var CONDITION_STRING:String;
		private var _TradableEntity:String;
		private var _Treatment:String;
		private var _Database:String;
		private var _MathOperator:String;
		private var _OHLCVOperator:String;
		private var _candleOperator:String;


		private var mathOpsParameters:Array;
		private var mathOpsParameters_String:String;
		private var treatmentsParameter:Array;
		private var treatmentsParameter_String:String;
		private var textDescription:TextField;
		private var indicatorInfoQuestion:MovieClip;
		private var databaseInfoQuestion:MovieClip;
		private var infoLabel:TextField;
		private var databaseComboBox:ComboBox;
		private var mathOpsComboBox:ComboBox;
		private var treatmentComboBox:ComboBox;
		private var ohlcv:ComboBox;
		private var sliderLabel:TextField;
		private var autoComplete:AutoComplete;
		public var finalParameterArray:Array;
		public var condition_xml:XML;
		public var leadParameter:Array;
		private var inTrade:Boolean;
		private var myFormat:TextFormat;
		private var qTextSprite:MovieClip;
		private var noTreatment:MovieClip;
		
		private var indicatorCB:ComboBox;
		private var myStage:MovieClip;
		private var isCandle:Boolean;
		private var candlePrameters:String;
		private var begin_monthCB:ComboBox;
		private var end_monthCB:ComboBox;
		private var begin_yearCB:ComboBox;
		private var end_yearCB:ComboBox;
		private var MonthsArray:Array;
		private var startDateMonth:String;
		private var startDateYear:String;
		private var endDateMonth:String;
		private var endDateYear:String;
		private var startDateFull:String;
		private var endDateFull:String;
		


		public function Tradable(stage:MovieClip)
		{
			candlePrameters = "";
			myStage = stage;
			startUpStrategy();
			setTextProperties();
			sliderLabel = new TextField();
			textDescription = new TextField();
			infoLabel = new TextField  ;
			_TradableEntity = "";
			_Treatment = "";
			_Database = "";
			_MathOperator = "";
			databaseComboBox = new ComboBox();
			treatmentComboBox = new ComboBox();
			mathOpsComboBox = new ComboBox();
			ohlcv = new ComboBox();
			qTextSprite = new MovieClip();
			noTreatment = new MovieClip();
		
			treatmentsParameter = new Array();
			infoLabel.alpha = 0;
			addChild(infoLabel);


			
			DrawTextBox(new TextField(), 25, 115, "On which database is it located? ");
			DrawTextBox(new TextField(), -20, 185, "Which one on that database ?");
			autoComplete = new AutoComplete();
			addChild(autoComplete);
			autoComplete.width = 200;
			autoComplete.move(140, 185);

			addEventListeners();
			mathOpsParameters = new Array();
			treatmentsParameter = new Array();

			mathOpsParameters_String = new String();
			isCandle = false;
			setDateBoxes();
			
		}
		
		function diI(event:Event):void{
			////trace(this.displayInfo());
		}
		function getTreatmentParameter():String{
			var temp:String = "";
			if(treatmentsParameter.length > 0){
				if(treatmentsParameter[0].text == ""){
				   	temp = "";
				   }
				   if(!treatmentsParameter[0].text == ""){
				  	 temp =  "-" + this.treatmentsParameter[0].text;
				   }
				
			}
			if(treatmentsParameter.length == 0){
				temp =  "";
			}
			return temp;
		}
		function setTextProperties():void{
			myFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
		}
		public function displayInfo():String
		{
			/*if(_Treatment == ""){
				_Treatment = ""
			}*/
			
			var display:String = "Using " + _Database + " with Entity " + _TradableEntity + " " + _MathOperator + "(" + concactParameters(mathOpsParameters) + ")" + " using Treatment: " + "(" + _Treatment + "-" + concactParameters(treatmentsParameter) + ")";


			//trace(setXML());


			return display;


		}
		
		function setXML():XML
		{

			var tPara:String;
			var iPara:String;
			if (treatmentsParameter[0] != undefined)
			{


				////////trace(treatmentsParameter[0].text + "here is the treat")
				if (treatmentsParameter[0].text != "")
				{
					//////trace(treatmentsParameter.text + "This is the cond");
					tPara = "-" + concactParameters(treatmentsParameter);
				}
			}
			else
			{
				tPara = concactParameters(treatmentsParameter);
			}




			var condEntity = _TradableEntity + "()[" + _Treatment + this.getTreatmentParameter() + "]{" + _Database + "}";
			condition_xml = new XML(<Condition></Condition>);
			var myArray:Array =  new Array();
			if(!isCandle){
				
				myArray.push({xmlNodeName: "CondEntity", value: condEntity});
				myArray.push({xmlNodeName: "CondOperator", value: _MathOperator});
				myArray.push({xmlNodeName: "Parameter", value: concactParameters(mathOpsParameters)});
				myArray.push({xmlNodeName: "BetStruct", value: "0:0"});
			}
			if(isCandle){
			   
				myArray.push({xmlNodeName: "CondEntity", value: condEntity});
				myArray.push({xmlNodeName: "CondOperator", value: _candleOperator});
				myArray.push({xmlNodeName: "Parameter", value: candlePrameters});
				myArray.push({xmlNodeName: "BetStruct", value: "0:0"});
			   
			   }
			for each (var item:Object in myArray)
			{
				condition_xml[item.xmlNodeName] = item.value.toString();
			}
			condition_xml.child("CondEntity"). @ ["type"] = this.ohlcv.selectedItem.value;
			dispatchEvent(new CustomEvent("setXML", condition_xml));
			
			return condition_xml;
		}
		function concactParameters(array:Array):String
		{
			var temp:String = "";
			if(array[0] != undefined){
				if(array[0].text != "")
				{
					for each (var inputField:Object in array)
					{
						temp +=  inputField.text + ",";
					}
						temp = temp.substring(temp.length - 1, -  temp.length);
				
						
				}
				if(array[0].text == "")
				{
					temp = "0";
					
				}
			}
			return temp;
		}
		function addEventListeners():void
		{
			databaseComboBox.addEventListener(Event.CHANGE, databaseChange);
			mathOpsComboBox.addEventListener(Event.CHANGE, mathOpsChange);
			treatmentComboBox.addEventListener(Event.CHANGE, treatmentChange);
			

		}

		function databaseChange(event:Event):void
		{
			var database:Object = event.target.selectedItem;
			dispatchEvent(new CustomEvent("databaseSelected", database));
			_Database = database.name;
		}
		function mathOpsChange(event:Event):void
		{
			var mathOp:Object = event.target.selectedItem;
			dispatchEvent(new CustomEvent("mathOpsSelected", mathOp));
			_MathOperator = mathOp.name;
		}
		function treatmentChange(event:Event):void
		{
			var treatment:Object = event.target.selectedItem;
			dispatchEvent(new CustomEvent("treatmentSelected", treatment));
			_Treatment = treatment.name;
		}
		function tradableSelected(event:Event):void
		{
			var tradableEntity:Object = event.target.selectedItem;
			
			_TradableEntity = tradableEntity.name;
			dispatchEvent(new CustomEvent("tradableSelected", tradableEntity));
		}
		function startUpStrategy():void
		{
			STRATEGY = new Strategy();
			STRATEGY.addEventListener("StrategyReady", startUp);

		}
		function startUp(event:Event):void
		{
			var treatQ:TextField = new TextField();
			treatQ.defaultTextFormat = myFormat;
			
			treatQ.text = "Click here to add a Treatment (optional)";
			treatQ.autoSize = "left"
			treatQ.x = -25;
			treatQ.y = 285;
			
			qTextSprite.addChild(treatQ);
			qTextSprite.mouseChildren = false;
			qTextSprite.buttonMode = true;
			qTextSprite.addEventListener(MouseEvent.CLICK, addTreatment);
			addChild(qTextSprite);
			
			/*createDataBox("Treatments", -65, 165, "Select Treatment", STRATEGY.GetTreatments(), treatmentsParameter = new Array(), treatmentComboBox, treatmentsParameter_String, _Indicator);
			removeChild(treatmentComboBox);*/
			var noTreat:TextField = new TextField();
			var noTeatFormat:TextFormat = myFormat;
			noTeatFormat.size = 13;
			noTeatFormat.bold = true
			noTreat.defaultTextFormat = noTeatFormat;
			noTreat.text = "x";
			//noTreat.textS
			noTreat.autoSize = "left"
			noTreat.x = 15;
			noTreat.y = 280;
			/*optTreatParamerer.move(175, 165)
			optTreatParamerer.label = "(optional Treatment Parameter?)";
			optTreatParamerer.width = 200*/
			
			with(noTreatment){
				addChild(noTreat);
				mouseChildren = false;
				buttonMode = true;
			}
			//_TradableEntity
			createDataBox("Database", 150, 115, "Select Database", STRATEGY.GetDatabase(), new Array(), databaseComboBox, new String(), _Database);
			
			
			//ohlcv.removeEventListener(Event.CHANGE, changeHandler);
			databaseComboBox.width = 125;
			databaseComboBox.dropdownWidth = 115;


		}
		
		function disableForCandle():void{
				qTextSprite.enabled = false;
				qTextSprite.alpha = 0.4;
				qTextSprite.removeEventListener(MouseEvent.CLICK, addTreatment);
				noTreatment.enabled = false;
				treatmentComboBox.enabled = false;
				mathOpsComboBox.enabled = false;
		}
		function enable():void{
			qTextSprite.enabled = true;
				qTextSprite.alpha = 1;
				qTextSprite.addEventListener(MouseEvent.CLICK, addTreatment);
				noTreatment.enabled = true;
				treatmentComboBox.enabled = true;
				mathOpsComboBox.enabled = true;
		}
		function createDataBox(_name:String, _xLoca:Number, _yLoca:Number,
		_prompt:String, _data:Array, _paramenters:Array,
		_control:ComboBox, parameterString:String, selection:String):void
		{
			var myFormatBeige:TextFormat = new TextFormat();
			myFormatBeige.font = "Arial";
			myFormatBeige.size = 8;
			myFormatBeige.color = 0x000000;
			_control.name = _name;
			_control.dropdownWidth = 160;
			_control.width = 175;
			_control.move(_xLoca, _yLoca);
			_control.prompt = _prompt;
			_control.dataProvider = new DataProvider(_data);//put the array here
			_control.setStyle("backgroundColor","0x330000");
			_control.labelField = "name";
			addChild(_control);
			if (_control.name != "OHLCV")
			{
				_control.addEventListener(Event.CHANGE,function(event:Event){changeHandler(event,
				_paramenters, _control, parameterString, selection)});
			}



			_control.alpha = 1;

		}
		function addTreatment(event:Event):void{
			//addChild(optTreatParamerer);
			treatmentComboBox = new ComboBox();
			createDataBox("Treatments", 25, 285, "Select Treatment", STRATEGY.GetTreatments(), treatmentsParameter, treatmentComboBox, treatmentsParameter_String = "", _Treatment);
			treatmentComboBox.addEventListener(Event.CHANGE, treatmentChange);
			//addChild(treatmentComboBox);
			addChild(noTreatment);
			noTreatment.addEventListener(MouseEvent.CLICK, subtractTreatment);
			removeChild(qTextSprite);
		}
		function subtractTreatment(event:Event):void{
			_Treatment = "";
			addChild(qTextSprite)
			removeChild(treatmentComboBox);
			removeChild(noTreatment);
			if(treatmentsParameter.length > 0){
				if(treatmentsParameter[0].stage){
					removeChild(treatmentsParameter[0]);
					treatmentsParameter.splice(0);
				}
			}
		}
		function changeHandler(event:Event, parameterArray:Array, object:Object, parameterString:String, selection:String):void
		{

			var t:Object = event.target.selectedItem;
			selection = t.name;
			//@//////trace(object.name)
			if (object.name == "Database")
			{
				setUnderLyingEntities(selection.toUpperCase());
			}

			drawParameterFields(t.parameters, parameterArray,t.paramDescriptions, object, parameterString);
			setLabel(t);
			checkHasDatabase(t);

		}
		function setUnderLyingEntities(entityDatabase:String):void
		{

			autoComplete.autoFillEnabled = true;
			autoComplete.text = "";
			autoComplete.dropdown.addEventListener(Event.CHANGE, handleAutoComplete);
			autoComplete.labelField = "description";

			if (entityDatabase =="STOCK")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetStocks());
			}
			if (entityDatabase =="COMMODITY")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetCommodities());

			}
			if (entityDatabase =="BOND")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetBonds());

			}
			if (entityDatabase =="CURRENCY")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetCurrencies());

			}
			if (entityDatabase =="INDEX")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetIndex());


			}
			if (entityDatabase =="ETFS")
			{
				autoComplete.dataProvider = new DataProvider(STRATEGY.GetEtfs());
			}

		}
		function handleAutoComplete(event:Event):void
		{
			_TradableEntity = event.target.getItemAt(0).name;
			setDates(this._Database,_TradableEntity);
			dispatchEvent(new CustomEvent("tradableSelected", _TradableEntity));
			
		}
		function combineStockLabels(_stockArray:Array):Array
		{
			var temp:Array = new Array();
			for each (var item:Object in _stockArray)
			{
				temp.push(item.name +" - "+ item.description);
			}
			return temp;
		}
		function setLabel(obj:Object):void
		{

			infoLabel.autoSize = "left";
			infoLabel.x = 450;
			infoLabel.y = 250;

			infoLabel.textColor = 0xFFFFFF;
			infoLabel.text = obj.description;
			infoLabel.wordWrap = true;
			infoLabel.background = true;
			infoLabel.backgroundColor = 0x000000;
			infoLabel.width = 350;
			infoLabel.antiAliasType = AntiAliasType.ADVANCED;
			var tw:Tween = new
			Tween(infoLabel,"alpha",None.easeNone,infoLabel.alpha,1,1,true);
		}

		function checkHasDatabase(obj:Object):void
		{
			var gh:String = obj.database.toString();

			if (gh.length == 5)
			{
				createDataBox("Database", 300, 100, "Select Database", STRATEGY.GetDatabase(), new Array(), databaseComboBox, new String(), _Database);
			}
			if (gh.length == 6)
			{
				databaseComboBox.alpha = 0;
			}
		}



		/**
		* Draws inputText fields. And adds them to an array
		*
		* @param numFields. The number of fields to draw
		* @param fieldArray The the array in which to add the textFields
		*
		* returns nothing.
		*/
		function drawParameterFields(numFields:String, fieldArray:Array,
		parameterDescriptions:Array, object:Object, parameterString:String):void
		{
			leadParameter  = new Array();
			var leadParaNumber:String = "G";
			if (numFields.indexOf(":"))
			{
				leadParaNumber = numFields.substr(2,1);
				numFields = numFields.substr(0,1);
			}
			//if there are inputFields on the screen already, remove them.
			if (fieldArray.length > 0)
			{
				for (var i:int; i < fieldArray.length; i++)
				{
					removeChild(fieldArray[i]);
				}
			}
			//clear the array
			fieldArray.splice(0, fieldArray.length);
			//create and add properties to the fields;
			for (var i:int = 0; i < Number(numFields); i++)
			{


				//initialize the input field for the parameter
				var operatorInputField:TextInput = new TextInput();

				var tf:TextFormat = new TextFormat();
				tf.color = 0x000000;
				tf.font = "Verdana";
				tf.size = 12;
				tf.align = "center";
				tf.italic = true;
				operatorInputField.setStyle("textFormat", tf);

				operatorInputField.name = parameterDescriptions[i];

				operatorInputField.width = 40;
				//operatorInputField.restrict = ;
				operatorInputField.maxChars = 4;
				operatorInputField.y = object.y;
				operatorInputField.x = object.x + (i * 65) + 200;
				fieldArray.push(operatorInputField);
				if (i.toString() == leadParaNumber)
				{
					leadParameter.push(operatorInputField);
				}
				operatorInputField.addEventListener(MouseEvent.MOUSE_OVER, Description);
				operatorInputField.addEventListener(MouseEvent.MOUSE_OUT, RemoveDescription);
				//////trace(leadParaNumber);
				addChild(operatorInputField);

			}
			//add the event listener to each text field
			for (var fArray:Number = 0; fArray < fieldArray.length; fArray++)
			{
				fieldArray[fArray].addEventListener(Event.CHANGE,function(event:Event){operatorInputFieldtrace(event, fieldArray, parameterString)});

			}

		}
		function Description(e:Event):void
		{
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = "arial";
			textDescription.defaultTextFormat = myFormat;
			textDescription.x = mouseX;
			textDescription.y = mouseY + 45;
			textDescription.height = 20;
			textDescription.autoSize = "left";
			textDescription.text = e.currentTarget.name;
			//textDescription.font = "aral"
			textDescription.background = true;
			textDescription.alpha = 0;
			var tween:Tween = new Tween(textDescription,
			                       "alpha",None.easeNone,0,1,1,true);

			textDescription.border = true;
			addChildAt(textDescription, numChildren - 1);
			setChildIndex(textDescription, numChildren - 1);

			//(textDescription, this.numChildren - 1)

		}
		function DrawTextBox(myTextField:TextField, _xLoca:Number,
		_yLoca:Number, _name:String):void
		{

			addChild(myTextField);
			myTextField.autoSize = "center";
			myTextField.x = _xLoca;
			myTextField.y = _yLoca;
			myTextField.selectable = false;
			myTextField.text = _name;
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 30;
			myFormat.italic = true
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			myTextField.setTextFormat(myFormat);

		}
		function RemoveDescription(e:Event):void
		{
			removeChild(textDescription);
		}

		function operatorInputFieldtrace(event:Event, parameterArray:Array, parameterArray_String:String):void
		{
			//THIS IS WHERE THE VALUES FOR MATH OPERS COME FROM
			for (var object:Object in parameterArray)
			{
				parameterArray_String +=  parameterArray[object].text + ",";
			}
		}
		
		function PlaceImage(_className:String, _function:Function):MovieClip
		{
			var _container:MovieClip = new MovieClip();
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());
			_container.name = _className;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.addEventListener(MouseEvent.CLICK, _function);
			return _container;
		}
		function closeInfo(event:Event):void
		{
			var object:Object = event.target as Object;
			var tw:Tween = new
			Tween(infoLabel,"alpha",None.easeNone,infoLabel.alpha,0,1,true);

			//removeChild(infoLabel)

		}
		function setDates(database:String, entity:String):void{
			var urlDriver:URLFactory = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=daterange&DBS="+ database + "&ENTITY=" + entity);
			urlDriver.addEventListener(CustomEvent.QUERYREADY, dateHandler);
		}
		function dateHandler(e:CustomEvent)
		{
			
			//this.startDateFull = "ALL";
			//this.endDateFull = "NOW";
			var dateD:String = e.data;
			var dateData:Array = dateD.split(",");
			var startYearDate:String = dateData[0].substr(0,4);
			var endYearDate:String = dateData[1].substr(0,4);
			var startMonth:String = dateData[0].substr(5,6); 
			var endMonth:String = dateData[1].substr(5,5);
			begin_yearCB.dataProvider = new DataProvider(setStartYears(Number(startYearDate), Number(endYearDate)));
			end_yearCB.dataProvider = new DataProvider(setEndYears(Number(startYearDate), Number(endYearDate)));
			end_monthCB.selectedIndex = Number(endMonth) - 1;
			begin_monthCB.selectedIndex = Number(startMonth) - 1;
			begin_yearCB.selectedIndex = 0;
			end_yearCB.selectedIndex = 0;
			startDateFull = startYearDate + "-" + startMonth + "-" + "01"
			endDateFull = endYearDate + "-" + endMonth + "-" + "01"			
		}
		
	
		function setDateBoxes():void{
			MonthsArray = new Array("January", "February", "March", "April",
			"May", "June", "July", "August", "September", "October", "November",
			"December");

			begin_monthCB = new ComboBox();
			begin_monthCB.prompt = "Start Month";
			begin_monthCB.x = -200;
			begin_monthCB.y = 350;
			addChild(begin_monthCB);
			begin_monthCB.dataProvider = new DataProvider(MonthsArray);
			begin_monthCB.addEventListener(Event.CHANGE, SetBeginMonth);
			//begin_monthCB.filters = [fltDropShadow];

			end_monthCB = new ComboBox();
			end_monthCB.prompt = "End Month";
			end_monthCB.x = 130;
			end_monthCB.y = 350;
			end_monthCB.dataProvider = new DataProvider(MonthsArray);
			end_monthCB.addEventListener(Event.CHANGE, SetEndMonth);
			addChild(end_monthCB);

			begin_yearCB = new ComboBox();
			begin_yearCB.prompt = "Start Year";
			begin_yearCB.x = -85;
			begin_yearCB.y = 350;
			begin_yearCB.dataProvider = new DataProvider(setStartYears(1990, 2011));
			begin_yearCB.addEventListener(Event.CHANGE, SetStartYear);
			addChild(begin_yearCB);

			end_yearCB = new ComboBox();
			end_yearCB.prompt = "End Year";
			end_yearCB.x = 250;
			end_yearCB.y = 350;
			addChild(end_yearCB);
			end_yearCB.dataProvider = new DataProvider(setStartYears(1975, 2011));
			end_yearCB.addEventListener(Event.CHANGE, SetEndYear);
		}
		
		function SetBeginMonth(e:Event):void
		{
			startDateMonth = (e.currentTarget.selectedIndex + 1).toString();
		}
		function SetEndMonth(e:Event):void
		{
			endDateMonth = (e.currentTarget.selectedIndex + 1).toString();
		}
		function SetStartYear(e:Event):void
		{
			startDateYear = e.currentTarget.value;
			////trace(dataBaseValue);
		}
		function SetEndYear(e:Event):void
		{
			endDateYear = e.currentTarget.value;
			////trace(endDateYear);
		}
		
		function setEndYears(startYear:Number, endYear:Number):Array
		{
			var temp:Array = new Array();
			for (var years:Number = endYear; years > startYear - 1; years--)
			{
				temp.push(years.toString());
			}

			return temp;
		}
		function setStartYears(startYear:Number, endYear:Number):Array
		{
			var temp:Array = new Array();
			for (var years:Number = startYear; years < endYear + 1; years++)
			{
				temp.push(years.toString());
			}

			return temp;
		}
		
	}

}