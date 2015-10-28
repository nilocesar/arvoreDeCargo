package com.tree 
{
	import com.tree.*;
	import flash.utils.*;
	
	public class TreeNodes
	{
		private var _indexInicial:int;
		private var _indexFinal:int;
		private var _seachTreeArray:Array = []; 
		
		private var nodeContainer:Dictionary = new Dictionary();
		private var nodeParent = new Object();
		
		public var pathsNodes:Array = []; 
		
		public function TreeNodes( _dict:Dictionary )
		{
			nodeContainer = _dict;
		}
		
		public function callTreeNodes( _iInicial , _iFinal )
		{
			_indexInicial = _iInicial;
			_indexFinal = _iFinal;
			
			if ( _indexInicial > _indexFinal  )
			{
				_indexInicial = _iFinal;
				_indexFinal =  _iInicial;
			}
			
			nodeParent = new Object();
			
			nodeParent = { "parent": null,  "id" : nodeContainer[ _indexInicial ].ID , "children": [] };
			
			
			defineChildren( nodeParent , nodeContainer[ _indexInicial ] , nodeContainer[_indexFinal ].TIMELINE );
			createPaths( nodeParent ,  nodeContainer[ _indexInicial ].ID ,  nodeContainer[ _indexFinal ].ID  );
		}
		
		private function defineChildren( _parent:Object , _childrenInicial:* , _childrenFinal:Array  )
		{
			var _childrenArray = [];
			for (var i = 0; i < _childrenInicial.TIMELINE.length; i++  )
			{
				_childrenArray.push(  {  "parent": _childrenInicial.ID, "id" : _childrenInicial.TIMELINE[i] , "children": [] }  );
			}
			
			_parent.children = _childrenArray;
			
			for ( var j = 0; j < _parent.children.length; j++  )
			{
				for( var key:* in nodeContainer ) 
				{	
					if ( _parent.children[j].id == nodeContainer[ key ].ID && nodeContainer[ key ].TIMELINE[0] != "*"  )
					{
						if ( _childrenFinal !=  nodeContainer[ key ].TIMELINE )
						{
							defineChildren(  _parent.children[j]  , nodeContainer[ key ], _childrenFinal  );
						}
					}
				}
			}
		}
		
		private function createPaths( obj , ID_Inicial , ID_Final  )
		{
			pathsNodes = [];
			_seachTreeArray = [];
			_seachTreeArray.push( ID_Inicial );
			searchPaths( obj );
			
			for ( var i = 0; i < _seachTreeArray.length; i++ )
			{
				if ( _seachTreeArray[i].indexOf( ID_Inicial ) != -1 && _seachTreeArray[i].indexOf( ID_Final ) != -1  )
				{
					var pathArray:Array = _seachTreeArray[i].split("_");
					pathsNodes.push( pathArray );
				}
			}
		}
		
		private function searchPaths( obj )
		{
			var _pathOLD = "";
			_pathOLD = _seachTreeArray[  _seachTreeArray.length - 1 ]; 
			
			for ( var i = 0; i < obj.children.length; i++ )
			{
				var _path = _pathOLD  + "_" + obj.children[i].id;
				_seachTreeArray.push( _path );
				
				searchPaths(  obj.children[i] );
			}
		}
	}
}