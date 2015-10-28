package com
{
	//--------------------------------------
	// IMPORTS
	//--------------------------------------
	
	import com.ajuda.Ajuda;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import com.includes.globalVars;
	import com.config.Config;
	import com.control.Control;
	import com.ajuda.Ajuda;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Main extends MovieClip
	{
		//--------------------------------------
		// VARIÁVEIS
		//--------------------------------------
		
		//
		public static var STAGE:Stage;
		
		// GlobalVars
		private var _globalVars = new globalVars();
		private var configObj:Object;
		
		// CONTAINERS
		private var container:MovieClip;
		
		//Class
		private var _configClass:Config;
		private var _control:Control;
		private var _ajuda:Ajuda;
		
		//
		
		//--------------------------------------
		// MAIN
		//--------------------------------------
		
		public function Main()
		{
			// allow script access;
			Security.allowDomain( '*' );			// replace * with your domain;
			Security.allowInsecureDomain( '*' );	// replace * with your domain;
			
			if(stage != null)
			{
				STAGE = stage;
				configObj = _globalVars.get("config");
				//
				if (stage)
					init();
				else
					addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		public function config(_config, _stage)
		{
			STAGE = _stage;
			configObj = _config;
			//configObj = _globalVars.debug("config");
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init(e:Event = null)
		{
			container = new MovieClip();
			addChild(container);
			
			//
			configInit();
			
			//
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------
		// CONFIG
		//--------------------------------------
		
		private function configInit()
		{
			_configClass = new Config(configObj);
			container.addChild(_configClass);
			_configClass.addEventListener("CONFIG_COMPLETE_EVENT", CONFIG_COMPLETE_EVENT);
		}
		
		private function CONFIG_COMPLETE_EVENT(e:Event)
		{
			controlInit( e.currentTarget.info );
			ajudaInit( e.currentTarget.info );
		}
		
		//--------------------------------------
		// AJUDA
		//--------------------------------------
		
		private function ajudaInit(_config)
		{
			_ajuda = new Ajuda(_config);
			container.addChild(_ajuda);
		}
		
		private function callAjuda()
		{
			_ajuda.callAjuda();
		}
		
		//--------------------------------------
		// CONTROL
		//--------------------------------------
		
		private function controlInit(_config)
		{
			_control = new Control(_config );
			container.addChild(_control);
			_control.addEventListener("CALL_AJUDA_EVENT", callAjudaEvent);
		}
		
		private function callAjudaEvent(e:Event)
		{
			callAjuda();
		}
	}
}