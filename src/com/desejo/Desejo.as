package com.desejo 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import flash.external.ExternalInterface;
	
	//
	import com.includes.globalVars;
	
	/**
	 * ...
	 * @author Nilo
	 */
	public class Desejo extends MovieClip  
	{
		//--------------------------------------
		// VAR
		//--------------------------------------
		
		private var _info:Dictionary = new Dictionary();
		
		// GlobalVars
		private var _globalVars = new globalVars();
		
		// CONTAINERS
		private var container:MovieClip;
		public var _desejoBTN:DesejoBTN;/// esta na lib do Main.fla
		private var _cont = 0;
		private var _desejoObj:*;
		private var _nodeObj:*;
		private var _statusDesejoComplete = false; 
		private var _desejoArray = [];
		private var _statusRH = true;
		private var _desejo_Y = 0;
		private var desejoTotal = 0;
		private	var desejoAtual = 0;
		
		
		//--------------------------------------
		// MENU
		//--------------------------------------
		
		public function Desejo( info ,desejObj ) 
		{
			_desejoObj = desejObj,
			_info = info;
			init();
			cargoAtual( "infoComplete" );
		}
		
		//--------------------------------------
		// PUBLIC/EVENT
		//--------------------------------------
		
		public function statusDesejo()
		{
			openDesejo("open");
		}
		
		
		public function atualizar( _infoNode )
		{
			_nodeObj = _infoNode;
			atualizarDesejo();
		}
		
		
		private function homeEvent()
		{
			dispatchEvent( new Event("HOME_EVENT") );
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
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			
			_desejoBTN = new DesejoBTN();
			container.addChild( _desejoBTN );
			
			
			MovieClip(_desejoBTN)[ "desejoBtn" ].buttonMode = true;
			MovieClip(_desejoBTN)[ "desejoBtn" ].mouseChildren = true;
			MovieClip(_desejoBTN)[ "desejoBtn" ].addEventListener( MouseEvent.CLICK, onClick );
			MovieClip(_desejoBTN)[ "desejoBtn" ].addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			MovieClip(_desejoBTN)[ "desejoBtn" ].addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
			
			
			
			_desejo_Y = _desejoObj["infoComplete"]["trilha"][ "desejo1" ]["txt"].y;
			
			atualizarDesejo();
		}
		
		
		//--------------------------------------
		// CARGO ATUAL
		//--------------------------------------
		
		private function cargoAtual( _inf )
		{
			_desejoObj[ _inf ]["cargo"]["txt"].text = _info["perfil"]["info"].cargo;	
			_desejoObj[ _inf ]["cargo"]["txt"].y += 
						_desejoObj[ _inf ]["cargo"].label.height / 2 - 
						_desejoObj[ _inf ]["cargo"]["txt"].textHeight / 2; 
		}
		
		//--------------------------------------
		// ATUALIZAR DESEJO
		//--------------------------------------
		
		private function atualizarDesejo()
		{
			if( _info["parameters"].suspendData != "*" ) /// --> verifica se o suspendata esta vázio
			{
				_desejoArray = [];
				var suspendDataArray:Array = _info["parameters"].suspendData.split(",");
				suspendDataArray = _globalVars.removeArray( suspendDataArray );
				desejoTotal = _info["config"].rei.length;
				desejoAtual = suspendDataArray.length ;
				
				
				for (var i= 0; i < suspendDataArray.length; i++  )
				{
				
					_desejoArray.push( { 
						CARGO: suspendDataArray[i],  
						TITULO: _info["parameters"]["desejo" + (i + 1 ) ].info.cargo 
					} );
					
					_desejoObj["infoComplete"]["trilha"]["desejo" +(i + 1) ]["txt"].text = _desejoArray[i].TITULO;
				}
				
				_cont = suspendDataArray.length;
				MovieClip(_desejoBTN)[ "desejoBtn" ]["cont"].text = _cont;
				
				//
				openDesejo();
			}
		}
		
		//--------------------------------------
		// OPEN DESEJO
		//--------------------------------------
		
		private function openDesejo( _openStatus = "close" )
		{

			if ( desejoAtual == 0 )
			{
				_desejoObj["infoComplete"][ "limparCompleteBtn" ].visible = false;
				_desejoObj["infoComplete"][ "confirmarBtn" ].visible = false;
				_desejoObj["infoComplete"][ "envioBtn" ].visible = false;
			}
			else
			{
				_desejoObj["infoComplete"][ "limparCompleteBtn" ].visible = true;
				_desejoObj["infoComplete"][ "confirmarBtn" ].visible = true;
				_desejoObj["infoComplete"][ "envioBtn" ].visible = true;
			}
			
			desejoInit();
			
			if( _openStatus == "close" )
				desejoEvent();
		}
		
		
		//--------------------------------------
		// ATUALIZAR DESEJO
		//--------------------------------------
		
		private function desejoInit()
		{
			for( var i = 1; i <= _cont; i++ )
			{
				_desejoObj["infoComplete"]["trilha"]["desejo" + i ]["txt"].text = _desejoArray[ i -1 ].TITULO;
				_desejoObj["infoComplete"]["trilha"]["desejo" + i ]["txt"].y = _desejo_Y + 
							_desejoObj["infoComplete"]["trilha"][ "desejo" + i ].label.height / 2 -
							_desejoObj["infoComplete"]["trilha"]["desejo" + i ]["txt"].textHeight / 2;
			}
			
			_desejoObj["infoComplete"][ "voltar" ].buttonMode = true;
			_desejoObj["infoComplete"][ "voltar" ].mouseChildren = true;
			_desejoObj["infoComplete"][ "voltar" ].addEventListener( MouseEvent.CLICK, onClick );
			_desejoObj["infoComplete"][ "voltar" ].addEventListener( MouseEvent.MOUSE_OVER, onOver );
			_desejoObj["infoComplete"][ "voltar" ].addEventListener( MouseEvent.MOUSE_OUT,  onOut );
			
			_desejoObj["infoComplete"][ "limparCompleteBtn" ].buttonMode = true;
			_desejoObj["infoComplete"][ "limparCompleteBtn" ].mouseChildren = false;
			_desejoObj["infoComplete"][ "limparCompleteBtn" ].addEventListener( MouseEvent.CLICK, onClick );
			_desejoObj["infoComplete"][ "limparCompleteBtn" ].addEventListener( MouseEvent.MOUSE_OVER, onOver );
			_desejoObj["infoComplete"][ "limparCompleteBtn" ].addEventListener( MouseEvent.MOUSE_OUT, onOut );
		
			_desejoObj["infoComplete"][ "confirmarBtn" ].buttonMode = true;
			_desejoObj["infoComplete"][ "confirmarBtn" ].mouseChildren = false;
			_desejoObj["infoComplete"][ "confirmarBtn" ].addEventListener( MouseEvent.CLICK, onClick );
			_desejoObj["infoComplete"][ "confirmarBtn" ].addEventListener( MouseEvent.MOUSE_OVER, onOver );
			_desejoObj["infoComplete"][ "confirmarBtn" ].addEventListener( MouseEvent.MOUSE_OUT, onOut );
			
			_desejoObj["infoComplete"][ "envioBtn" ]["check1"].buttonMode = true;
			_desejoObj["infoComplete"][ "envioBtn" ]["check1"].mouseChildren = false;
			_desejoObj["infoComplete"][ "envioBtn" ]["check1"].addEventListener( MouseEvent.CLICK, onClick );
			//_desejoObj["infoComplete"][ "envioBtn" ]["check1"].addEventListener( MouseEvent.MOUSE_OVER, onOver );
			//_desejoObj["infoComplete"][ "envioBtn" ]["check1"].addEventListener( MouseEvent.MOUSE_OUT, onOut );
			
			if( _statusRH )
				_desejoObj["infoComplete"][ "envioBtn" ]["check1"].gotoAndStop("ATIVO");
			
			_desejoObj["infoComplete"][ "envioBtn" ]["check2"].buttonMode = true;
			_desejoObj["infoComplete"][ "envioBtn" ]["check2"].mouseChildren = false;
			_desejoObj["infoComplete"][ "envioBtn" ]["check2"].addEventListener( MouseEvent.CLICK, onClick );
			//_desejoObj["infoComplete"][ "envioBtn" ]["check2"].addEventListener( MouseEvent.MOUSE_OVER, onOver );
			//_desejoObj["infoComplete"][ "envioBtn" ]["check2"].addEventListener( MouseEvent.MOUSE_OUT, onOut );
			
		}
		
		//--------------------------------------
		// ZERAR DESEJO
		//--------------------------------------
		
		private function zerarDesejo(_inf)
		{
			for( var i = 1; i <= _cont; i++ )
			{
				_desejoObj[_inf]["trilha"]["desejo" + i ]["txt"].text = "";	
				
			}
			
			_cont = 0;
			_desejoArray = [];
			desejoAtual = 0;
			_statusRH = true;
			
			var reiLimiteINIT:Number = Number( _info["parameters"].hay.substr(0, 1));
			for ( var j = 1; j <= reiLimiteINIT; j++ )
			{
				_info["parameters"]["desejo" + j ] = null;
			}
			
			
			MovieClip(_desejoBTN)[ "desejoBtn" ]["cont"].text = 0;
			_info["parameters"].suspendData = "*";
			_info["parameters"].hay = "*";
			
			
			if (ExternalInterface.available) 
				ExternalInterface.call( "GravaLista", "0" , "0" , "0" , "0" , "0", "0" , "0", false );
		}
		
		
		//--------------------------------------
		// CONFIRMAR DESEJOS
		//--------------------------------------
		
		private function confirmarDesejos()
		{
			var _titulo1 = "";
			var _titulo2 = "";
			var _titulo3 = "";
			
			var _cargo1 = "";
			var _cargo2 = "";
			var _cargo3 = "";
			
			var _hay =  _info["parameters"].hay;
			
			trace(_desejoArray.length)
			if ( _desejoArray.length == 1 )
			{
				_titulo1 =  _desejoArray[0].TITULO;
				_titulo2 =  "0";
				_titulo3 =  "0";
				
				_cargo1 = _desejoArray[0].CARGO;
				_cargo2 = "0";
				_cargo3 = "0";
			}
			else if ( _desejoArray.length == 2 )
			{
				_titulo1 =  _desejoArray[0].TITULO;
				_titulo2 =  _desejoArray[1].TITULO;
				_titulo3 =  "0";
				
				_cargo1 = _desejoArray[0].CARGO;
				_cargo2 = _desejoArray[1].CARGO;
				_cargo3 = "0";
			}
			else if ( _desejoArray.length == 3 )
			{
				_titulo1 =  _desejoArray[0].TITULO;
				_titulo2 =  _desejoArray[1].TITULO;
				_titulo3 =  _desejoArray[2].TITULO;
				
				_cargo1 = _desejoArray[0].CARGO;
				_cargo2 = _desejoArray[1].CARGO;
				_cargo3 = _desejoArray[2].CARGO;
			}
			
			//
			trace( _cargo1 , _titulo1 , _cargo2 ,  _titulo2, _cargo3, _titulo3, _hay,  _statusRH );
			
			//
			if (ExternalInterface.available) 
				ExternalInterface.call("GravaLista", _cargo1 , _titulo1 , _cargo2 ,  _titulo2, _cargo3, _titulo3, _hay,  _statusRH );
		}
		
		//--------------------------------------
		// ENVIO
		//--------------------------------------
		
		private function controleEnvio( _envio )
		{
			if ( _envio.name == "check2" )
			{
				_desejoObj["infoComplete"][ "envioBtn" ]["check1"].gotoAndStop("INATIVO");
				_desejoObj["infoComplete"][ "envioBtn" ]["check2"].gotoAndStop("ATIVO");
				
				//
				_statusRH = false;
			}
			else
			{
				_desejoObj["infoComplete"][ "envioBtn" ]["check1"].gotoAndStop("ATIVO");
				_desejoObj["infoComplete"][ "envioBtn" ]["check2"].gotoAndStop("INATIVO");
				
				//
				_statusRH = true;
			}
		}
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		private function onClick(e:MouseEvent)
		{
			if (e.currentTarget.name == "desejoBtn" )
			{
				desejoEvent();
			}
			else if (e.currentTarget.name == "limparBtn" )
			{
				zerarDesejo("info");
				homeEvent();
			}
			else if (e.currentTarget.name == "limparCompleteBtn" )
			{
				zerarDesejo("infoComplete");
				homeEvent();
			}
			else if (e.currentTarget.name == "confirmarBtn" )
			{
				confirmarDesejos();
				homeEvent();
			}
			else if (e.currentTarget.name == "check1" )
			{
				controleEnvio( e.currentTarget );
			}
			else if (e.currentTarget.name == "check2" )
			{
				controleEnvio( e.currentTarget );
			}
			else if (e.currentTarget.name == "voltar" )
			{
				trace("voltar");
				homeEvent();
			}
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