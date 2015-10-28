package com.ajuda 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	
	import com.includes.globalVars;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Ajuda extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		// CONTAINERS
		// GlobalVars
		private var _globalVars = new globalVars();
		
		private var container:MovieClip;
		private var _ajudaObj:AjudaObj;
		private var _info:*;
		private var shared:SharedObject;
		private var helpArray:Array = [];
		private var statusMenuLabel:String = "";
		
		//--------------------------------------
		// MENU
		//--------------------------------------
		
		public function Ajuda( config ) 
		{
			_info = config;
			init();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		public function callAjuda()
		{
			activeAjuda();
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_ajudaObj = new AjudaObj();
			container.addChild( _ajudaObj );
			_ajudaObj.visible = false;
			
			//
			//ajudaCookie();
		}
		
		//--------------------------------------
		// ACTIVE AJUDA
		//--------------------------------------
		
		private function activeAjuda()
		{
			_ajudaObj.visible = true;
			_ajudaObj["sairBtn"].buttonMode = true;
			_ajudaObj["sairBtn"].mouseChildren = true;
			_ajudaObj["sairBtn"].addEventListener( MouseEvent.CLICK, onClick );
			//_ajudaObj["sairBtn"].addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false, 1000);
			//_ajudaObj["sairBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onRollOut, false, 1000);
			
			//
			ajudaInit();
		} 
		
		//--------------------------------------
		// AJUDA INIT
		//--------------------------------------
		
		private function ajudaInit()
		{
			reset();
			active();
		}
		
		//--------------------------------------
		// ACTIVE
		//--------------------------------------
		
		private function active()
		{
			//
			var _menu = _ajudaObj["menu"];
			var _ajudaCurrent = _info["parameters"].ajuda; 
			_menu[ _ajudaCurrent ].gotoAndStop("ACTIVE");
			
			_ajudaObj["conteudo"].gotoAndStop( _ajudaCurrent );
			
			//
			for (var i:int = 0; i < _menu.numChildren; i++) {
				if (  getDefinitionByName(getQualifiedClassName( _menu.getChildAt(i) ) ) != Shape )
				{
					var _menuBtn = _menu.getChildAt(i);
					_menuBtn.buttonMode = true;
					_menuBtn.mouseChildren = true;
					_menuBtn.addEventListener( MouseEvent.CLICK, onClick );
					_menuBtn.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
					_menuBtn.addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);	
					
					if ( _menuBtn == _menu[ _ajudaCurrent ] )
					{
						_menuBtn.statusMenu = "ACTIVE";
					}
					else
					{
						_menuBtn.statusMenu = "UP";
					}
				}
			}
			
		}
		
		//--------------------------------------
		// RESET
		//--------------------------------------
		
		private function reset()
		{
			var _menu = _ajudaObj["menu"];
			
			for (var i:int = 0; i < _menu.numChildren; i++) {
				if (  getDefinitionByName(getQualifiedClassName( _menu.getChildAt(i) ) ) != Shape )
				{
					_menu.getChildAt(i).gotoAndStop("UP");
				}
			}
		}
		
		
		private function ajudaCookie()
		{
			shared = SharedObject.getLocal("weberHelp");
			if (shared.data.visits==undefined) {
				shared.data.visits = 1;
			}
			else {
				shared.data.visits ++;
			}

			if ( shared.data.visits == 1 )
			{
				activeHelpInit();
				_globalVars.debug( shared.data.visits , "console.log" );
			}
			
			shared.close();
		}
		
		
		private function activeHelpInit()
		{
			container.addEventListener(Event.ENTER_FRAME, helpEnterFrame );
		}
		
		private function helpEnterFrame(e:Event)
		{
			if ( helpArray.indexOf( _info["parameters"].ajuda ) == -1  )
			{
				//
				helpArray.push( _info["parameters"].ajuda );
				activeAjuda();
				confereHelpInit();
			}
		}
		
		private function confereHelpInit()
		{
			var _menu = _ajudaObj["menu"];
			
			if ( _menu.numChildren == helpArray.length )
			{
				container.removeEventListener(Event.ENTER_FRAME, helpEnterFrame );
			}
		}
		
		//--------------------------------------
		// MOUSE
		//--------------------------------------
		
		private function onClick(e:MouseEvent)
		{
			if( e.currentTarget.name == "sairBtn" )
			{
				_ajudaObj.visible = false;
			}
			else ///
			{
				_info["parameters"].ajuda = e.currentTarget.name;
				ajudaInit();				
			}
		}
		
		private function onOver(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OVER");
		}
		
		private function onOut(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop( e.currentTarget.statusMenu );
		}
	}
}