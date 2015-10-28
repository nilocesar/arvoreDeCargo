package com.includes
{
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	
	public class globalVars
	{
		//=============================================================
		// VARIABLES
		//=============================================================
		
		// URL
		public var urlActual:String;
		
		private var url:String;
		
		private var urlLocal:String = "";
		private var urlWeb:String = "swf/";

		// CONTAINER
		private var container:Array = new Array();
		private var _color:Dictionary  = new Dictionary();
		
		//
		private function setVariables()
		{
			// MAIN
			container[ "geral_mainPath" ] = urlLocal + "main.swf";
			
			//PATH
			container[ "PATH" ] = (ExternalInterface.call("window.location.href.toString")) ? "" : "../";
			
			//SCORM
			container[ "config" ] = {
										suspendData: "*",
										hay:"*",
										cargo: "8141",
										configPath: "../json/config.json",
										intro: 1
									}
			
			//COLOR
			_color["administrativo"] = "0x5A4C40";
			_color["comercial"] = "0xFF8200";
			_color["industrial"] = "0x00A5DF";
			_color["marketing"] = "0xFFEB00";
			_color["rh"] = "0xD0006F";
			_color["tecnico"] = "0x8FAD15";
			
			//
			container[ "departamentos" ] = [ "administrativo", "comercial", "industrial", "marketing", "rh", "tecnico"  ];
			
			//
			container[ "linkWeber" ] = "http://portalng.saint-gobain.com/pt/web/industrial-mortars-brazil/uniweber";
			container[ "emailWeber" ] = "mailto:weberbr.trilhas.carreira@saint-gobain.com";
			
			//http://extranetsp.affero.com.br/extranet/links/97FB826301FB77B08Abin/index.html?cargo=4112&intro=1&cargo1=586_3&cargo2=0&cargo3=0&hay=0
		}

		//=============================================================
		// PUBLIC FUNCTIONS
		//=============================================================
		
		//--------------------------------------
		// PUBLIC GET VALUES
		//--------------------------------------
		
		public function get( valor )
		{
			return container[ valor ];
		}
		
		//--------------------------------------
		// PUBLIC DEBUG MESSAGE
		//--------------------------------------
		
		public function debug( text , _debug ):void
		{
			if( ExternalInterface.available )
			{
				ExternalInterface.call( _debug, text);
				
				trace("DEBUG: " + text);
			}
		}
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		public function globalVars()
		{
			// Get URL
			getUrl();
			
			// Values
			setVariables();
		}
		
		//=============================================================
		// COLOR
		//=============================================================
		
		public function returnColor( _cor )
		{
			return _color[ _cor ]
		}
		
		//=============================================================
		// CONVERT
		//=============================================================
		
		public function convertForString(number:Number):String
		{
			var letters:Array = [];
			letters.push( "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",  
					"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",  
					"U", "V", "W", "X", "Y", "Z", "!", "@", "#", "$", "%", "¨", "&", "*", "(", ")" , "_"  , "+" );
 
			return letters[number];
		}
		
		public function convertForNumber( let:String ):Number 
		{
			var letters:Array = [];
			letters.push( "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",  
					"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",  
					"U", "V", "W", "X", "Y", "Z", "!", "@", "#", "$", "%", "¨", "&", "*", "(", ")" , "_"  , "+" );
 
			return letters.indexOf(let);
		}
		
		public function numberIndex( let:String ):Number 
		{
			var letters:Array = [];
			letters.push( "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "@", "#", "$", "%", "¨", "&", "*", "(", ")" , "_"  , "+" );
 
			return letters.indexOf(let);
		}
		
		public function stringIndex(number:Number):String
		{
			var letters:Array = [];
			letters.push( "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "@", "#", "$", "%", "¨", "&", "*", "(", ")" , "_"  , "+" );
 
			return letters[number];
		}
		
		
		public function convertForIndex( _id , _mapArrayControl )
		{
			for( var  i = 0; i < _mapArrayControl.length; i++ )
			{
				if ( _mapArrayControl[i].ID == _id )
				{
					return _mapArrayControl[i].INDEX;
				}
			}
		}
		
		
		//=============================================================
		// REMOVE ARRAY
		//=============================================================
		
		public function removeArray(list:Array):Array {
			for(var i:int = list.length - 1; i >= 0; i--) {
				if(!removeCallback(list[i])) {
					list.splice(i,1);
				}
			}
			
			function removeCallback(item):Boolean {
				return item != "*";
			}
			
			return list;
		}
		
		
		//=============================================================
		// PRIVATE FUNCTIONS
		//=============================================================
		
		//--------------------------------------
		// GET URL
		//--------------------------------------
		
		private function getUrl()
		{
			if( ExternalInterface.available )
			{
				urlActual = ExternalInterface.call("window.location.href.toString");
			
				urlActual == null ? url = urlLocal : url = urlWeb;
			}
			else
			{
				url = urlWeb;
			}
		}
	}
}