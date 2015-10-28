package com.config 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	import com.includes.globalVars;
	
	import com.maccherone.json.JSON;
	
	import com.Main;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Config extends MovieClip 
	{
		//
		public var info:Dictionary = new Dictionary();
		
		// GlobalVars
		private var _globalVars = new globalVars();
		
		//
		private var parametersObj:Object ={};
		private var subareaObj:Object = {};
		private var configObj:Object = {};
		private var perfilObj:Object = {};
		
		//
		private var suspendDataCont = 0;
		private var suspendataArray = []
		
		//--------------------------------------
		// CONFIG
		//--------------------------------------
		
		public function Config( _config ) 
		{
			parametersObj = _config;
			init();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function configCompleteEvent()
		{
			dispatchEvent(new Event("CONFIG_COMPLETE_EVENT"));
		}
		
		
		//--------------------------------------
		// CONFIG INIT
		//--------------------------------------
		
		private function init()
		{
			info["parameters"] = parametersObj;
			info["parameters"].rowALL = 0;
			info["parameters"].colALL = 0;
			
			
			var urlRequest:URLRequest  = new URLRequest( parametersObj.configPath );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeConfigHandler);

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
			
		}
		
		private function completeConfigHandler(event:Event):void {
			
			//
			var loader:URLLoader = URLLoader(event.target);
			configObj = JSON.decode(loader.data);
			info["config"] = configObj;
			
			//CALL DO SUBAREA
			subareaInit();		
		}
		
		//--------------------------------------
		// SUBAREAS INIT
		//--------------------------------------
		
		private function subareaInit()
		{
			var _subareaPath = _globalVars.get( "PATH" ) + "json/"  + "subareas.json";
			
			var urlRequest:URLRequest  = new URLRequest(_subareaPath );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener( Event.COMPLETE, completeSubareaHandler );

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
		}
		
		private function completeSubareaHandler(event:Event):void {
			
			var loader:URLLoader = URLLoader(event.target);
			subareaObj = JSON.decode(loader.data);
			info["subareas"] = subareaObj;
			
			//CALL DO PERFIL
			perfilInit();	
		}
		
		//--------------------------------------
		// PERFIL INIT
		//--------------------------------------
		
		private function perfilInit()
		{
			var _perfilPath = _globalVars.get( "PATH" ) + configObj.paths.perfil +  parametersObj.cargo + ".json";
			
			var urlRequest:URLRequest  = new URLRequest(  _perfilPath );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeCargoHandler);

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
		}
		
		private function completeCargoHandler(event:Event):void {
			
			//
			var loader:URLLoader = URLLoader(event.target);
			perfilObj = JSON.decode(loader.data);
			info["perfil"] = perfilObj;
			
			ifoDesejoInit();
		}
		
		//--------------------------------------
		// INFO DESEJO INIT
		//--------------------------------------
		
		private function ifoDesejoInit()
		{		
			var _infoPerfil = info["perfil"].perfil;
			var _perfilPath = _globalVars.get( "PATH" ) + "json/" + _infoPerfil.departamento +"/" + _infoPerfil.area + ".json";;
			
			var urlRequest:URLRequest  = new URLRequest(  _perfilPath );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeDesejoHandler);

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
		}
		
		private function completeDesejoHandler(event:Event):void {
			
			//
			var loader:URLLoader = URLLoader(event.target);
			var treeJson = JSON.decode(loader.data);
			var configTree = (treeJson["config"]);
		
			for (var i = 0; i < configTree.length; i++  )
			{
				if ( configTree[i].index == info["parameters"].cargo )
				{
					info["parameters"].cargoID = ( configTree[i].ID );
					info["parameters"].cargoTIMELINE = ( configTree[i].timeline );
				}
			}
		
			//
			if ( info["parameters"].suspendData == "*,*,*" || info["parameters"].suspendData =="0,0,0" )
				info["parameters"].suspendData = "*";
			
			if ( info["parameters"].suspendData != "*")
				suspendataInit();
			else
				configCompleteEvent();
		}
		
		//--------------------------------------
		// SUSPENDATA INIT
		//--------------------------------------
		
		private function suspendataInit()
		{
			suspendataArray = info["parameters"].suspendData.split(",");
			suspendataArray = _globalVars.removeArray( suspendataArray );
			
			for ( var i = 0; i < suspendataArray.length; i++  )
			{
				var _perfilPath = _globalVars.get( "PATH" ) + configObj.paths.perfil +"/" + suspendataArray[i] + ".json";;
				var urlRequest:URLRequest  = new URLRequest(  _perfilPath );
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, completeSuspendataHandler);

				try{
					urlLoader.load(urlRequest);
				} catch (error:Error) {
					trace("Cannot load : " + error.message);
				}
			}
		}
		
		private function completeSuspendataHandler(event:Event):void
		{
			suspendDataCont++;
			var loader:URLLoader = URLLoader(event.target);
			info["parameters"]["desejo" + suspendDataCont ] = JSON.decode(loader.data);
			
			//Suspendata
			if ( suspendDataCont == suspendataArray.length  )
				configCompleteEvent();
		}
	}
}