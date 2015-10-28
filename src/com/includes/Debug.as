package com.includes 
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import com.Main
	
	public class Debug extends MovieClip
	{
		public var rows:uint;
        public var cols:uint;
        public var cell:Array = new Array();
        public var plot:Array = new Array();
		private var container:MovieClip;
		
		
		public function Debug(  _row, _cols, _margenX , _margenY ) 
		{
			init();
			Grid( _row + 1, _cols + 1, _margenX, _margenY);
		}
		
		
		//--------------------------------------
		// INIT
		//--------------------------------------
		
		private function init()
		{
			container = new MovieClip();
			addChild( container );
			container.visible = false;
			Main.STAGE.addEventListener(KeyboardEvent.KEY_UP, onKeyBoardUp);
		}
		
		
		
		private function onKeyBoardUp(e:KeyboardEvent):void
		{if ( e.ctrlKey ) //if control key is down
			{
				if ( e.altKey ) //if shift key is also down
				{
					switch ( e.keyCode )
					{
						case Keyboard.V : //if control+alt+V 
							container.visible = !container.visible;						
						break;
					}
				}
			}
		}
		
		//--------------------------------------
		// CREATE GRID
		//--------------------------------------
		
		
		private function Grid(  rows, cols,  _magenX , _magenY  )
		{
			this.rows   = rows;
            this.cols   = cols;
            
            populateCells( _magenX , _magenY );
            plotCells(cell);
		}
		 
		private function populateCells(   _magenX , _magenY )
		{    
            var iterator:uint = 0;
            for(var c:uint = 0;c<cols;c++){ 
                for (var r:uint = 0; r < rows; r++)
				{                                         
                    cell[iterator] = new Sprite();
					var g:Graphics = cell[iterator].graphics;
					g.lineStyle(1, 0xCCCCCC);
					//g.beginFill(0xF2F2F2);
					g.drawRoundRect(0, 0, 50, 50, 0);
					g.endFill();
				
                    cell[iterator].y = cell[iterator].height  * r + (_magenY*r);
                    cell[iterator].x = cell[iterator].width * c + (_magenX*c);
                    container.addChild(cell[iterator]);  
					
					
					var lbl:TextField = label( (r+1), c );
					lbl.x = lbl.y = cell[iterator].width/2 - 10;
					cell[iterator].addChild(lbl);
					
					
                    iterator++
                }
            }           
        }
        
        private function plotCells(cell:Array){         
            
            var iterator:uint = 0;
            for(var c:uint = 0;c<cols;c++){
                plot[c] = new Array;
                for(var r:uint = 0;r<rows;r++){                 
                    plot[c][r] = cell[iterator];
                    iterator++                  
                }
            }           
        }
		
		
		private function label( row:int, column:int):TextField 
		{
			var tf:TextField = new TextField();
			tf.width = 80;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = tf.wordWrap = true;
			tf.defaultTextFormat = new TextFormat("Arial", 12, 0x004824);
			tf.text = convert( column ) + row;
			return tf;
		}
		
		private function convert(number:Number):String
		{
			var letters:Array = [];
			letters.push( "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",  
					"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",  
					"U", "V", "W", "X", "Y", "Z", "!", "@", "#", "$", "%", "¨", "&", "*", "(", ")" );
 
			return letters[number];
		}
	}
}