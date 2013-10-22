package QSB_Files 
{
	import QSB_Files.Events.CustomEvent;
	import QSB_Files.URLFactory;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.display.MovieClip;
   import flash.events.Event;
   //import flash.sampler.Sample;

   public class URLFactory extends MovieClip {

      public var loader:URLLoader;
      public var textData:String;
      public var dataArray:Array;
	  
   	  /**
	  	Constructor. At creation, sets loader and gives it an eventListener
		@param url The address for the url request
	  */
      public function URLFactory(url:String) {
         var rand:String = (Math.random()*100000000).toString();
		 loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE, HandleComplete);
         loader.load(new URLRequest(url));
		 //loader.load(new URLRequest(url + "?" + rand));
		 
      }
      /**
	  	EventListner. Sets the textData to the data of the URLLoader and calls SetData() to store
		the date into the variable
	  */
      function HandleComplete(e:Event):void{
         textData = loader.data;
         SetData();
		//dispatchEvent(new Event("dataReadyE"));
      }
      /**
	  	Helper function. Sets the textData variable
	  */
      function SetData():void{
		  
		  textData = loader.data;
		  //trace(textData);
		  dispatchEvent(new CustomEvent(CustomEvent.QUERYREADY, textData));
		  dispatchEvent(new Event("dataReadyE"));
      }
      
      /**
	  	Returns the value of textData
		@return the value of textData
	  */
      public function GetData():String{
         
         return textData;
         
      }
   }
}