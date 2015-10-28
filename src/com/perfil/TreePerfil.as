package com.perfil 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import fl.motion.Color;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.tree.Tree;
	import com.includes.globalVars;
	
	import com.menu.Menu;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class TreePerfil extends MovieClip 
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
	
		private var container:MovieClip;
		private var _globalVars = new globalVars();
		private var _info:Dictionary = new Dictionary();
		private var _nodeCurrent:*;
		private var _perfilObj:*;/// esta na lib do Main
		private var _tree:Tree;
		private var _controle = _globalVars.get( "departamentos" );
		private var _ativoCurrent:*;
		private var _ativoArray = [];
		
		//
		public var treeCurrent = {};
		public var nodeInfo:*;
		public var nodePossivel:*;
		
		//
		private var _menu:Menu;
		
		public function TreePerfil( info , node , perfil , _treeCurrent  ) 
		{
			_info = info;
			_nodeCurrent = node;
			_perfilObj = perfil;
			treeCurrent = _treeCurrent;
			
			init();
			menuInit();
			treeInit();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function voltarPerfil()
		{
			dispatchEvent( new Event("VOLTAR_TREE_PERFIL_EVENT") );
		}
		
		private function voltarPerfilNulo()
		{
			dispatchEvent( new Event("VOLTAR_TREE_PERFIL_NULO_EVENT") );
		}
		
		private function infoActiveEvent()
		{
			dispatchEvent(new Event("INFO_EVENT"));
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			_perfilObj.gotoAndStop("tree");
			
			MovieClip(_perfilObj)["treePerfil"]["voltar"].buttonMode = true;
			MovieClip(_perfilObj)["treePerfil"]["voltar"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["treePerfil"]["voltar"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["treePerfil"]["voltar"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
		}
		
		//--------------------------------------
		//  TREE INIT
		//--------------------------------------
		
		private function treeInit()
		{
			if ( treeCurrent.departamento != undefined )
			{
				if ( _tree != null )
					MovieClip(_perfilObj)["treePerfil"]["tree"].removeChild( _tree );
				
				_tree = new Tree( _info, treeCurrent , treeCurrent.status  );
				MovieClip(_perfilObj)["treePerfil"]["tree"].addChild( _tree );
				_tree.addEventListener( "INFO_EVENT", nodeInfoEvent );
			}
			else
			{
				MovieClip(_perfilObj)["treePerfil"]["tree"].alpha = 0;
				setTimeout(function() {
					
					voltarPerfilNulo();
				
				}, 1000 * 0.1 );
			}
			
		}
		
		private function nodeInfoEvent(e:Event)
		{
			nodeInfo = e.currentTarget.nodeInfo;
			infoActiveEvent();
		}
		
		
		//--------------------------------------
		//  MENU INIT
		//--------------------------------------
		
		private function menuInit()
		{
			_menu = new Menu( _info , treeCurrent );
			MovieClip(_perfilObj)["treePerfil"].addChild(_menu);
			_menu.addEventListener("SUB_MENU_EVENT", subMenuEvent);
			
			//
			var _index = ( _controle.indexOf( _info["cargo"].perfil.departamento ) + 1 );
			
			
			if ( treeCurrent.status == "possivel" )
			{
				possivelFilter( _index );
			}
			else if ( treeCurrent.status == "alternativa" )
			{
				alternativasFilter( _index )
			}
		}
		
		private function subMenuEvent(e:Event)
		{
			if ( treeCurrent.status == "alternativa" )
			{
				for ( var i = 0; i < _ativoArray.length; i++  )
				{
					var _departamento =  e.currentTarget.infoSubmenu.departamento; 
					if ( _ativoArray[i].parent.name == _departamento )
					{
						treeCurrent.status = "alternativa";
						treeCurrent.cargo = "*";
						treeCurrent.index = "*";
						treeCurrent.departamento = _departamento;
						treeCurrent.area = _ativoArray[i].name ;
		
						treeInit();
						resetClick( _ativoArray[i] );
						
						break
					}
				}
			}
		}
		
		//--------------------------------------
		// FILTRO PARA POSSIVEL
		//--------------------------------------
		
		private function possivelFilter( _index ):void
		{
			var _possivelArray = [];
			_possivelArray = _info["parameters"].possivel;
			
			var _departamento_CARGO =  _info["cargo"].perfil.departamento; 
			var _indice = _info["config"]["menu"][ _departamento_CARGO ].indice;
			var _abreviatura = _info["config"]["menu"][ _departamento_CARGO ].abreviatura;
			
			for ( var j = 1; j <= _indice; j++  )
			{
				_menu["menuContainer"][ _departamento_CARGO ] [ _abreviatura + j ].alpha = 0.1;
			}
			
			for ( var i = 0; i < _possivelArray.length; i++  )
			{
				_departamento_CARGO =  _possivelArray[i]["perfil"]["departamento"]; 
				var _area_CARGO =  _possivelArray[i]["perfil"]["area"]; 
				
				var _cargoBTN =_menu["menuContainer"][ _departamento_CARGO ][ _area_CARGO ];
				
				_cargoBTN.cargo = _possivelArray[i]["info"]["cargo"];
				_cargoBTN.resumo = _possivelArray[i]["info"]["resumo"];
				_cargoBTN.index = _possivelArray[i]["perfil"]["index"];
				_cargoBTN.buttonMode = true;
				_cargoBTN.addEventListener(MouseEvent.CLICK, onClickPossivel);
				//MovieClip(_nodeContainer)["active"]["btn" + i ].addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false, 1000);
				//MovieClip(_nodeContainer)["active"]["btn" + i ].addEventListener(MouseEvent.MOUSE_OUT,  onRollOut, false, 1000);	
				
				_menu["menuContainer"][ _departamento_CARGO ] [ _area_CARGO ].alpha = 1;
				_ativoArray.push( _cargoBTN );
			}
			
			//
			_ativoCurrent = _ativoArray[0];
			_ativoArray[0]["ico"].gotoAndStop("ativo");
			
			//
			_menu.reload( { "area": _ativoArray[0].name , "departamento": _ativoArray[0].parent.name } );
		}
		
		private function onClickPossivel( e:MouseEvent ):void
		{
			if ( _ativoCurrent != e.currentTarget )
			{
				treeCurrent.status = "possivel";
				treeCurrent.cargo = e.currentTarget.cargo;
				treeCurrent.resumo = e.currentTarget.resumo;
				treeCurrent.index = e.currentTarget.index;
				treeCurrent.departamento =  e.currentTarget.parent.name;
				treeCurrent.area = e.currentTarget.name;
				
				treeInit();
				resetClick( e.currentTarget );
			}	
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
		
		
		//--------------------------------------
		// FILTRO PARA ALTERNATIVAS
		//--------------------------------------
		
		private function alternativasFilter( _index ):void
		{
			//
			var alternativasArray =  _info["config"].menu.controle;
			
			for ( var i = 0; i < alternativasArray.length; i++  )
			{
				var itemAlternativa = _info["config"].menu[ alternativasArray[i] ]["indice"];
				for ( var j = 1; j <= itemAlternativa; j++  )
				{
					var _abreviatura =  _info["config"].menu[ alternativasArray[i] ]["abreviatura"];
					var _item =  _abreviatura + j;
					var alternativaSub =  _info["cargo"].perfil.alternativa[ alternativasArray[i] ][ _item ] ;
					
					for ( var k = 0; k < alternativaSub.length; k++  )
					{
						var _cargoBTN = _menu["menuContainer"][ alternativasArray[i] ][ _item ];
						_cargoBTN.alpha = 0.2; 
						
						if( alternativaSub[0] != "*" )
						{
							_cargoBTN.alpha = 1; 
							_cargoBTN.buttonMode = true;
							_cargoBTN.addEventListener( MouseEvent.CLICK, onClickAlternativas );
							_ativoArray.push( _cargoBTN );
						}
					}
				}
			}
			
			_ativoCurrent = _ativoArray[0];
			for (  i = 0; i < _ativoArray.length; i++  )
			{
				if ( _ativoArray[i].buttonMode )
				{	
					treeCurrent.cargo = "*";
					treeCurrent.index = "*";
					treeCurrent.departamento = _ativoArray[i].parent.name;
					treeCurrent.area = _ativoArray[i].name;
					_ativoCurrent = _ativoArray[i];
					_ativoArray[i]["ico"].gotoAndStop("ativo");
					_menu.reload( { "area": _ativoArray[i].name , "departamento": _ativoArray[i].parent.name } );
					break;
				}
			}
		
			//
			_menu.alternativaArray = _ativoArray;
		}
		
		private function onClickAlternativas( e:MouseEvent ):void
		{
			if ( _ativoCurrent != e.currentTarget )
			{
				treeCurrent.status = "alternativa";
				treeCurrent.cargo = "*";
				treeCurrent.index = "*";
				treeCurrent.departamento =  e.currentTarget.parent.name;
				treeCurrent.area = e.currentTarget.name;
				
				treeInit();
				resetClick( e.currentTarget );
			}
		}
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		private function activeClick(e:MouseEvent)
		{
			voltarPerfil();
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