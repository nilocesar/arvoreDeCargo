package com.home 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.includes.globalVars;
	
	
	import com.config.Config; 
	/**
	 * ...
	 * @author Nilo
	 */
	public class Correio extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		private var info:Dictionary = new Dictionary();
		private var _globalVars = new globalVars();
		
		// CONTAINERS
		private var container:MovieClip;
		private var _correioBTN:CorreioBTN;
		
		//--------------------------------------
		// HOME
		//--------------------------------------
		
		public function Correio( _info ) 
		{
			info = _info;
			init();
			//homeEvent();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function linkEvent()
		{
			//dispatchEvent( new Event("HOME_EVENT") );
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_correioBTN = new CorreioBTN();
			container.addChild( _correioBTN );
			
			MovieClip(_correioBTN )[ "uniWeber" ].buttonMode = true;
			MovieClip(_correioBTN )[ "uniWeber" ].mouseChildren = true;
			MovieClip(_correioBTN )[ "uniWeber" ].addEventListener( MouseEvent.CLICK, onClick );
			MovieClip(_correioBTN )[ "uniWeber" ].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_correioBTN )[ "uniWeber" ].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//
			//trace( configObj.rei );
		}
		
		//--------------------------------------
		// MOUSE
		//--------------------------------------
		
		private function onClick(e:MouseEvent)
		{
			trace("link");
			navigateToURL(new URLRequest( _globalVars.get( "emailWeber" ) ) );
		}
		
		private function onOver(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OVER");
		}
		
		private function onOut(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("UP");
		}
	}

}