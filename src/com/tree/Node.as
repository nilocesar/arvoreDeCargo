package com.tree
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import fl.motion.Color;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
    import flash.text.TextLineMetrics;
	
	import com.includes.globalVars;
	
	public class Node extends Sprite
	{
		//
		public var ID:String;
		public var CARGO:String;
		public var TITULO:String;
		public var DEPARTAMENTO:String;
		public var AREA:String;
		public var CARGO_HOME:String;
		public var INDEX:Number = 0;
		public var ACTIVE:Number = 0;
		public var TIMELINE:Array;
		public var POSSIVEL:Array;
		public var DESEJO:Boolean = false;
		public var COMPLETE_DESEJO:Boolean = false;
		public var status:Boolean = false;
		public var column:Number = 0;
		public var row:Number = 0;
		
		//
		private var _globalVars = new globalVars();
		private var currentStatus:String;
		
		//LIB
		private var _nodeContainer:nodeObj; // Na Biblioteca
		private var statusCurrent:Boolean = false; /// Verifica se o node é a do Usuário Vindo do LMS
		private var info:Dictionary;
		private var _lab:*;
		
		//
		private var _this = this;
		private var btnAll:int = 4;
		private var desejoAtivo:Boolean = false;

		//--------------------------------------
		// INIT
		//--------------------------------------
		
		public function Node( labObj, _info, _treeInfo, _column , _row , indexCurrent, _titulo, _indexStatus, _timeline, _possivel , _currentStatus = "home"  )
		{
			INDEX = indexCurrent;
			TIMELINE = _timeline;
			CARGO = _indexStatus;
			POSSIVEL = _possivel;
			TITULO = _titulo;
			DEPARTAMENTO = _treeInfo.departamento;
			AREA = _treeInfo.area;
			_lab = labObj;
			
			column = _column;
			row = _row;
			
			info = _info;
			
			this.x = _column;
			this.y = _row;	
			
			currentStatus = _currentStatus;
			
			ID = _globalVars.convertForString( column ) + _globalVars.stringIndex( row + 1 );
			
			if ( CARGO != "*" )
			{
				//
				if ( _currentStatus != "possivel" && _currentStatus != "alternativa"  )
				{
					this.buttonMode = true;
					this.mouseEnabled  = true;
					addEventListener(MouseEvent.CLICK, onClick, false, 1000);
					addEventListener(MouseEvent.MOUSE_OVER , onRollOver, false, 1000);
					addEventListener(MouseEvent.MOUSE_OUT,  onRollOut, false, 1000);
				}
				else
				{
					this.buttonMode = false;
					this.mouseEnabled  = false;
				}
				
				drawNode();
				write( _titulo );
			}
		}
		
		
		//--------------------------------------
		// EVENT/PUBLIC
		//--------------------------------------
		
		public function removeActive()
		{
			if ( MovieClip(_nodeContainer) != null )
			{
				this.status = false;
				MovieClip(_nodeContainer).gotoAndStop( "UP" );
				
				if ( statusCurrent )
					MovieClip(_nodeContainer)["up"].gotoAndStop( 2 );
				
				
				this.buttonMode = true;
				this.mouseEnabled  = true;
				this.mouseChildren = true;
				this.addEventListener(MouseEvent.CLICK, onClick ); 
			}
		}
		
		public function nodeCurrent( _current ):void
		{
			CARGO_HOME = _current;
			statusCurrent = true;
			MovieClip(_nodeContainer)["up"].gotoAndStop( 2 );
			//MovieClip(_nodeContainer)["active"][ "btn2" ].visible = false;
		}
		
		public function nodeInativo():void
		{
			if ( CARGO != "*" )
				MovieClip(_nodeContainer)["up"].gotoAndStop( "inativo" );
		}
		
		public function nodePossivel():void
		{
			MovieClip(_nodeContainer)["up"].gotoAndStop( "possivel" );
			
			//
			this.buttonMode = true;
			this.mouseEnabled  = true;
			addEventListener(MouseEvent.CLICK, onClickPossivel, false, 1000);
			
			controlDesejo();
		}
		
		
		public function nodeSubarea( _total, _sub , _departamento , _treeObj , _dados ):void
		{
			subAreaTint( _total, _sub, _departamento , _treeObj , _dados );
		}
		
		public function write( titulo:String ):void
		{
			MovieClip(_nodeContainer).txt.text = titulo;
			MovieClip(_nodeContainer).txt.y +=  MovieClip(_nodeContainer).label.height / 2 - MovieClip(_nodeContainer).txt.textHeight / 2;
		}
		
		private function overEvent():void
		{
			dispatchEvent(new Event("OVER_EVENT"));
		}
		
		private function outEvent():void
		{
			dispatchEvent(new Event("OUT_EVENT"));
		}
		
		private function clickEvent():void
		{
			dispatchEvent(new Event("CLICK_EVENT"));
		}
		
		private function activeEvent():void
		{
			dispatchEvent(new Event("ACTIVE_EVENT"));
		}
		
		//--------------------------------------
		// DRAW NODE
		//--------------------------------------
		
		private function drawNode():void
		{
			_nodeContainer = new nodeObj();
			addChild( _nodeContainer );
		}
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		private function onClick(e:MouseEvent):void
		{
			status = true;
			MovieClip(_nodeContainer).gotoAndStop( "ACTIVE" );
			controleActive();
			clickEvent();
			
			if ( statusCurrent )
					MovieClip(_nodeContainer)["active"].gotoAndStop( 2 );
					
			e.currentTarget.buttonMode = false;
			e.currentTarget.mouseEnabled  = false;
			e.currentTarget.mouseChildren = true;
			e.currentTarget.removeEventListener(MouseEvent.CLICK, onClick );
			_lab.labOut();
		}
		
		private function onRollOver(e:MouseEvent):void
		{	
			if (!status)
			{
				MovieClip(_nodeContainer).gotoAndStop( "OVER" );
				
				if ( statusCurrent )
					MovieClip(_nodeContainer)["over"].gotoAndStop( 2 );
				
				_lab.labOver( TITULO );
			}
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			if (!status)
			{
				MovieClip(_nodeContainer).gotoAndStop( "UP" );
				
				if ( statusCurrent )
					MovieClip(_nodeContainer)["up"].gotoAndStop( 2 );
			}
			
			Mouse.cursor = MouseCursor.HAND;
			
			//
			_lab.labOut();
		}
		
		private function onClickPossivel(e:MouseEvent):void
		{
			clickEvent();
		}
		
		//--------------------------------------
		// CONTROLE ACTIVE
		//--------------------------------------
		
		private function controleActive()
		{
			for (var i = 1 ; i <= btnAll; i++ )
			{
				MovieClip(_nodeContainer)["active"]["btn" + i ].index = i;
				MovieClip(_nodeContainer)["active"]["btn" + i ].buttonMode = true;
				MovieClip(_nodeContainer)["active"]["btn" + i ].addEventListener(MouseEvent.CLICK, activeClick, false, 1000);
				MovieClip(_nodeContainer)["active"]["btn" + i ].addEventListener(MouseEvent.MOUSE_OVER, activeOver, false, 1000);
				MovieClip(_nodeContainer)["active"]["btn" + i ].addEventListener(MouseEvent.MOUSE_OUT,  activeOut, false, 1000);
			}
			
			//
			controlDesejo();
			
			///Se for o CARGO --- do Usuario -- remove o btn de ADD desejo
			if (statusCurrent)
			{
				MovieClip(_nodeContainer)["active"]["btn1"].x = 0;
				MovieClip(_nodeContainer)["active"]["btn2"].visible = false;
			}
			
			
			if ( CARGO == "CSC" )
			{
				MovieClip(_nodeContainer)["active"]["btn2"].visible = false;
				MovieClip(_nodeContainer)["active"]["btn3"].visible = false;
				MovieClip(_nodeContainer)["active"]["btn4"].visible = false;
				
				MovieClip(_nodeContainer)["active"]["btn1"].x = 0;
				MovieClip(_nodeContainer)["active"]["btn1"].y = -100;
			}
			
			if (!DESEJO)
			{
				MovieClip(_nodeContainer)["active"]["btn2"].gotoAndStop( 2 );
				//MovieClip(_nodeContainer)["active"]["btn2"]["balaoInfo"].visible = false;
			}
		}
		
		private function activeClick(e:MouseEvent)
		{	
			ACTIVE = e.currentTarget.index;
			
			if ( e.currentTarget.name == "btn1" ) ///PERFIL
			{
				activeEvent();
			}
			else if( e.currentTarget.name == "btn2" ) ///DESEJO
			{
				clickDesejo( e.currentTarget );
			}
			else if( e.currentTarget.name == "btn3" ) ///Possivel
			{
				activeEvent();
			}
			else if( e.currentTarget.name == "btn4" )  ///Alternativa
			{
				activeEvent();
			}
			
		}
		
		private function activeOver(e:MouseEvent)
		{
			if( e.currentTarget.name != "btn2" )
			{
				e.currentTarget.gotoAndStop("OVER");
			}
			else ///DESEJO
			{
				e.currentTarget["desejoInit"].gotoAndStop("OVER");
			}
			
		}
		
		private function activeOut(e:MouseEvent)
		{
			if( e.currentTarget.name != "btn2" )
			{
				e.currentTarget.gotoAndStop("UP");
			}
			else ///DESEJO
			{
				e.currentTarget["desejoInit"].gotoAndStop("UP");
			}
		}
		
		//--------------------------------------
		// CONTROLE DESEJO
		//--------------------------------------
		
		private function controlDesejo()
		{
			var suspendDataArray:Array = info["parameters"].suspendData.split(",");
			suspendDataArray = _globalVars.removeArray( suspendDataArray );
			
			var reiLimiteINIT:Number = info["parameters"].hay.substr(0, 1);
			var reiLimiteADD:Number = Number(info["parameters"].hay.substr(2, 3));
			var _colunaCargoUser =  _globalVars.convertForNumber( String( info["parameters"].cargoID ).substr(0, 1) );
			var _initPosition = (column - _colunaCargoUser);
						
			
			if( suspendDataArray.length < info["config"].rei.length ) /// --> verifica se o suspendata esta vázio
			{	
				if ( info["parameters"].hay == "*" ) /// Quando Vázio Vale a primeira regra do REI 
				{
					for (var j = 0; j < info["config"].rei[0].length; j++ )
					{
						var reiLimite = Number( info["config"].rei[0][j].substr(2, 3) );
						
						if( column == ( _colunaCargoUser + reiLimite ) )
							DESEJO = true;
					}
					
					if ( AREA == info["parameters"].cargoAREA  )///serve para conferir se esta na timeline do Cargo do usuário
					{
						var _cargosLigados = info["parameters"].cargoTIMELINE; 
						for (var k = 0; k < _cargosLigados.length; k++ )
						{
							if ( _cargosLigados[k] == ID )
								DESEJO = true;
						}
					}
					
				}
				else
				{
					if ( reiLimiteINIT == 1 )
					{	
						if ( _initPosition >= reiLimiteADD )
						{
							if( ( reiLimiteADD == _initPosition ) ||  ( reiLimiteADD + 1 == _initPosition )  )
							{
								DESEJO = true;
							}
						}
						
						desejoPreenchido();
						
					}
					else if ( reiLimiteINIT == 2 )
					{
						if ( _initPosition >= reiLimiteADD )
						{
							if( ( reiLimiteADD == _initPosition ) ||  ( reiLimiteADD + 1 == _initPosition )  )
							{
								DESEJO = true;
							}
						}
						
						desejoPreenchido();
					}
					else if ( reiLimiteINIT == 3 )//Complete
					{
						DESEJO = false;
					}
				}
			}
			else //Complete
			{
				DESEJO = false;
			}
		}
		
		private function desejoPreenchido()
		{
			var suspendDataArray:Array = info["parameters"].suspendData.split(",");
			suspendDataArray = _globalVars.removeArray( suspendDataArray );
			
			for ( var i = 0; i < suspendDataArray.length; i++ )
			{
				if ( suspendDataArray[i] == CARGO )
				{
					DESEJO = false;
				}
			}
		} 
		
		private function clickDesejo( _current )
		{
			if ( !DESEJO )
			{
				//_current.balaoInfo.visible = !_current.balaoInfo.visible;
			}
			else
			{
				//Zerar o BTN2
				MovieClip(_nodeContainer).gotoAndStop( "UP" );
				setTimeout(function()
				{
					_this.buttonMode = false;
					_this.mouseEnabled  = true;
					_this.mouseChildren = false;
					_this.addEventListener(MouseEvent.CLICK, onClick );
				}, 1000 * 0.3);
				//Zerar o BTN2
				
				//
				controleDesejo();
				activeEvent();
			}
		}
		
		public function controleDesejo()
		{
			var _colunaCargoUser = _globalVars.convertForNumber( String( info["parameters"].cargoID ).substr(0, 1) );
			var _initPosition = (column - _colunaCargoUser);
			var reiLimiteINIT:Number = Number(info["parameters"].hay.substr(0, 1)) + 1;
			
			if ( info["parameters"].hay != "*"  ) 
			{
				info["parameters"].hay = reiLimiteINIT +"_" + ( _initPosition );
				info["parameters"]["desejo" + reiLimiteINIT ] = { "info": { "cargo":TITULO }};
			}
			else /// Quando Vázio Vale a primeira regra do REI 
			{
				info["parameters"].hay = 1 +"_" + _initPosition;
				info["parameters"]["desejo" + 1 ] = { "info": { "cargo":TITULO }};
			}
			
			//
			incrementarDesejo( CARGO );
			trace(info["parameters"].hay)
		}
		
		public function incrementarDesejo( _cargo )
		{
			DESEJO = false;
			
			var suspendDataArray:Array = info["parameters"].suspendData.split(",");
			suspendDataArray = _globalVars.removeArray( suspendDataArray );
			suspendDataArray.push( _cargo );
			
			if ( suspendDataArray.length == 1 )
			{
				info["parameters"].suspendData = suspendDataArray[0] + ",*" + ",*";
			}
			else if ( suspendDataArray.length == 2 )
			{
				info["parameters"].suspendData = suspendDataArray[0] + "," + suspendDataArray[1] + ",*";
			}
			else if ( suspendDataArray.length == 3 )
			{
				info["parameters"].suspendData = suspendDataArray[0] + "," + suspendDataArray[1] + "," + suspendDataArray[2];
			}
		}
		
		
		//--------------------------------------
		// CONTROLE SUBAREA
		//--------------------------------------
		
		
		private function subAreaTint( _total, _sub, _info, _treeObj , _dado )
		{
			if ( MovieClip(_nodeContainer)["subarea"].alpha == 0 )
			{
				var c:Color = new Color();
				c.setTint( getBetweenColourByPercent( _sub / _total , _globalVars.returnColor(  _info.departamento  ) )  , 1 );
				
				MovieClip(_nodeContainer)["subarea"].transform.colorTransform = c;
				MovieClip(_nodeContainer)["subarea"].alpha = 1;
			
				//
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ]["ico"].transform.colorTransform = c;
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ]["subAreaTxt"]["txt"].text = _dado["nome"];
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].alpha = 1;
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].resumo = _dado["resumo"];
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].nome = _dado["nome"];
				
				//
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].buttonMode = true;
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].addEventListener( MouseEvent.MOUSE_OVER, onRollSubOver );
				MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].addEventListener( MouseEvent.MOUSE_OUT,  onRollSubOut );
				
				///Controle Para Alternativa
				if ( currentStatus == "alternativa" )
				{
					var _alternativaInfo = info["cargo"].perfil.alternativa[ _info.departamento ][ _info.area ];
					if ( _alternativaInfo.indexOf( "sub" + ( _sub + 1 ) ) == -1 )
					{
						MovieClip(_nodeContainer)["subarea"].alpha = 0;
						MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].alpha =0.15;
						MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].buttonMode = false;
						MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].removeEventListener( MouseEvent.MOUSE_OVER, onRollSubOver );
						MovieClip( _treeObj )["subarea"]["sub" + ( _sub + 1 ) ].removeEventListener( MouseEvent.MOUSE_OUT,  onRollSubOut );
					}
				}	
			}
			else
			{
				MovieClip(_nodeContainer)["subarea"].alpha = 0;
			}
		}
		
		
		private function getBetweenColourByPercent(value:Number = 0.5 /* 0-1 */, highColor:uint = 0xFFFFFF, lowColor:uint = 0xFFFFFF):uint {
			var r:uint = highColor >> 16;
			var g:uint = highColor >> 8 & 0xFF;
			var b:uint = highColor & 0xFF;

			r += ((lowColor >> 16) - r) * value;
			g += ((lowColor >> 8 & 0xFF) - g) * value;
			b += ((lowColor & 0xFF) - b) * value;

			return (r << 16 | g << 8 | b);
		}
		
		private function onRollSubOver(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OVER");
			//e.currentTarget["info"]["resumoTxt"].text = e.currentTarget.resumo;
			//e.currentTarget["info"]["nomeTxt"].text = e.currentTarget.nome;
			
			var inf = e.currentTarget["geral"]["inf"];
			inf.resumoTxt.autoSize = "left";
			inf.resumoTxt.text = e.currentTarget.resumo;
			var _heigthTxt = inf.resumoTxt.height;

			inf.resumoTxt.y =  (-_heigthTxt) - 6;
			inf.fundo.y = inf.resumoTxt.y;
			inf.y = e.currentTarget["geral"]["seta"].y;//inf.y + (inf.height - _heigthTxt) -1;
			inf.fundo.height = _heigthTxt + (_heigthTxt / 5);
			
		}	
		
		private function onRollSubOut(e:MouseEvent)
		{
			e.currentTarget.gotoAndStop("OUT");
		}	
	}
}
