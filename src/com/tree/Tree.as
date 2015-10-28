package com.tree
{
	import de.polygonal.ds.*;
	import com.tree.*;
	import com.maccherone.json.JSON;
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import com.includes.globalVars;
	import com.includes.Debug;
	import com.includes.PanZoomMap;
	import com.tree.Lab;

	public class Tree extends MovieClip
	{
		//
		public var nodeInfo:*;
		
		//
		private var container:MovieClip;

		// GlobalVars
		private var _globalVars = new globalVars();
		
		private var _treeObj:TreeObj;//esta na lib do Main
		
		//
		private var treeJson:Object;
		private var treeInfo:Object;
		private var info:Dictionary = new Dictionary();
		private var areaPath:String = "";
		private var status = "home";
		
		//
		private var _treeData:TreeData;
		
		//PAN/ZOOM
		private var pz:PanZoomMap;
		private var mapImg:Sprite = new Sprite();
		private var zoomPlus:Sprite = new Sprite();
		private var zoomMinus:Sprite = new Sprite();
		private var zoom_Amount = 1.5;
		private var zoom_Amount_init = 0;
		private var hand:Boolean = false;
		
		
		///LAB
		private var lab:Lab;
		
		public function Tree( _info , _treeInfo, _status = "*" )
		{
			//
			
			//
			info = _info;
			treeInfo = _treeInfo;
			areaPath =  _globalVars.get( "PATH" ) + "json/" + treeInfo.departamento +"/" + treeInfo.area + ".json";;
			status = _status;
			
			//
			init();
			jsonInit();
			treeInit();
			labInit();
		}
		
		//--------------------------------------
		//  EVENT/PUBLIC
		//--------------------------------------
		
		public function treeSubarea():void
		{
			dataSubarea();
		}
		
		private function infoActiveEvent():void
		{
			dispatchEvent(new Event("INFO_EVENT"));
		} 
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
		}
		
		
		//--------------------------------------
		// JSON INIT
		//--------------------------------------
		
		private function jsonInit()
		{
			var urlRequest:URLRequest  = new URLRequest( areaPath );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}	
		}
		
		private function completeHandler(e:Event):void
		{
			//
			var loader:URLLoader = URLLoader(e.target);
			treeJson = JSON.decode(loader.data);
			treeDataInit();
		}
		
		//--------------------------------------
		// TREE INIT
		//--------------------------------------
		
		private function treeInit()
		{
			_treeObj = new TreeObj();
			container.addChild( _treeObj );
		}
		
		//--------------------------------------
		// TREE DATA
		//--------------------------------------
		
		private function treeDataInit()
		{
			//
			info["parameters"]["areaCurrent"] = treeInfo.area;
			info["parameters"]["departamentoCurrent"] = treeInfo.departamento;
			
			//
			var _departamento = (  info["config"]["menu"][ treeInfo.departamento ]["departamento"] );
			var _area = (  info["config"]["menu"][ treeInfo.departamento ][ treeInfo.area ][0] );
			var _descricao = (  info["config"]["menu"][ treeInfo.departamento ][ treeInfo.area ][1] );
			
			_treeObj.gotoAndStop( treeInfo.departamento );
			
			_treeObj["departamento"].htmlText = _departamento;
			_treeObj["area"].htmlText = _area;
			_treeObj["descricao"]["txt"].htmlText = _descricao;
			
			
			_treeData = new TreeData( treeInfo, treeJson, info, status , lab );
			_treeData.name = "treeData";
			mapImg.addChild( _treeData );
			_treeData.x += 100; 
			_treeData.y += 130;
			
			//
			_treeData.addEventListener( "CLICK_EVENT", clickEvent );	
			_treeData.addEventListener( "NODE_INFO_EVENT", nodeInfoEvent );	
			
			//
			panZoomInit();
			
			
			// TREE SUBAREA
			if( treeInfo.status == "alternativa" )
				dataSubarea();
			
			if ( treeInfo.status == "alternativa" || treeInfo.status == "possivel" )
			{
				_treeObj["titulo"].gotoAndStop( treeInfo.status );
				_treeObj["titulo"]["trilha"].text = _area;
			}
			
		}
		
		private function clickEvent(e:Event)
		{
			nodeInfo = e.currentTarget.nodeInfo;
			pz.zoomTo(1);
			
			var infoPoint:Point = new Point();
			infoPoint.x =  nodeInfo.x;
			infoPoint.y =  nodeInfo.y + 50;
			
			pz.panTo(infoPoint);
			_treeObj["zoom"]["minus"].gotoAndStop("UP");
			_treeObj["zoom"]["auto"].gotoAndStop("UP");
			_treeObj["zoom"]["plus"].gotoAndStop("INATIVE");
		}
		
		
		private function nodeInfoEvent(e:Event)
		{
			nodeInfo = e.currentTarget.nodeInfo;
			infoActiveEvent();
		}
		
		//--------------------------------------
		// DATA SUBAREA
		//--------------------------------------
		
		private function dataSubarea()
		{	
			var _departamento = (  info["config"]["menu"][treeInfo.departamento ]["departamento"] );
			var _area = (  info["config"]["menu"][ treeInfo.departamento ][ treeInfo.area ][0] );
			var _descricao = (  info["config"]["menu"][ treeInfo.departamento ][ treeInfo.area ][1] );
			
			//
			if ( _treeObj.currentFrameLabel != "subarea" )
			{
				_treeObj.gotoAndStop( "subarea" );
				_treeObj["titulo"]["trilha"].text = _area;
			}
			else
			{
				_treeObj.gotoAndStop( treeInfo.departamento );
				
				_treeObj["departamento"].text = _departamento;
				_treeObj["area"].text = _area;
				_treeObj["descricao"]["txt"].text = _descricao;
			}
			
			//
			_treeData.dataSubarea( _treeObj );
			controleZoom();
		}
		
		
		//--------------------------------------
		// PAN / ZOOM
		//--------------------------------------
		
		private function panZoomInit():void
		{
			drawMapZoom();	
			pz = new PanZoomMap( mapImg, _treeObj["tree"].width, _treeObj["tree"].height );
			pz.x = _treeObj["tree"].x;
			pz.y = _treeObj["tree"].y;
			zoom_Amount_init = pz.zoomAmount;
			var zoomIndex:uint = _treeObj["zoom"].parent.getChildIndex( _treeObj["zoom"] );
			_treeObj.addChildAt( pz , zoomIndex );
			//
			
			lab.pzActive( pz );
			
			//
			mapImg.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 1000);
			mapImg.addEventListener(MouseEvent.MOUSE_OUT,  onOut, false, 1000);
		}
		
		// 
		private function drawMapZoom():void
		{
			mapImg.graphics.beginFill(0xcccccc, 0);///map com alpha 0
			mapImg.graphics.drawRect(0,0,_treeData.width + _treeData.x, _treeData.height + _treeData.y);
			mapImg.graphics.endFill();
			
			// 
			controleZoom();	
		}
		
		private function controleZoom():void
		{
			//
			_treeObj["zoom"]["plus"].buttonMode = true;
			_treeObj["zoom"]["minus"].buttonMode = true;
			_treeObj["zoom"]["auto"].buttonMode = true;
			
			//
			_treeObj["zoom"]["plus"].addEventListener(MouseEvent.CLICK,zoomIn);
			_treeObj["zoom"]["plus"].addEventListener(MouseEvent.MOUSE_OVER,zoomMouseOver);
			_treeObj["zoom"]["plus"].addEventListener(MouseEvent.MOUSE_OUT, zoomMouseOut);
			
			_treeObj["zoom"]["minus"].gotoAndStop("INATIVE");
			_treeObj["zoom"]["minus"].addEventListener(MouseEvent.CLICK, zoomOut);
			_treeObj["zoom"]["minus"].addEventListener(MouseEvent.MOUSE_OVER,zoomMouseOver);
			_treeObj["zoom"]["minus"].addEventListener(MouseEvent.MOUSE_OUT, zoomMouseOut);
			
			_treeObj["zoom"]["auto"].gotoAndStop("INATIVE");
			_treeObj["zoom"]["auto"].addEventListener(MouseEvent.CLICK, zoomAuto);
			_treeObj["zoom"]["auto"].addEventListener(MouseEvent.MOUSE_OVER,zoomMouseOver);
			_treeObj["zoom"]["auto"].addEventListener(MouseEvent.MOUSE_OUT, zoomMouseOut);
			
			setTimeout(function() {
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				stage.focus = stage;
			}, 1000 * 1)
		}
		
		
		//--------------------------------------
		// LAB DATA
		//--------------------------------------
		
		private function labInit()
		{
			lab = new Lab();
			container.addChild( lab );
		}
		
		//--------------------------------------
		// MOUSE EVENT
		//--------------------------------------
		
		
		private function handleMouseWheel(event:MouseEvent):void {
			
			//
			if (event.delta > 0 ) /// menos zoom
			{
				zoomIn(null);
			}
			else if (event.delta < 0 ) /// mais zoom
			{
				zoomOut(null);
			}
		}
				
		private function onOver(e:MouseEvent)
		{
			if(hand)
				Mouse.cursor = MouseCursor.HAND;
			else
				Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onOut(e:MouseEvent)
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function zoomIn(e:MouseEvent)
		{
			if (pz.zoomAmount < 1 )
			{
				//
				pz.zoomTo(pz.zoomAmount * zoom_Amount);
				
				//
				_treeObj["zoom"]["minus"].gotoAndStop("UP");
				_treeObj["zoom"]["auto"].gotoAndStop("UP");
				
			}
			else {
				_treeObj["zoom"]["plus"].gotoAndStop("INATIVE");
			}
			
			hand = true;
		}
		
		private function zoomOut(e:MouseEvent)
		{
			if (pz.zoomAmount / zoom_Amount >= pz.minZoom)
			{
				pz.zoomTo(pz.zoomAmount / zoom_Amount);
				_treeObj["zoom"]["plus"].gotoAndStop("UP");
			}
			else
			{
				_treeObj["zoom"]["minus"].gotoAndStop("INATIVE");
				_treeObj["zoom"]["auto"].gotoAndStop("INATIVE");
				
				pz.zoomTo(pz.minZoom);
				hand = false;
			}
				
		}
		
		private function zoomAuto(e:MouseEvent)
		{
			pz.zoomTo(zoom_Amount_init);
			hand = false;
			
			//
			_treeObj["zoom"]["plus"].gotoAndStop("UP");
			_treeObj["zoom"]["minus"].gotoAndStop("INATIVE");
			_treeObj["zoom"]["auto"].gotoAndStop("INATIVE");
		}
		
		private function zoomMouseOver(e:MouseEvent)
		{
			if ( e.currentTarget.currentFrameLabel != "INATIVE")
			{
				e.currentTarget.buttonMode = true;
				e.currentTarget.gotoAndStop("OVER");
			}
			else
			{
				e.currentTarget.buttonMode = false;
			}		
		}
		
		private function zoomMouseOut(e:MouseEvent)
		{
			if ( e.currentTarget.currentFrameLabel != "INATIVE")
			{
				e.currentTarget.buttonMode = true;
				e.currentTarget.gotoAndStop("UP");
			}
			else
			{
				e.currentTarget.buttonMode = false;
			}
		}
	}
}
