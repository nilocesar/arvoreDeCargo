package com.tree 
{
	import flash.display.*;
	import com.includes.globalVars;
	
	public class Lab extends MovieClip
	{
		private var _lab:LabObj
		private var container:MovieClip;
		private var pz:*;

		// GlobalVars
		private var _globalVars = new globalVars();
		
		public function Lab() 
		{
			container = new MovieClip();
			addChild(container);
			
			_lab = new LabObj();
			container.addChild( _lab );
			_lab.visible = false;
		}
		
		public function pzActive( _pz )
		{
			pz = ( _pz );
		}
		
		public function labOver( _txt )
		{
			if ( pz.zoomAmount < 0.92 )
			{
				_lab["txt"].text = _txt;
				_lab["txt"].y = _lab["fundo"].y + _lab["fundo"].height / 2 -_lab["txt"].textHeight / 2;
				
				_lab.visible = true
				_lab.x = mouseX;
				_lab.y = mouseY;
			}
		}
		
		public function labOut()
		{
			_lab.visible = false;
		}
		
	}

}