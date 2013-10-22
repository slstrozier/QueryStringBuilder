package QSB_Files
{
	import QSB_Files.Events.CustomEvent;
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
	import flash.display.Sprite;
	import fl.controls.CheckBox;

	public class Indicator extends MovieClip
	{

		private var STRATEGY:Strategy;
		private var CONDITION_STRING:String;
		private var indicatorOper:String;
		private var _Indicator:String;
		private var _Treatment:String;
		private var _Database:String;
		private var _MathOperator:String;

		private var indicatorParameters:Array;
		private var indicatorParameters_String:String;
		private var mathOpsParameters:Array;
		private var mathOpsParameters_String:String;
		private var treatmentsParameter:Array;
		private var treatmentsParameter_String:String;
		private var textDescription:TextField;
		private var indicatorInfoQuestion:MovieClip;
		private var databaseInfoQuestion:MovieClip;
		private var infoLabel:TextField;
		private var databaseComboBox:ComboBox;
		private var treatmentComboBox:ComboBox;
		private var mathOperatorComboBox:ComboBox;
		private var indicatorComboBox:ComboBox;
		private var sliderLabel:TextField;
		private var onText:TextField;
		public var condition_xml:XML;
		var leadParameter:Array;
		private var inTrade:Boolean;
		private var myFormat:TextFormat;
		private var qTextSprite:MovieClip;
		private var noTreatment:MovieClip;
		private var optTreatParamerer:CheckBox;
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
		private var dataBaseText:TextField;
		
		public function Indicator(stage:MovieClip)
		{
			trace("this is the indicator")
			inTrade = false;
			startUpStrategy();
			sliderLabel = new TextField();
			textDescription = new TextField();
			infoLabel = new TextField  ;
			databaseComboBox = new ComboBox();
			treatmentComboBox = new ComboBox();
			mathOperatorComboBox = new ComboBox();
			indicatorComboBox = new ComboBox();
			qTextSprite = new MovieClip();
			noTreatment = new MovieClip();
			treatmentsParameter = new Array();
			optTreatParamerer = new CheckBox();
			_Indicator = "";
		    _Treatment = "";
		    _Database = "";
		    _MathOperator = "";
			addChild(databaseComboBox);
			databaseComboBox.alpha = 0;
			infoLabel.alpha = 0;
			addChild(infoLabel);

			DrawTextBox(dataBaseText = new TextField(), 180, 115, "This Indicator has a Database, Please Select one")
			dataBaseText.alpha = 0;
			dataBaseText.y = 5000;
			//addChild(indicatorInfoQuestion = PlaceImage("infoQuestion.png", closeInfo));
			/*indicatorInfoQuestion.scaleX = 0.1;
			indicatorInfoQuestion.scaleY = 0.1;
			indicatorInfoQuestion.y = 165;
			indicatorInfoQuestion.x = -50;*/
			
			DrawTextBox(onText = new TextField(), -150, 115, "Which Indicator? ");
			
			DrawTextBox(new TextField(), -130, 215, "Select an argument");
			onText.alpha = 0;
			addEventListeners();
			setTextProperties();
			setDateBoxes();
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
			var display:String = "If:  " + _Indicator + getIndicatorParameter() + "With Treatment "+ _Treatment + getTreatmentParameter() + " on Database: " + _Database + "; is " + _MathOperator + "(" + concactParameters(mathOpsParameters) + ")";
			setXML();
			
			return display;
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
		function getIndicatorParameter():String{
			var temp:String = "";
			if(indicatorParameters.length > 0){
				temp =  "(" + this.indicatorParameters[0].text + ")";
			}
			if(indicatorParameters.length == 0){
				temp =  "()";
			}
			return temp;
		}
		function setXML():XML
		{
			var condEntity:String;
			var tPara:String = "";
			var iPara:String = "";
			
			if (treatmentsParameter.length > 0)
			{
				////////trace(treatmentsParameter[0].text + "here is the treat")
				if (treatmentsParameter[0].text != "")
				{
					//////trace(treatmentsParameter.text + "This is the cond");
					tPara = concactParameters(treatmentsParameter);
				}
			}
			else
			{
				tPara = concactParameters(treatmentsParameter);
			}
			if (indicatorParameters[0] != undefined)
			{


		
				if (indicatorParameters[0].text != "")
				{
					
					iPara =  indicatorParameters[0].text;
				}
				if (indicatorParameters[0].text == "")
				{
					
					iPara =  "";
				}
			}
			else
			{
				iPara = concactParameters(indicatorParameters);
			}
				
			var condEntity =  _Indicator + "(" + iPara + ")" + "[" +_Treatment + getTreatmentParameter()+"]{"+_Database+"}"
			condition_xml = new XML(<Condition/>);
			
			var myArray:Array =  new Array();
			myArray.push({xmlNodeName: "CondEntity", value: condEntity});
			myArray.push({xmlNodeName: "CondOperator", value: _MathOperator});
			myArray.push({xmlNodeName: "Parameter", value: concactParameters(mathOpsParameters)});
			myArray.push({xmlNodeName: "BetStruct", value: "0:0"});
			

			for each (var item:Object in myArray)
			{
				condition_xml[item.xmlNodeName] = item.value.toString();
			}
			condition_xml.child("CondEntity"). @ ["type"] = "ind";
			dispatchEvent(new CustomEvent("setXML", condition_xml));
			return condition_xml;
		}
		function concactParameters(array:Array):String
		{
			
			var temp:String = "";
			for each (var inputField:Object in array)
			{
				temp +=  inputField.text + ",";
			}
			temp = temp.substring(temp.length - 1, -  temp.length);
			return temp;
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
			treatQ.x = -115;
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
			noTreat.x = -77;
			noTreat.y = 280;
			/*optTreatParamerer.move(175, 165)
			optTreatParamerer.label = "(optional Treatment Parameter?)";
			optTreatParamerer.width = 200*/
			
			with(noTreatment){
				addChild(noTreat);
				mouseChildren = false;
				buttonMode = true;
			}
			/*noTreatment.addChild(noTreat);
			noTreatment.mouseChildren = false;
			noTreatment.buttonMode = true;*/
			
			createDataBox("Indicators", -65, 115, "Select an Indicator" ,STRATEGY.GetIndicators(), indicatorParameters = new Array(), indicatorComboBox, indicatorParameters_String, _Indicator);
			createDataBox("Math Operators", -65, 215, "Select a Math Operator", STRATEGY.GetMathOps(), mathOpsParameters = new Array(), mathOperatorComboBox, mathOpsParameters_String, _MathOperator);
			
			
				
		}
		function addTreatment(event:Event):void{
			//addChild(optTreatParamerer);
			treatmentComboBox = new ComboBox();
			createDataBox("Treatments", -65, 285, "Select Treatment", STRATEGY.GetTreatments(), treatmentsParameter = new Array(), treatmentComboBox, treatmentsParameter_String,_Treatment );
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
		function addEventListeners():void
		{
			databaseComboBox.addEventListener(Event.CHANGE, databaseChange);
			mathOperatorComboBox.addEventListener(Event.CHANGE, mathOpsChange);
			treatmentComboBox.addEventListener(Event.CHANGE, treatmentChange);
			indicatorComboBox.addEventListener(Event.CHANGE, indicatorChange);
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
			////trace(treatment);
			_Treatment = treatment.name;
		}
		function indicatorChange(event:Event):void
		{
			var indicator:Object = event.target.selectedItem;
			////trace(indicator);
			
			_Indicator = indicator.name;
			dispatchEvent(new CustomEvent("indicatorSelected", _Indicator));
		}
		function createDataBox(_name:String, _xLoca:Number, _yLoca:Number,
		_prompt:String, _data:Array, _paramenters:Array,
		_control:ComboBox, parameterString:String, selection:String):void
		{
			var myFormatBeige:TextFormat = new TextFormat();
			myFormatBeige.font = "Arial";
			myFormatBeige.size = 8;
			myFormatBeige.color = 0x000000;

			_control.dropdownWidth = 160;
			_control.width = 175;
			_control.move(_xLoca, _yLoca);
			_control.prompt = _prompt;
			_control.dataProvider = new DataProvider(_data);//put the array here
			_control.setStyle("backgroundColor","0x330000");
			_control.labelField = "name";

			_control.addEventListener(Event.CHANGE,function(event:Event){changeHandler(event,
			_paramenters, _control, parameterString, selection)});

			_control.alpha = 1;
			addChild(_control);
		}

		function changeHandler(event:Event, parameterArray:Array, object:Object, parameterString:String, selection:String):void
		{
			var t:Object = event.target.selectedItem;
			selection = t.name;
			
			drawParameterFields(t.parameters, parameterArray,t.paramDescriptions, object, parameterString);
			setLabel(t);
			checkHasDatabase(t);

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
			
			if (gh.length == 4)
			{
				createDataBox("Database", 125, 165, "Database", STRATEGY.GetINDDatabase(), new Array(), databaseComboBox, new String(), _Database);
				dataBaseText.alpha = 1;
				dataBaseText.y = 165;
				dataBaseText.x = -180;
				
			}
			if (gh.length == 5)
			{
				
				_Database = "";
				databaseComboBox.alpha = 0;
				onText.alpha = 0;
				dataBaseText.alpha = 0;
				dataBaseText.y = 200;
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
			if(numFields.indexOf(":")){
				leadParaNumber = numFields.substr(2,1)
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
			//numFields = "7";
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
				//operatorInputField.restrict = "0-9";
				operatorInputField.maxChars = 4;
				operatorInputField.y = object.y;
				operatorInputField.x = object.x + (i * 65) + 200;
				operatorInputField.addEventListener(Event.CHANGE,function(event:Event){operatorInputFieldTrace(event, fieldArray, parameterString)});
				operatorInputField.addEventListener(MouseEvent.MOUSE_OVER, Description);
				operatorInputField.addEventListener(MouseEvent.MOUSE_OUT, RemoveDescription);

				
				fieldArray.push(operatorInputField);
				if(i.toString() == leadParaNumber){
					leadParameter.push(operatorInputField);
				}
				addChild(operatorInputField);
			}
		}

		function Description(e:Event):void
		{
			var myFormat:TextFormat = new TextFormat();
			myFormat.font = "arial";
			textDescription.defaultTextFormat = myFormat;
			textDescription.x = mouseX;
			textDescription.y = mouseY + 25;
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
			myFormat.italic = true;
			var header_font = new HeaderFont;
			myFormat.size = 15;
			myFormat.font = header_font.fontName;
			myTextField.setTextFormat(myFormat);

		}
		function RemoveDescription(e:Event):void
		{
			removeChild(textDescription);
		}

		function operatorInputFieldTrace(event:Event, parameterArray:Array, parameterArray_String:String):void
		{

			//THIS IS WHERE THE VALUES FOR MATH OPERS COME FROM
			var parameterArray_String:String = "";
			for (var object:Object in parameterArray)
			{
				parameterArray_String +=  parameterArray[object].text + ",";
			}
			parameterArray_String = parameterArray_String.substring(parameterArray_String.length - 1, -  parameterArray_String.length);

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
			begin_monthCB.x = -300;
			begin_monthCB.y = 350;
			addChild(begin_monthCB);
			begin_monthCB.dataProvider = new DataProvider(MonthsArray);
			begin_monthCB.addEventListener(Event.CHANGE, SetBeginMonth);
			//begin_monthCB.filters = [fltDropShadow];

			end_monthCB = new ComboBox();
			end_monthCB.prompt = "End Month";
			end_monthCB.x = 30;
			end_monthCB.y = 350;
			end_monthCB.dataProvider = new DataProvider(MonthsArray);
			end_monthCB.addEventListener(Event.CHANGE, SetEndMonth);
			addChild(end_monthCB);

			begin_yearCB = new ComboBox();
			begin_yearCB.prompt = "Start Year";
			begin_yearCB.x = -185;
			begin_yearCB.y = 350;
			begin_yearCB.dataProvider = new DataProvider(setStartYears(1950, 2011));
			begin_yearCB.addEventListener(Event.CHANGE, SetStartYear);
			addChild(begin_yearCB);

			end_yearCB = new ComboBox();
			end_yearCB.prompt = "End Year";
			end_yearCB.x = 150;
			end_yearCB.y = 350;
			addChild(end_yearCB);
			end_yearCB.dataProvider = new DataProvider(setEndYears(1950, 2011));
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