package com.subarea 
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
	public class Subarea extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		private var info:Dictionary = new Dictionary();
		
		// CONTAINERS
		private var container:MovieClip;
		private var _subareaBTN:SubareaBTN;/// esta na lib do Main.fla
		
		//--------------------------------------
		// HOME
		//--------------------------------------
		
		public function Subarea( _info ) 
		{
			info = _info;
			init();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		public function btnRESET()
		{
			MovieClip( _subareaBTN )[ "subaraeBtn" ]["ico"].gotoAndStop( "subarea" );
		}
		
		
		private function SubareaEvent()
		{
			dispatchEvent( new Event("SUBAREA_EVENT") );
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_subareaBTN = new SubareaBTN();
			container.addChild( _subareaBTN );
			
			MovieClip( _subareaBTN )[ "subaraeBtn" ].buttonMode = true;
			MovieClip( _subareaBTN )[ "subaraeBtn" ].mouseChildren = true;
			MovieClip( _subareaBTN )[ "subaraeBtn" ].addEventListener( MouseEvent.CLICK, onClick );
			MovieClip( _subareaBTN )[ "subaraeBtn" ].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip( _subareaBTN )[ "subaraeBtn" ].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//
			//trace( configObj.rei );
		}
		
		//--------------------------------------
		// MOUSE
		//--------------------------------------
		
		private function onClick(e:MouseEvent)
		{
			SubareaEvent();
			
			if ( e.currentTarget["ico"].currentFrameLabel == "subarea" )
			{
				e.currentTarget["ico"].gotoAndStop( "area" );
				e.currentTarget["overSub"].gotoAndStop( 2 );
			}
			else
			{
				e.currentTarget["ico"].gotoAndStop( "subarea" );
				e.currentTarget["overSub"].gotoAndStop( 1 );
			}
			
		}
		
		private function onOver(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OVER");
			
			if ( e.currentTarget["ico"].currentFrameLabel == "subarea" )
			{
				e.currentTarget["overSub"].gotoAndStop( 1 );
			}
			else
			{
				e.currentTarget["overSub"].gotoAndStop( 2 );
			}
			
			
		}
		
		private function onOut(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("UP");
		}
	}
}