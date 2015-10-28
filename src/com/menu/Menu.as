package com.menu 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import fl.motion.Color;
	import flash.geom.ColorTransform;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import com.config.Config; 
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Menu extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		//Public
		public var treeCurrent = {};
		public var infoSubmenu = {};
		public var menuContainer:*;
		public var alternativaArray = [];
		
		//
		private var info:Dictionary = new Dictionary();
		private var _controle = [ "administrativo", "comercial", "industrial", "marketing", "rh", "tecnico"  ];
		private var _ativoCurrent:*;
		private var _ativoArray = [];
		
		//
		
		
		// CONTAINERS
		private var container:MovieClip;
		private var _menuObj:MenuObj;/// esta na lib do Main
		
		
		//--------------------------------------
		// MENU
		//--------------------------------------
		
		public function Menu( _config , _treeCurrent ) 
		{
			treeCurrent = _treeCurrent;
			info = _config;
			init()
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		public function reload( _perfil )
		{
			var derpatamento = ( _perfil.departamento )
			var area =( _perfil.area )
			var _index = _controle.indexOf( derpatamento ) + 1;
			
			//
			menuArea();
			openPanel( _index );
			resetClick( MovieClip(_menuObj)[ derpatamento ][ area ] );
			
		}
		
		private function submenuEvent()
		{
			dispatchEvent(new Event("SUB_MENU_EVENT"));
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_menuObj = new MenuObj();
			container.addChild( _menuObj );
			menuContainer = _menuObj;
			
			//
			//var _index = _controle.indexOf( info["perfil"].perfil.departamento ) + 1;
			//openPanel( _index );
		}
		
		//--------------------------------------
		// MENU AREA
		//--------------------------------------
		
		private function menuArea()
		{
			if ( treeCurrent.status != "possivel" )
			{
				var _menu = info["config"].menu.controle;
				
				for (var i = 0; i < _menu.length; i++  ) {
					
					var indice =  info["config"].menu[ _menu[i] ].indice;
					var abreviatura =  info["config"].menu[ _menu[i] ].abreviatura;
					
					for (var j = 1; j <= indice; j++  ) {
						
						var subarea = abreviatura + j;
						
						if ( treeCurrent.status != "alternativa" )
						{
							MovieClip(_menuObj)[ _menu[i] ][ subarea ].buttonMode = true;
							MovieClip(_menuObj)[ _menu[i] ][ subarea ].mouseChildren = true;
							MovieClip(_menuObj)[ _menu[i] ][ subarea ].addEventListener( MouseEvent.CLICK, onClick );
						}
						//MovieClip(_menuObj)[ _menu[i] ][ subarea ].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
						//MovieClip(_menuObj)[ _menu[i] ][ subarea ].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
						_ativoArray.push( MovieClip(_menuObj)[ _menu[i] ][ subarea ] );
					}
				}
			}
		}
		
		
		//--------------------------------------
		// ACORDEON
		//--------------------------------------
		
		private function openPanel( pNumber:Number ):void{
			var menuContainer = MovieClip( _menuObj );
			var obj;
			var i;
			var mywidth;
			var navW;
			var speed = 1;
			
			for ( i = 1; i < menuContainer.numChildren; i++ )
			{
				obj = menuContainer.getChildAt(i) as MovieClip;
				
				if ( treeCurrent.status != "possivel" )
				{
					var indice =  info["config"].menu[ _controle[i - 1] ].indice;
					var abreviatura =  info["config"].menu[ _controle[i - 1] ].abreviatura;
					
					obj.getChildByName("btn").abreviatura = abreviatura;
					obj.getChildByName("btn").indice = indice;
					obj.getChildByName("btn").pNumber = i;
					obj.getChildByName("btn").addEventListener(MouseEvent.CLICK, handleOpenClick);
					obj.getChildByName("btn").buttonMode = true;
				}
				else
				{
					if ( pNumber != i )
					{
						var c:Color = new Color();
						c.setTint( 0x666666  , 0.9 );
						obj.transform.colorTransform = c;
					}
				}
				
				//
				mywidth = obj.width;
				navW = obj.getChildByName("btn").width;
			}
			obj = menuContainer.getChildAt( pNumber ) as MovieClip;
			if (obj.getChildByName("btn").buttonMode)
			{
				obj.getChildByName("btn").buttonMode=false;
				obj.getChildByName("btn").removeEventListener(MouseEvent.CLICK, handleOpenClick);
			}
			
			for (i = pNumber + 1; i < menuContainer.numChildren; i++)
			{
				obj = menuContainer.getChildAt(i);
				var _posX = mywidth - ( menuContainer.numChildren - i ) * navW;
				TweenLite.to(obj, speed, { x:_posX} );
			}
			for(i=1; i<=pNumber;i++){
				obj = menuContainer.getChildAt(i);
				_posX = (i - 1) * navW;
				TweenLite.to(obj, speed, { x:_posX} );
			}
		}
		
		private function handleOpenClick(e:MouseEvent):void
		{
			openPanel( e.currentTarget.pNumber );
			
			//
			infoSubmenu.departamento =  e.currentTarget.parent.name;
			infoSubmenu.area = e.currentTarget.abreviatura + 1;
			
			submenuEvent();
			
		}
		
		
		
		//--------------------------------------
		// MOUSE
		//--------------------------------------
		
		private function onClick(e:MouseEvent)
		{
			//
			infoSubmenu.departamento =  e.currentTarget.parent.name;
			infoSubmenu.area = e.currentTarget.name;
			
			resetClick( e.currentTarget );
			
			if ( treeCurrent.status != "alternativa" )
				submenuEvent();
		}
		
		private function onOver(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OVER");
		}
		
		private function onOut(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("UP");
		}
		
		private function resetClick( _btn )
		{
			_ativoCurrent = _btn;
			
			for ( var i = 0; i < _ativoArray.length; i++  )
			{
				_ativoArray[i]["ico"].gotoAndStop("desativo");
			}
			
			_btn["ico"].gotoAndStop("ativo");
		}
	}

}