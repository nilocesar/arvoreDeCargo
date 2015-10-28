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
	import flash.system.Security;
	
	import com.maccherone.json.JSON;
	import com.includes.globalVars;
	import com.perfil.Possiveis;
	import com.perfil.Alternativas;
	
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Perfil extends MovieClip 
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		//
		public var nodeInfo:*;
		public var infoPerfil = {};
		
		//
		private var container:MovieClip;
		private var _perfilObj:PerfilObj;/// esta na lib do Main
		
		//
		private var _globalVars = new globalVars();
		private var _info:Dictionary = new Dictionary();
		private var _infoCargo: Object;
		
		//
		private var _possivel:Possiveis;
		private var _alternativas:Alternativas;
		
		private var conferePossivel = false;
		
		public function Perfil( info , node ) 
		{
			// allow script access;
			Security.allowDomain( '*' );			// replace * with your domain;
			Security.allowInsecureDomain( '*' );	// replace * with your domain;
			
			_info = info;
			nodeInfo = node;
			
			init();
			jsonPerfil();
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{	
			container = new MovieClip();
			addChild( container );
			
			_perfilObj = new PerfilObj();
			container.addChild( _perfilObj );
			//_perfilObj.visible = false;
		}
		
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		private function voltarEvent()
		{
			dispatchEvent( new Event("VOLTAR_EVENT") );
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
		// PERFIL JSON
		//--------------------------------------
		
		private function jsonPerfil() 
		{
			_globalVars.debug(  nodeInfo.CARGO , "console.log" );
			
			var _perfilPath = _globalVars.get( "PATH" ) + _info["config"].paths.perfil +  nodeInfo.CARGO + ".json";
			
			var urlRequest:URLRequest  = new URLRequest(  _perfilPath );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeCargoHandler);

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
		}
		private function completeCargoHandler(event:Event):void {
			
			//
			var loader:URLLoader = URLLoader(event.target);
			_infoCargo = JSON.decode(loader.data);
			_info["cargo"] = _infoCargo; 
			
			//
			infoPerfil.departamento = _info["parameters"]["departamentoCurrent"];
			infoPerfil.area = _info["parameters"]["areaCurrent"];
			
			var indexPossiveisArray = _info["cargo"].perfil.possivel;
			for ( var i = 0; i < indexPossiveisArray.length; i++  )
			{
				if ( indexPossiveisArray[i] != "*" )
					conferePossivel = true;
			}
			
			
			if ( _info["ACTIVE"] == "PERFIL" )
			{
				perfilInit();
				if ( !conferePossivel )
				{
					MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"]["resumoTxt"].text = _infoCargo.info.possivelNULL;
					MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"].visible = true;
					
					MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.CLICK, activeClick);
					MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.MOUSE_OVER, onOver);
					MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.MOUSE_OUT,  onOut);
				}
			}
			else if ( _info["ACTIVE"] == "POSSIVEL" )
			{
				if ( conferePossivel )
				{
					possiveisInit();
				}
				else
				{
					perfilInit();
					MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"]["resumoTxt"].text = _infoCargo.info.possivelNULL;
					MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"].visible = true;
					MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.CLICK, activeClick);
					MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.MOUSE_OVER, onOver);
					MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.MOUSE_OUT,  onOut);
				}
			}
			else if ( _info["ACTIVE"] == "ALTERNATIVA" )
			{
				alternativasInit();		
			}
		}
		
		
		
		//--------------------------------------
		// PERFIL INIT
		//--------------------------------------
		
		private function perfilInit()
		{
			
			/////
			_perfilObj.gotoAndStop("perfil");
			/////
			
			
			//
			//MovieClip(_perfilObj)["perfil"]["index"].text = _infoCargo.perfil.index;
			MovieClip(_perfilObj)["perfil"]["cargo"].text = _infoCargo.info.cargo;
			MovieClip(_perfilObj)["perfil"]["resumo"].htmlText  = _infoCargo.info.resumo;
			
			MovieClip(_perfilObj)["perfil"]["voltar"].buttonMode = true;
			MovieClip(_perfilObj)["perfil"]["voltar"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["perfil"]["voltar"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["perfil"]["voltar"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			MovieClip(_perfilObj)["perfil"]["linkWeber"].buttonMode = true;
			MovieClip(_perfilObj)["perfil"]["linkWeber"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["perfil"]["linkWeber"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["perfil"]["linkWeber"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			MovieClip(_perfilObj)["perfil"]["desejoBtn"].buttonMode = true;
			MovieClip(_perfilObj)["perfil"]["desejoBtn"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["perfil"]["desejoBtn"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["perfil"]["desejoBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			MovieClip(_perfilObj)["perfil"]["possivelBtn"].buttonMode = true;
			MovieClip(_perfilObj)["perfil"]["possivelBtn"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["perfil"]["possivelBtn"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["perfil"]["possivelBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"].visible = false;
			
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].buttonMode = true;
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"]["balaoInfo"].visible = false;
			
			MovieClip(_perfilObj)["perfil"]["pdfBtn"].buttonMode = true;
			MovieClip(_perfilObj)["perfil"]["pdfBtn"].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
			MovieClip(_perfilObj)["perfil"]["pdfBtn"].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_perfilObj)["perfil"]["pdfBtn"].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			//Remove Desejo do CARGO Principal
			if ( _info["parameters"].cargo == _infoCargo.perfil.index  )
			{
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].alpha = 0;
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].buttonMode = false;
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].removeEventListener(MouseEvent.CLICK, activeClick );
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].removeEventListener(MouseEvent.MOUSE_OVER, onOver );
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].removeEventListener(MouseEvent.MOUSE_OUT,  onOut );
				
				var _xBtn = 88;
				MovieClip(_perfilObj)["perfil"]["possivelBtn"].x += _xBtn;
				MovieClip(_perfilObj)["perfil"]["alternativaBtn"].x += _xBtn;
				MovieClip(_perfilObj)["perfil"]["pdfBtn"].x += _xBtn;
			}
			
			
			if ( _infoCargo.perfil.index  == "CSC"  )
			{
				removeCSC();
			}
			
			
			/// CONTROLE DESEJO
			desejoInit();
			_info["parameters"].ajuda = "ajuda4";/// ajuda perfil
		}
		
		
		//--------------------------------------
		// REMOVE CSC
		//--------------------------------------
		
		
		function removeCSC()
		{
			MovieClip(_perfilObj)["perfil"]["desejoBtn"].visible = false;
			MovieClip(_perfilObj)["perfil"]["possivelBtn"].visible = false;
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].visible = false;
			MovieClip(_perfilObj)["perfil"]["pdfBtn"].visible = false;
		}
		
		//--------------------------------------
		// DESEJO INIT
		//--------------------------------------
		
		private function desejoInit()
		{
			if( nodeInfo.DESEJO )
			{
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].gotoAndStop(1);
				var _ativoBTN = MovieClip(_perfilObj)["perfil"]["desejoBtn"]["ativo"]["balaoInfo"]; 
				_ativoBTN.visible = false;
			}
			else
			{
				MovieClip(_perfilObj)["perfil"]["desejoBtn"].gotoAndStop(2);
				var _inativoBTN = MovieClip(_perfilObj)["perfil"]["desejoBtn"]["inativo"]["balaoInfo"]; 
				_inativoBTN.visible = false;
			}
		}
		
		
		//--------------------------------------
		// POSSÍVEIS INIT
		//--------------------------------------
		
		private function possiveisInit()
		{
			_info["parameters"].ajuda = "ajuda5";/// ajuda possivel
			_possivel = new Possiveis( _info, nodeInfo, _perfilObj );
			container.addChild( _possivel );
			
			_possivel.addEventListener( "VOLTAR_PERFIL_EVENT" , voltarPossivelEvent  );
			_possivel.addEventListener( "DESEJO_EVENT" , desejoPossivelEvent  );
			_possivel.addEventListener( "COMPLETE_DESEJO_EVENT" , completeDesejoPossivelEvent  );
		}
		
		private function voltarPossivelEvent(e:Event)
		{
			container.removeChild( _possivel );
			
			if ( _info["ACTIVE"] == "PERFIL" )
				perfilInit();
			else
				voltarInit();
		}
		
		private function desejoPossivelEvent(e:Event)
		{
			desejoEvent();
		}
		
		private function completeDesejoPossivelEvent(e:Event)
		{
			completeDesejoEvent();
		}
		
		
		//--------------------------------------
		// ALTERNATIVAS INIT
		//--------------------------------------
		
		private function alternativasInit()
		{
			_info["parameters"].ajuda = "ajuda8";/// ajuda alternativas
			_alternativas = new Alternativas( _info, nodeInfo, _perfilObj );
			container.addChild( _alternativas );
			
			_alternativas.addEventListener( "VOLTAR_PERFIL_EVENT" , voltarAlternativasEvent  );
			_alternativas.addEventListener( "VOLTAR_PERFIL_NULO_EVENT" , voltarAlternativasNuloEvent  );
		}
		
		private function voltarAlternativasEvent(e:Event)
		{
			container.removeChild( _alternativas );
			
			if ( _info["ACTIVE"] == "PERFIL" )
				perfilInit();
			else
				voltarInit();
		}
		
		private function voltarAlternativasNuloEvent(e:Event)
		{
			perfilInit();
			
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"]["balaoInfo"].visible = true;
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].removeEventListener(MouseEvent.CLICK, activeClick);
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			MovieClip(_perfilObj)["perfil"]["alternativaBtn"].removeEventListener(MouseEvent.MOUSE_OUT,  onOut);
			
			if( !conferePossivel )
			{
				MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"]["resumoTxt"].text = _infoCargo.info.possivelNULL;
				MovieClip(_perfilObj)["perfil"]["possivelBtn"]["balaoInfo"].visible = true;
				MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.CLICK, activeClick);
				MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				MovieClip(_perfilObj)["perfil"]["possivelBtn"].removeEventListener(MouseEvent.MOUSE_OUT,  onOut);
			}
		}
		
		//--------------------------------------
		// PDF INIT
		//--------------------------------------
		
		private function pdfInit()
		{
			trace("pdf")
		}
		
		
		//--------------------------------------
		// VOLTAR INIT
		//--------------------------------------
		
		private function voltarInit()
		{
			voltarEvent();
		}
		
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		private function activeClick(e:MouseEvent)
		{
			//
			if (e.currentTarget.name == "desejoBtn")
			{
				if( nodeInfo.DESEJO )
				{
					nodeInfo.controleDesejo();
					desejoInit();
					desejoEvent();
				}
			}
			else if (e.currentTarget.name == "possivelBtn")
			{
				possiveisInit();
			}
			else if (e.currentTarget.name == "alternativaBtn")
			{
				alternativasInit();
			}
			else if (e.currentTarget.name == "pdfBtn")
			{
				pdfInit();
			}
			else if (e.currentTarget.name == "voltar")
			{
				voltarInit();
			}
			else if (e.currentTarget.name == "linkWeber")
			{
				trace("link");
				navigateToURL(new URLRequest( _globalVars.get( "linkWeber" ) ));
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
				
				if( nodeInfo.DESEJO )
				{
					var _ativoBTN = MovieClip(_perfilObj)["perfil"]["desejoBtn"]["ativo"]["balaoInfo"]; 
					_ativoBTN.visible = !_ativoBTN.visible;
				}
				else
				{
					var _inativoBTN = MovieClip(_perfilObj)["perfil"]["desejoBtn"]["inativo"]["balaoInfo"]; 
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
				if( nodeInfo.DESEJO )
				{
					var _ativoBTN = MovieClip(_perfilObj)["perfil"]["desejoBtn"]["ativo"]["balaoInfo"]; 
					_ativoBTN.visible = !_ativoBTN.visible;
				}
				else
				{
					var _inativoBTN = MovieClip(_perfilObj)["perfil"]["desejoBtn"]["inativo"]["balaoInfo"]; 
					_inativoBTN.visible = !_inativoBTN.visible;
				}
			}
		}
	}

}