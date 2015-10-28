package com.perfil 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	
	import com.includes.globalVars;
	import com.perfil.TreePerfil;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Alternativas extends MovieClip 
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		private var container:MovieClip;
		
		//
		private var _globalVars = new globalVars();
		private var _treePerfil:TreePerfil;
		
		private var _info:Dictionary = new Dictionary();
		private var _infoCargo: Object;
		
		//
		private var _nodeCurrent:*;
		private var _perfilObj:*;/// esta na lib do Main
		private var _treeInfo:Object = {};
		private var _alternativaArray = [];
		
		//
		public var alternativaInfo:Object = { }; 
		
		
		public function Alternativas( info , node , perfil ) 
		{
			_perfilObj = perfil;
			_info = info;
			_nodeCurrent = node;
			
			init();
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function voltarPerfilEvent()
		{
			dispatchEvent( new Event("VOLTAR_PERFIL_EVENT") );
		}
		
		private function voltarNuloEvent()
		{
			dispatchEvent( new Event("VOLTAR_PERFIL_NULO_EVENT") );
		}
		
		//--------------------------------------
		// ALTERNATIVAS INIT
		//--------------------------------------
		
		private function init()
		{
			_treeInfo.status = "alternativa";
			treePerfil();
		}
		
		//--------------------------------------
		// TREE PERFIL
		//--------------------------------------
		
		private function treePerfil()
		{
			_info["parameters"].ajuda = "ajuda9";/// ajuda possivel - trilha
			_treePerfil = new TreePerfil( _info, _nodeCurrent, _perfilObj, _treeInfo );
			addChild( _treePerfil );
			_treePerfil.addEventListener( "VOLTAR_TREE_PERFIL_EVENT" , voltarTreePerfilEvent  );
			_treePerfil.addEventListener( "VOLTAR_TREE_PERFIL_NULO_EVENT" , voltarTreePerfilNuloEvent  );
		}
		
		private function voltarTreePerfilEvent(e:Event)
		{
			voltarPerfilEvent();
		}
		
		private function voltarTreePerfilNuloEvent(e:Event)
		{
			voltarNuloEvent();
		}
	}
}