package com.control 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import com.config.Config; 
	import com.home.Home;
	import com.home.Correio;
	import com.menu.Menu;
	import com.desejo.Desejo;
	import com.tree.Tree;
	import com.perfil.Perfil;
	import com.subarea.Subarea;
	
	import com.includes.globalVars;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Control extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		
		// CONTAINERS
		private var _globalVars = new globalVars();
		private var container:MovieClip;
		private var _controlObj:ControlObj;/// esta na lib do Main
		private var _desejoObj:DesejoObj;/// esta na lib do Main
		private var _ajudaBTN:AjudaBTN;/// esta na lib do Main
		
		//
		private var _home:Home;
		private var _correio:Correio;
		private var _desejo:Desejo;
		private var _tree:Tree;
		private var _perfil:Perfil;
		private var _subarea:Subarea;
		private var _menu:Menu;
		
		//
		private var info:Dictionary = new Dictionary();
		
		//
		private var _nodeCurrent:*;
		private var _submenuInfo = "";
		private var _status:String = "home";
		private var _areaPath:String = "";
		private var _menuInfo:Object = {};
		
		//--------------------------------------
		// CONTROL
		//--------------------------------------
		
		public function Control( _info ) 
		{
			info = _info;
			
			init();
			desejoInit();
			homeInit();
			correioInit();
			ajudaInit();
			subAreaInit();
			menuInit();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function callAjuda()
		{
			dispatchEvent( new Event("CALL_AJUDA_EVENT") );
		}
		
		
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_controlObj = new ControlObj();
			container.addChild( _controlObj );
		}
		
		//--------------------------------------
		// HOME
		//--------------------------------------
		
		private function homeInit()
		{
			_home = new Home( info );
			_controlObj.addChild( _home );
			_home.addEventListener( "HOME_EVENT" , homeEvent  );
		}
		
		private function homeEvent(e:Event)
		{
			statusControl( "home" );
		}
		
		
		//--------------------------------------
		// CORREIO
		//--------------------------------------
		
		private function correioInit()
		{
			_correio = new Correio( info );
			_controlObj.addChild( _correio );
		}
		
		//--------------------------------------
		// AJUDA
		//--------------------------------------
		
		private function ajudaInit()
		{
			_ajudaBTN = new AjudaBTN();
			_ajudaBTN.name = "ajuda";
			_controlObj.addChild( _ajudaBTN );	
			
			_ajudaBTN["ajudaBtn"].buttonMode = true;
			_ajudaBTN["ajudaBtn"].mouseChildren = true;
			_ajudaBTN["ajudaBtn"].addEventListener( MouseEvent.CLICK, onAjudaClick );
			_ajudaBTN["ajudaBtn"].addEventListener(MouseEvent.MOUSE_OVER, onAjudaOver, false, 1000);
			_ajudaBTN["ajudaBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onAjudaOut, false, 1000);
			
		}
		
		private function onAjudaClick(e:MouseEvent)
		{
			callAjuda();
		}
		
		private function onAjudaOver(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OVER");
		}
		
		private function onAjudaOut(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("UP");
		}
		
		//--------------------------------------
		// MENU
		//--------------------------------------
		
		private function menuInit()
		{
			_menu = new Menu( info , {} );
			_controlObj.addChild(_menu);
			_menu.addEventListener("SUB_MENU_EVENT", subMenuEvent);
			
			statusControl( "home" );
		}
		
		private function subMenuEvent(e:Event)
		{
			_menuInfo = e.currentTarget.infoSubmenu;
			statusControl( "menu" );
		}
		
		//--------------------------------------
		// DESEJO
		//--------------------------------------
		
		private function desejoInit()
		{
			//
			_desejoObj = new DesejoObj();
			_controlObj.addChild( _desejoObj );
			_desejoObj.visible = false;
			
			//
			_desejo = new Desejo( info , _desejoObj );
			_controlObj.addChild( _desejo );	
			_desejo.addEventListener( "DESEJO_EVENT" , desejoEvent  );
			_desejo.addEventListener( "COMPLETE_DESEJO_EVENT" , completeDesejoEvent  );
			_desejo.addEventListener( "HOME_EVENT" , homeEvent  );
		}
		
		private function desejoEvent(e:Event)
		{
			statusControl( "desejo" );
		}
		
		private function completeDesejoEvent(e:Event)
		{
			statusControl( "desejo" );
		}
		
		
		private function desejoAtualizar( _infoNode )
		{
			_desejo.atualizar( _infoNode );
		}
		
		
		
		//--------------------------------------
		// PERFIL
		//--------------------------------------
		
		private function perfilInit() {
			//
			_perfil = new Perfil( info , _nodeCurrent  );
			_controlObj.addChildAt( _perfil, 0 );
			_perfil.addEventListener( "VOLTAR_EVENT" , voltarPerfilEvent  );
			_perfil.addEventListener( "DESEJO_EVENT" , desejoPerfilEvent  );
			_perfil.addEventListener( "COMPLETE_DESEJO_EVENT" , completeDesejoEvent  );
			
			//
			_menu.visible = false;
			
		}
		
		private function voltarPerfilEvent(e:Event)
		{
			statusControl( "voltar" );
		}
		
		private function desejoPerfilEvent(e:Event)
		{
			desejoAtualizar( e.currentTarget.nodeInfo );
		}
		
		
		//--------------------------------------
		// SUBÁREA
		//--------------------------------------
		
		private function subAreaInit() {
			_subarea = new Subarea( info );
			_controlObj.addChild( _subarea );
			_subarea.addEventListener( "SUBAREA_EVENT" , subAreaEvent  );
		}
		
		private function subAreaEvent(e:Event)
		{
			statusControl( "subArea" );
		}
		
		
		//--------------------------------------
		// STATUS CONTROL
		//--------------------------------------
		
		private function statusControl( _st ) {
			_status = _st;
			switch(_st){
				case "home":
					controlHome();
					break;
				case "voltar":
					controlVoltar();
					break;
				case "menu":
					controlMenu();
					break;
				case "desejo":
					controlDesejo();
					break;
				case "perfil":
					controlPerfil();
					break;
				case "subArea":
					controlSubarea();
					break;
				default:
					controlHome();
					break;
			} 
		}
		
		private function controlHome() {
			info["parameters"].ajuda = "ajuda1";/// ajuda Tree
			active([_desejo , _subarea , _correio  ]);
			treeInit( info["perfil"].perfil , "home" );
		}
		
		private function controlVoltar() {
			info["parameters"].ajuda = "ajuda1";/// ajuda Tree
			active([ _home, _desejo , _subarea , _correio   ]);
			treeInit( _perfil.infoPerfil , "voltar" );
		}
		
		private function controlMenu() {
			info["parameters"].ajuda = "ajuda1";/// ajuda Tree
			active([_home, _desejo, _subarea , _correio   ]);
			treeInit( _menuInfo , "home"  );
			_subarea.btnRESET();
		}
		
		
		private function controlDesejo() {
			info["parameters"].ajuda = "ajuda3";/// ajuda desejo
			active([ _home, _desejoObj , _correio  ]);
			_desejo.statusDesejo()
		}
		
		private function controlPerfil() {
			info["parameters"].ajuda = "ajuda4";/// ajuda perfil
			active([_home, _desejo , _correio   ]);
			perfilInit();
		}
		
		private function controlSubarea() {
			info["parameters"].ajuda = "ajuda10";/// ajuda subarea
			//active([_home, _desejo ]);
			//perfilInit();
		
			treeSubarea();
		}
		
		//--------------------------------------
		// TREE
		//--------------------------------------
		
		private function treeInit( tree , _tela = "*" ) {
			_tree = new Tree( info, tree , _tela );
			_controlObj.addChildAt( _tree , 0 );
			
			//
			_tree.addEventListener( "INFO_EVENT", infoEvent );
			
			//
			_menu.reload( tree );
		}
		
		private function infoEvent(e:Event)
		{
			_nodeCurrent = e.currentTarget.nodeInfo;
			
			if ( e.currentTarget.nodeInfo.ACTIVE == 1 )// PERFIL
			{
				info[ "ACTIVE" ] = "PERFIL";
				statusControl( "perfil" );
			}
			else if ( e.currentTarget.nodeInfo.ACTIVE == 2 )// ADD DESEJO
			{
				desejoAtualizar( e.currentTarget.nodeInfo );
			}
			else if ( e.currentTarget.nodeInfo.ACTIVE == 3 )//  POSSIVEL
			{
				info[ "ACTIVE" ] = "POSSIVEL";
				statusControl( "perfil" );
			}
			else if ( e.currentTarget.nodeInfo.ACTIVE == 4 )// ALTERNATIVA
			{
				info[ "ACTIVE" ] = "ALTERNATIVA";
				statusControl( "perfil" );
			}
		}
		
		private function treeSubarea()
		{
			_tree.treeSubarea();
		}
		
		//--------------------------------------
		// RESET / ACTIVE
		//--------------------------------------
		
		private function active( _array )
		{
			//
			reset();
			
			//
			for (var i:uint = 0; i < _array.length; i++) {
				_array[i].visible = true;
			}
			
			if( _status == "home" ||  _status == "menu" ||  _status == "submenu" ||  _status == "voltar" )
			{
				_menu.visible = true;
			}
		}
		
		private function reset() 
		{
			for (var i:uint = 0; i < _controlObj.numChildren; i++) {
				if (_controlObj.getChildAt(i).name != "ajuda")
					_controlObj.getChildAt(i).visible = false;
			}
			
			//
			_menu.visible = false;
		}	
	}
}