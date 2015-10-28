package com.home 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	
	import com.config.Config; 
	/**
	 * ...
	 * @author Nilo
	 */
	public class Home extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		private var info:Dictionary = new Dictionary();
		
		// CONTAINERS
		private var container:MovieClip;
		private var _homeBTN:HomeBTN;/// esta na lib do Main.fla
		
		//--------------------------------------
		// HOME
		//--------------------------------------
		
		public function Home( _info ) 
		{
			info = _info;
			init();
			//homeEvent();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function homeEvent()
		{
			dispatchEvent( new Event("HOME_EVENT") );
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_homeBTN = new HomeBTN();
			container.addChild( _homeBTN );
			
			MovieClip(_homeBTN)[ "homeBtn" ].buttonMode = true;
			MovieClip(_homeBTN)[ "homeBtn" ].mouseChildren = true;
			MovieClip(_homeBTN)[ "homeBtn" ].addEventListener( MouseEvent.CLICK, onClick );
			MovieClip(_homeBTN)[ "homeBtn" ].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_homeBTN)[ "homeBtn" ].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//
			//trace( configObj.rei );
		}
		
		//--------------------------------------
		// MOUSE
		//--------------------------------------
		
		private function onClick(e:MouseEvent)
		{
			homeEvent();
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