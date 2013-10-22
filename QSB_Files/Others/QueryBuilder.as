package QSB_Files
{
	import QSB_Files.Events.CustomEvent;
	import QSB_Files.URLFactory;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import fl.controls.ComboBox;

	public class QueryBuilder extends MovieClip
	{
		//*******PUBLIC STRING VARIABLES****************************
		public var queryString:String;
		public var TYPE:String = "";
		public var ENTITY:String = "";
		public var START:String = "";
		public var END:String = "";
		public var STOCK_INDICATOR:String = "";
		public var TREATMENT:String = "";
		public var DAYSTOCALCULATE:String = "";
		public var DATABASE:String = "";
		public var STARTDATE_STRING:String = "";
		public var ENDDATE_STRING:String = "";
		public var TREATMENTDAYS:String = "";
		public var _QUERYRESULT:String = "";
		//**********END PUBLIC STRING VARIABLES**********************
		
		
		//*******PRIVATE STRING VARIABLES****************************
		private var URLSTRING:String = "";
		private var stringData;
		//**********END PRIVATE STRING VARIABLES*********************


		//************ARRAY VARIABLES**************************
		public var _TYPE:Array = new Array("TBL","IND");
		public var _INDICATORS:Array;
		public var _DATABASES:Array;
		public var _TREATMENTS:Array;
		public var _STOCKLIST:Array;
		//************END ARRAY VARIABLES**********************
		private var urlDriver:URLFactory;
		public function QueryBuilder(url:String)
		{
			CreateDatabasesArray();
			this.addEventListener("DataBaseReady",CreateTreatmentsArray);
			this.addEventListener("TreatmentsReady",CreateIndicatorsArray);
			this.addEventListener("IndicatorsReady",CreateStockList);
			this.URLSTRING = url;
		}

		//Sets all the arrays
		public function SetArrays():void
		{
			CreateDatabasesArray();
		}


		//Queries for the list of Indicators available. Uses the IndicatorSetter handler for this task
		public function CreateIndicatorsArray(e:Event):void
		{
			var rand:String = (Math.random()*100000000).toString();
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=ind_list" + "&" + rand);
			urlDriver.addEventListener("dataReadyE", IndicatorSetter);
		}
		//Event handler for CreatIndicatorArray(), sets the _INDICATORS array
		function IndicatorSetter(e:Event)
		{
			var stringData:String = urlDriver.GetData();
			_INDICATORS = stringData.split('","');
		    _INDICATORS = stringData.split("\n");
			
			//trace(_INDICATORS);
			dispatchEvent(new Event("SetIndicators"));
			dispatchEvent(new Event("IndicatorsReady"));
			//UpdateQueryString()
		}


		//Queries for the list of Databases available. Uses the DatabaseSetter handler for this task
		public function CreateDatabasesArray():void
		{
			var rand:String = (Math.random()*100000000).toString();
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=dbs_list"  + "&" + rand);
			urlDriver.addEventListener("dataReadyE", DatabaseSetter);
			
			
			//UpdateQueryString()
		}
		//Event handler for CreateDataBaseArray(), sets the _DATABASES array
		function DatabaseSetter(e:Event)
		{
			var stringData:String = urlDriver.GetData();
			_DATABASES = stringData.split('","');
			_DATABASES = stringData.split("\n");
			dispatchEvent(new Event("SetDataBase"));
			dispatchEvent(new Event("DataBaseReady"));
			//UpdateQueryString();
		}

		///Queries for the list of Treatments available. Uses the TreatmentSetter handler for this task
		public function CreateTreatmentsArray(e:Event):void
		{
			var rand:String = (Math.random()*100000000).toString();
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=treat_list"  + "&" + rand);
			urlDriver.addEventListener("dataReadyE", TreatmentsSetter);
			//UpdateQueryString()
		}
		///Event handler for CreateTreatmentsArray(), sets the _TREATMENTS array
		function TreatmentsSetter(e:Event)
		{
			var stringData:String = urlDriver.GetData();
			_TREATMENTS = stringData.split('","');
			_TREATMENTS = stringData.split("\n")
			dispatchEvent(new Event("SetTreatments"));
			dispatchEvent(new Event("TreatmentsReady"));
		}
		

		//Queries the stock database for the a list of available 
		public function CreateStockList(e:Event):void{
			var rand:String = (Math.random()*100000000).toString();
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=stock_list&SS=&DBS=stock"  + "&" + rand);
			urlDriver.addEventListener("dataReadyE", StockSetter);
			//UpdateQueryString()
		}
		//Event handler for CreateStockList(), sets the _STOCKLIST array
		function StockSetter(e:Event)
		{
			
			var stringData:String = urlDriver.GetData();
			
			_STOCKLIST = stringData.split('","');
			_STOCKLIST = stringData.split("\n");
			dispatchEvent(new Event("SetStocks"));
			//dispatchEvent(new Event("TreatmentsReady"))
			//UpdateQueryString()
			//trace("these are the stocks" + this._STOCKLIST);
		}
		
		//Updates the Query string
		public function UpdateQueryString():String
		{
			if(TYPE == "TBL")
			{
			queryString = "TYPE=" + TYPE + "&ENTITY=" + STOCK_INDICATOR + "()" + "[" + TREATMENT + DAYSTOCALCULATE + "]{" + DATABASE + "}&START=" + STARTDATE_STRING + "&END=" + ENDDATE_STRING;
			}
			if(TYPE == "IND")
			{
			queryString = "TYPE=" + TYPE + "&ENTITY=" + ENTITY + "(" + TREATMENTDAYS + ")" + "[" + TREATMENT + DAYSTOCALCULATE + "]{" + DATABASE + "}&START=" + STARTDATE_STRING + "&END=" + ENDDATE_STRING;
			}
			
			return queryString;
		}
		public function SubmitQuery(){
			var rand:String = (Math.random()*100000000).toString();
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/Servletdd?" + UpdateQueryString() + "&" + rand);
			//urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=ind_list");
			urlDriver.addEventListener("dataReadyE", HandleQueryResult);
			
		}
		
		function HandleQueryResult(e:Event):void{
			var stringData:String = urlDriver.GetData();
			
			//trace(stringData);
			this._QUERYRESULT = stringData;
			//trace(e.data + "queryR");
			dispatchEvent(new Event("QueryResultReady"));
			dispatchEvent(new Event("QUERY_RESULT"));
			
			
		}
		public function ReturnQueryData():String{
			return this._QUERYRESULT;
		}
		public function ReturnIndicators():Array
		{
			return this._INDICATORS;
		}

		public function ReturnDatabases():Array
		{
			return this._DATABASES;
		}

		public function ReturnTreatments():Array
		{
			return this._TREATMENTS;
		}
		
		public function ReturnStock():Array
		{
			return this._STOCKLIST;
		}
		
		public function ReturnType():Array
		{
			return this._TYPE;
		}
		public function SetStartDate(text:String):void{
			this.STARTDATE_STRING = text;
		}
		public function SetEndDate(text:String):void{
			this.ENDDATE_STRING = text;
		}
		//public function set 

	}

}