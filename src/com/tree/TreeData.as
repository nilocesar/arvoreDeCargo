package com.tree
{
	import de.polygonal.ds.*;
	import com.tree.*;
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	
	import flash.events.*;
	import flash.display.*;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import com.includes.globalVars;
	import com.includes.Debug;
	
	
	public class TreeData extends MovieClip
	{

		// GlobalVars
		private var _globalVars = new globalVars();
		private var _debug:Debug;
		private var treeNodes:TreeNodes;
		private var graph:Graph;
		private var path:LinkedStack;
		private var nodeQue:LinkedQueue;
		private var _stage:*;
		private var _treeObj:*;
		private var _lab:*;
		
		private var _tileSize:Number = 30;
		private var _margenX:Number = 80;
		private var _margenY:Number = 60;
		private var _rowDebug:Number = 0;
		private var _colDebug:Number = 0;
		
		private var container:MovieClip;
		private var nodeCanvas:Sprite;
		private var graphicsMap:Sprite;
		private var linhaDraw:Graphics; 
		
		private var DATA_CONFIG_JSON:Object;
		private var _treeInfo:Object;
		private var nodeLookup:Dictionary;
		private var _info:Dictionary;
		private var _subAreas:Dictionary  = new Dictionary();
		private var _subAreasAll:Array = new Array();
		private var _status = "";
		
		//Public
		public var mapArrayControl:Array = [];
		public var nodeInfo:*;
		public var colunaCargoUser;
		public var initNode = 0;
		
		//Teste
		private var nodeCurrentIndex = "*";
		
		public function TreeData( treeInfo, treeJson ,info, status , lab )
		{
			//
			_treeInfo = treeInfo;
			_info = info;
			_status = status;
			_lab = lab;
			
			DATA_CONFIG_JSON = treeJson;
			
			//
			init();
			treeInit();
			mapJson();
		}
		
		//--------------------------------------
		//  EVENT/PUBLIC
		//--------------------------------------
		
		public function dataSubarea( _obj ):void
		{
			_treeObj  = _obj;
			nodeSubarea();
		}
		
		private function clickTreeEvent():void
		{
			dispatchEvent(new Event("CLICK_EVENT"));
		}
		
		private function infoActiveEvent():void
		{
			dispatchEvent(new Event("NODE_INFO_EVENT"));
		}
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			container.name = "container";
			addChild( container );
		}
		
		//--------------------------------------
		// TREE INIT
		//--------------------------------------
		
		private function treeInit()
		{
			graph = new Graph(200);
			
			///MAP
			graphicsMap = new Sprite();
			container.addChild(graphicsMap);
			
			nodeCanvas = new Sprite()
			container.addChild( nodeCanvas );
		}
		
		//--------------------------------------
		// MAP INIT
		//--------------------------------------
		
		private function mapJson()
		{
			nodeLookup = new Dictionary(true);
			var _index = 0;
			var row:Number = 0;
			var column:Number = 0;
			var nodeObj;
			for( var i:Number = 0; i < DATA_CONFIG_JSON.config.length; i++ )
			{
				_index ++;
				column = _globalVars.convertForNumber( String( DATA_CONFIG_JSON.config[i].ID ).substr(0, 1) );
				row = _globalVars.numberIndex( String( DATA_CONFIG_JSON.config[i].ID ).substr(1, 1) ) - 1;
				
				nodeObj = new Node( _lab,  _info, _treeInfo, column , row , _index,  DATA_CONFIG_JSON.config[i].titulo , DATA_CONFIG_JSON.config[i].index , 
									DATA_CONFIG_JSON.config[i].timeline , DATA_CONFIG_JSON.config[i].possivel, _status );
									
				nodeObj.buttonMode = true;
				nodeObj.mouseChildren = false;
				nodeObj.addEventListener( "CLICK_EVENT", clickEvent );
				nodeObj.addEventListener( "ACTIVE_EVENT", activeEvent );
				
				// ATIVAR POSSIVEIS
				if ( _status == "possivel" ) {
					
					var _possivelArray = _info["parameters"].possivel;
					nodeObj.nodeInativo();
					
					for ( var j = 0 ; j < _possivelArray.length; j++  )
					{
						if ( _possivelArray[j].perfil.index == DATA_CONFIG_JSON.config[i].index )
							nodeObj.nodePossivel();
					}
				}
				
				// ATIVAR CARGO do USUARIO
				if ( DATA_CONFIG_JSON.config[i].index == _info["parameters"].cargo ) {
					nodeObj.nodeCurrent( _info["parameters"].cargo );
					
					_info["parameters"].cargoAREA = _treeInfo.area;
					_info["parameters"].cargoTIMELINE = ( DATA_CONFIG_JSON.config[i].timeline );
				}
				
				//
				mapArrayControl.push( nodeObj );
				graph.addNode( nodeObj, _index );
				nodeLookup[ _index ] = nodeObj;
				_info["parameters"].containerNodes = mapArrayControl;
			}
			
			//
			drawMapComplete();
			drawLineComplete();
		}
		
		private function clickEvent( e:Event )
		{	
			var _numberAll = e.currentTarget.parent.numChildren - 1;
			e.currentTarget.parent.setChildIndex( e.currentTarget, _numberAll );
			nodeInfo = e.currentTarget;
			clickTreeEvent();
			
			for ( var i = 0; i < mapArrayControl.length; i++ )
			{
				if ( mapArrayControl[i] != e.currentTarget )
					mapArrayControl[i].removeActive();
			}
			
			if ( _status == "possivel" ) {
				infoActiveEvent();
			}
		}
		
		
		private function activeEvent( e:Event )
		{
			nodeInfo = e.currentTarget;
			infoActiveEvent();
		}
		
		//--------------------------------------
		// DRAW MAP COMPLETE
		//--------------------------------------
		
		private function drawMapComplete()
		{
			treeNodes = new TreeNodes( nodeLookup );
			
			for ( var i = 0; i < mapArrayControl.length; i++ )
			{
				//
				infoROW(i)
				
				//
				mapArrayControl[i].x = (_tileSize * mapArrayControl[i].column) + ( _margenX * mapArrayControl[i].column );
				mapArrayControl[i].y = (_tileSize * mapArrayControl[i].row) + ( _margenY * mapArrayControl[i].row );
				
				nodeCanvas.addChild( mapArrayControl[i] );
			}
			
			// Posicao X do primeiro Nodes -- GAMBIS do zoom
			initNode = mapArrayControl[0].x;
			
			//
			debugInit();
		}
		
		//--------------------------------------
		// INFO ROW/COL
		//--------------------------------------
		
		private function infoROW(i)
		{
			/// ROW - COL / USADO para DESEJO
			if ( _info["parameters"].rowALL < mapArrayControl[i].row )
				_info["parameters"].rowALL = mapArrayControl[i].row;
				
			if ( _info["parameters"].colALL < mapArrayControl[i].column )
				_info["parameters"].colALL = mapArrayControl[i].column;
			/// ROW - COL / USADO para DESEJO
			
			/// ROW - COL / USADO para o DEBUG
			if ( _rowDebug < mapArrayControl[i].row )
				_rowDebug = mapArrayControl[i].row;
				
			if ( _colDebug < mapArrayControl[i].column )
				_colDebug = mapArrayControl[i].column;
			/// ROW - COL / USADO para o DEBUG
		}
		
		
		//--------------------------------------
		// DRAW LINE COMPLETE
		//--------------------------------------
		
		private function drawLineComplete()
		{
			var filtrerTimelineArray:Array = [];
			
			for( var i:Number = 0; i < DATA_CONFIG_JSON.config.length; i++ )
			{
				for( var j:Number = 0; j < DATA_CONFIG_JSON.config[ i ].timeline.length; j++ )
				{
					var _timeline_mais_id:Array = [ DATA_CONFIG_JSON.config[ i ].ID , DATA_CONFIG_JSON.config[ i ].timeline[ j ]  ]
					filtrerTimelineArray.push( _timeline_mais_id  );
				}
			}
			
			for( i = 0; i < filtrerTimelineArray.length; i++ )
			{
				var _arc1 = _globalVars.convertForIndex( filtrerTimelineArray[i][0]  , mapArrayControl  );
				var _arc2 = _globalVars.convertForIndex( filtrerTimelineArray[i][1]  , mapArrayControl  );
				graph.addArc( _arc1 , _arc2, 1 );
			}
			draw();
		}
		
		
		//--------------------------------------
		// SETUP INIT
		//--------------------------------------
		
		private function draw():void
		{
			linhaDraw = graphicsMap.graphics;
			linhaDraw.clear();
			linhaDraw.lineStyle(3, _globalVars.returnColor(  _treeInfo.departamento  ) , 1);
			
			//draw all arcs originating from the given node
			for (var i:int = 0; i < graph.nodes.length; i++)
				if (graph.nodes[i]) graph.breadthFirst( graph.nodes[i], drawNodeArcs );
		}
		
		private function drawNodeArcs(node:GraphNode):void
		{
			var arcStart:Node = node.data;
			
			for( var i:int = 0; i < node.numArcs; i++ )
			{
				var arc:GraphArc = node.arcs[i];
				var arcTarget:Node = arc.node.data;
				
				var dx:Number = arcTarget.x - arcStart.x;
				var dy:Number = arcTarget.y - arcStart.y;
				var len:Number = Math.sqrt(dx * dx + dy * dy);
				
				var xdir:Number = dx / len;
				var ydir:Number = dy / len;
				
				drawArrow( linhaDraw, arcStart.x + xdir * ( 1 ), arcStart.y + ydir * (1),
						  xdir, ydir, len - 2 * (1), 4);
			}
		}
		
		private function drawArrow( g:Graphics, x:Number, y:Number, xdir:Number, ydir:Number, len:Number, size:Number )
		{
			var t:Number = 1 / Math.sqrt(xdir * xdir + ydir * ydir);
			
			var ex:Number = (xdir * t * len) + x;
			var ey:Number = (ydir * t * len) + y;
			
			g.moveTo(x, y);
			g.lineTo(ex, ey);
			
			var dx:Number = (ex - x);
			var dy:Number = (ey - y);
			
			var l:Number = Math.sqrt((dx * dx) + (dy * dy));
			if (l <= 0)	return;
			
			dx /= l;
			dy /= l;
			var nx:Number = -dy;
			var ny:Number =  dx;
			
		}
		
		
		//--------------------------------------
		// SUBAREA
		//--------------------------------------
		
		private function nodeSubarea()
		{			
			_subAreasAll = [];
			
			for (var i = 1; i <= 10; i++ )
			{
				if (_info["subareas"][ _treeInfo.departamento ][ _treeInfo.area ]["sub" + i ]["nome"] != "*" )
				{
					_subAreas[ "subarea" + i ]  = _info["subareas"][ _treeInfo.departamento ][ _treeInfo.area ]["sub" + i ];
					_subAreasAll.push( _subAreas[ "subarea" + i ] );
				}
				
				//Zerar as legendas
				if ( _treeObj.currentFrameLabel == "subarea" )
					MovieClip( _treeObj )["subarea"]["sub" + i ].alpha = 0;
			}
			
			if ( _subAreasAll.length > 0 )
			{
				filtroSubarea();
			}
			else
			{
				if ( _treeObj.currentFrameLabel == "subarea" )
				{
					var _resumo = _info["subareas"][ _treeInfo.departamento ][ _treeInfo.area ][ "subNULL" ]["resumo"];
					MovieClip( _treeObj )["subarea"]["sub" + 1 ].alpha = 1;
					MovieClip( _treeObj )["subarea"]["sub" + 1 ]["ico"].gotoAndStop(2);
					MovieClip( _treeObj )["subarea"]["sub" + 1 ]["subAreaTxt"].gotoAndStop(2);
					MovieClip( _treeObj )["subarea"]["sub" + 1 ]["subAreaTxt"]["txt"].text = _resumo;
				}
			}
		}
		
		
		private function filtroSubarea()
		{
			for (var i = 0; i < mapArrayControl.length; i++ )
			{
				for( var j = 0; j < _subAreasAll.length; j++ )
				{
					for( var k = 0; k < _subAreasAll[ j ]["timeline"].length; k++ )
					{
						if ( mapArrayControl[i].CARGO  == _subAreasAll[ j ]["timeline"][ k ] )
						{
							mapArrayControl[i].nodeSubarea( _subAreasAll.length, j , _treeInfo, _treeObj, _subAreasAll[ j ] );	
						}
					}
				}
			}
		}
		
		//--------------------------------------
		// DEBUG 
		//--------------------------------------
		
		private function debugInit()
		{
			_debug = new Debug(  _rowDebug , _colDebug , _margenX - 22, _margenY - 22  );
			container.addChild( _debug );
			_debug.x -= 25;
			_debug.y -= 25;
		}
	}
}
