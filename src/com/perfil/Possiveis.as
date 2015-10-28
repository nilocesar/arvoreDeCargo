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
	
	import com.maccherone.json.JSON;
	import com.includes.globalVars;
	import com.perfil.TreePerfil;
	
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Possiveis extends MovieClip 
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		private var container:MovieClip;
		
		//
		private var _globalVars = new globalVars();
		private var _info:Dictionary = new Dictionary();
		private var _infoPossivel: Object;
		private var _possivelArray = [];
		
		//
		private var _nodeCurrent:*;
		private var _perfilObj:*;/// esta na lib do Main
		
		//
		private var _treePerfil:TreePerfil;
		private var indexPossiveisArray = [];
		private var _treeInfo:Object = {};
		
		//
		public var possivelInfo:Object;
		
		public function Possiveis( info , node , perfil ) 
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
		
		private function desejoEvent()
		{
			dispatchEvent( new Event("DESEJO_EVENT") );
		}
		
		private function completeDesejoEvent()
		{
			dispatchEvent( new Event("COMPLETE_DESEJO_EVENT") );
		}
		
		
		//--------------------------------------
		// DESEJO INIT
		//--------------------------------------
		
		private function desejoInit()
		{
			if( possivelInfo.DESEJO )
			{
				MovieClip(_perfilObj)["info"]["desejoBtn"].gotoAndStop(1);
				var _ativoBTN = MovieClip(_perfilObj)["info"]["desejoBtn"]["ativo"]["balaoInfo"]; 
				_ativoBTN.visible = false;
			}
			else
			{
				MovieClip(_perfilObj)["info"]["desejoBtn"].gotoAndStop(2);
				var _inativoBTN = MovieClip(_perfilObj)["info"]["desejoBtn"]["inativo"]["balaoInfo"]; 
				_inativoBTN.visible = false;
			}
		}
		
		//--------------------------------------
		// POSSÍVEIS INIT
		//--------------------------------------
		
		private function init()
		{
			indexPossiveisArray = _info["cargo"].perfil.possivel;
			
			for ( var i = 0; i < indexPossiveisArray.length; i++  )
			{
				if ( indexPossiveisArray[i] != "*" )
				{
					var _possivelPath = _globalVars.get( "PATH" ) + _info["config"].paths.perfil + indexPossiveisArray[i] + ".json";
				
					var urlRequest:URLRequest  = new URLRequest(  _possivelPath );
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, completeCargoHandler);

					try{
						urlLoader.load(urlRequest);
					} catch (error:Error) {
						trace("Cannot load : " + error.message);
					}
				}
			}
		}
		
		//--------------------------------------
		// PERFIL JSON
		//--------------------------------------
		
		private function completeCargoHandler(event:Event):void 
		{
			//
			var loader:URLLoader = URLLoader(event.target);
			_infoPossivel = JSON.decode(loader.data);
			_possivelArray.push( _infoPossivel );
			_info["parameters"].possivel = _possivelArray;
	
			if( _possivelArray.length == indexPossiveisArray.length )
			{
				createPossivel();
			}
		}
		
		//--------------------------------------
		// CREATE POSSIVEL
		//--------------------------------------
		
		private function createPossivel()
		{	
			_treeInfo.status = "possivel";
			_treeInfo.cargo = _possivelArray[0]["info"]["cargo"];
			_treeInfo.resumo =  _possivelArray[0]["info"]["resumo"];
			_treeInfo.index = _possivelArray[0]["perfil"]["index"];	
			_treeInfo.departamento =  _possivelArray[0]["perfil"]["departamento"]; 
			_treeInfo.area =  _possivelArray[0]["perfil"]["area"]; 
			
			
			treePerfil();
		}
		
		
		//--------------------------------------
		// TREE PERFIL
		//--------------------------------------
		
		private function treePerfil()
		{
			_info["parameters"].ajuda = "ajuda6";/// ajuda possivel - trilha
			_treePerfil = new TreePerfil( _info, _nodeCurrent, _perfilObj, _treeInfo );
			addChild( _treePerfil );
			_treePerfil.addEventListener( "VOLTAR_TREE_PERFIL_EVENT" , voltarTreePerfilEvent  );
			_treePerfil.addEventListener( "INFO_EVENT" , infoEvent  );
		}
		
		private function voltarTreePerfilEvent(e:Event)
		{
			voltarPerfilEvent();
		}
		
		private function infoEvent(e:Event)
		{
			_info["parameters"].ajuda = "ajuda7";/// ajuda possivel - trilha -> descricao
			MovieClip(_perfilObj).gotoAndStop( "info" );
			
			//
			possivelInfo =  e.currentTarget.nodeInfo;
		
			for ( var i = 0; i < _possivelArray.length; i++  )
			{
				if ( possivelInfo.CARGO == _possivelArray[i]["perfil"]["index"] )
				{
					_treeInfo.status = "possivel";
					_treeInfo.cargo = _possivelArray[i]["info"]["cargo"];
					_treeInfo.resumo = _possivelArray[i]["info"]["resumo"];
					_treeInfo.index = _possivelArray[i]["perfil"]["index"];
					_treeInfo.departamento = _possivelArray[i]["perfil"]["departamento"];
					_treeInfo.area = _possivelArray[i]["perfil"]["area"];
				}
			}
			
			var _cargo =_treeInfo.cargo;
			var _index = _treeInfo.index;
			var _departamento = (  _info["config"]["menu"][ _treeInfo.departamento ]["departamento"] );
			var _area = (  _info["config"]["menu"][ _treeInfo.departamento ][ _treeInfo.area ][0] );
			var _resumo =  _treeInfo.resumo;
			
			MovieClip(_perfilObj)["info"].cargoTxt.text = _cargo;
			//MovieClip(_perfilObj)["info"].indexTxt.text = _index;
			MovieClip(_perfilObj)["info"].departamentoTxt.text = _departamento;
			MovieClip(_perfilObj)["info"].areaTxt.text = _area;
			MovieClip(_perfilObj)["info"].resumoTxt.text =  _resumo;	

			MovieClip(_perfilObj)["info"]["voltar"].buttonMode = true;
			MovieClip(_perfilObj)["info"]["voltar"].addEventListener(MouseEvent.CLICK, onClick, false, 1000);
			MovieClip(_perfilObj)["info"]["voltar"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["info"]["voltar"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//PDF
			MovieClip(_perfilObj)["info"]["pdfBtn"].buttonMode = true;
			MovieClip(_perfilObj)["info"]["pdfBtn"].addEventListener(MouseEvent.CLICK, onClick, false, 1000);
			MovieClip(_perfilObj)["info"]["pdfBtn"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["info"]["pdfBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//		
			MovieClip(_perfilObj)["info"]["desejoBtn"].buttonMode = true;
			MovieClip(_perfilObj)["info"]["desejoBtn"].addEventListener(MouseEvent.CLICK, onClick, false, 1000);
			MovieClip(_perfilObj)["info"]["desejoBtn"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["info"]["desejoBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//
			desejoInit();
		}
		
		//--------------------------------------
		// PDF INIT
		//--------------------------------------
		
		private function pdfInit()
		{
			trace("pdf")
		}
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		
		private function onClick(e:MouseEvent)
		{
			if ( e.currentTarget.name == "voltar")
			{
				if( e.currentTarget.parent.name == "possiveis" )
				{
					voltarPerfilEvent();
				}
				else if( e.currentTarget.parent.name == "info" )
				{
					treePerfil();
				}
			}
			else if ( e.currentTarget.name == "pdfBtn")
			{
				pdfInit();
			}
			else if (e.currentTarget.name == "desejoBtn")
			{
				if( possivelInfo.DESEJO )
				{
					possivelInfo.controleDesejo();
					desejoInit();
					desejoEvent();
				}
			}
		}
		
		private function onOver(e:MouseEvent)
		{
			if (e.currentTarget.name != "desejoBtn")
			{
				e.currentTarget.gotoAndStop("OVER");
			}
			else
			{
				//e.currentTarget["fundo"].gotoAndStop("OVER");
				
				if( possivelInfo.DESEJO )
				{
					var _ativoBTN = MovieClip(_perfilObj)["info"]["desejoBtn"]["ativo"]["balaoInfo"]; 
					_ativoBTN.visible = !_ativoBTN.visible;
				}
				else
				{
					var _inativoBTN = MovieClip(_perfilObj)["info"]["desejoBtn"]["inativo"]["balaoInfo"]; 
					_inativoBTN.visible = !_inativoBTN.visible;
				}
			}
		}
		
		private function onOut(e:MouseEvent)
		{
			if (e.currentTarget.name != "desejoBtn")
			{
				e.currentTarget.gotoAndStop("UP");
			}
			else
			{
				if( possivelInfo.DESEJO )
				{
					var _ativoBTN = MovieClip(_perfilObj)["info"]["desejoBtn"]["ativo"]["balaoInfo"]; 
					_ativoBTN.visible = !_ativoBTN.visible;
				}
				else
				{
					var _inativoBTN = MovieClip(_perfilObj)["info"]["desejoBtn"]["inativo"]["balaoInfo"]; 
					_inativoBTN.visible = !_inativoBTN.visible;
				}
			}
		}
		
	}
}