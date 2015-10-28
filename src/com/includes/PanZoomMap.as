package com.includes
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Shape;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class PanZoomMap extends Sprite
	{
		
		private var mapImg;	// source image (map)
		private var mapWidth;	// width of source image
		private var mapHeight;
		private var size:Rectangle;	// size of viewable area
		private var masky:Shape = new Shape();	// mask for the viewable area
		
		private var panContainer:Sprite = new Sprite();		// PAN this container
		private var zoomContainer:Sprite = new Sprite();	// SCALE this container
		
		public var minZoom;		// minimum zoom level (scale), where the map just fits in the viewable area
		public var zoomAmount;	// current scale
		
		private var dragLimits:Rectangle;	// the boundaries in which the map can be panned, which changes with scale
		
		public function PanZoomMap(src,w,h):void
		{
			mapImg = src;
			mapWidth = src.width;
			mapHeight = src.height;
			size = new Rectangle(0,0,w,h);
			
			// map goes in the pan container
			panContainer.addChild(mapImg);
			// it's assumed here that the map has (0,0) at the upper left and is centered in panContainer accordingly
			//trace( mapImg.getChildAt( 0 ).initNode );
			
			///GAMBI PARA ACERTAR O ZOOM
			var posNodesInit = ( mapImg.getChildAt( 0 ).initNode )/2; 
			///GAMBI PARA ACERTAR O ZOOM
			
			mapImg.x = -mapWidth/2 - ( posNodesInit );
			mapImg.y = -mapHeight/2 + 20; // GAMBI --- para abaixar um pouco a trilha
			
			// panContainer goes inside zoomContainer
			zoomContainer.addChild(panContainer);
			// zoomContainer is centered within those whole thing
			zoomContainer.x = size.width/2;
			zoomContainer.y = size.height/2;
			
			// draw the mask so we can't see the map beyond the viewable area
			masky.graphics.beginFill(0);
			masky.graphics.drawRect(size.x,size.y,size.width,size.height);
			zoomContainer.mask = masky;
			
			addChild(zoomContainer);
			addChild(masky);
			
			panContainer.addEventListener(MouseEvent.MOUSE_DOWN,startPan);
			minZoom = Math.min( size.height / mapHeight, size.width / ( mapWidth - posNodesInit ) );	// zoom level at which the map will fit in the viewer
			zoomTo(minZoom);
		}
		
		// enable/disable click-and-drag panning
		public function set allowPanning(pan:Boolean):void
		{
			if (pan) {
				if (!panContainer.hasEventListener(MouseEvent.MOUSE_DOWN)) panContainer.addEventListener(MouseEvent.MOUSE_DOWN,startPan);
			} else {
				if (panContainer.hasEventListener(MouseEvent.MOUSE_DOWN)) panContainer.removeEventListener(MouseEvent.MOUSE_DOWN,startPan);
			}
		}
		public function get allowPanning():Boolean
		{
			if (panContainer.hasEventListener(MouseEvent.MOUSE_DOWN)) return true;
			else return false;
		}
		
		/* 	To zoom to a specified scale, change the scale of zoomContainer. It grows or shrinks around the origin
			point, which never moves in this case. No matter where panContainer is positioned within zoomContainer,
			when the zoom changes the same point will remain the center.
		*/
		public function zoomTo(scale):void
		{
			if (scale >= minZoom) {
				
				TweenMax.to(zoomContainer, 0.5, { scaleX:scale, scaleY:scale, ease:Linear } );
				//zoomAmount = zoomContainer.scaleX = zoomContainer.scaleY = scale;
				zoomAmount = scale;
			} else {
				TweenMax.to(zoomContainer, 0.5, { scaleX:minZoom, scaleY:minZoom, ease:Linear } );
				//zoomAmount = zoomContainer.scaleX = zoomContainer.scaleY = minZoom;
				zoomAmount = minZoom;
			}
			
			// Panning limits change when the scale changes
			getLimits();
			checkBounds();
		}
		
		/* 	To pan to a point, move the panContainer inside zoomContainer. In this case we provide coordinates
			in the context of the map itself, which have to be converted to the context of zoomContainer (since the
			map might be scaled).
		*/
		public function panTo(pt:Point /* in the coordinate space of mapImg */):void
		{
			var containerPt:Point = panContainer.globalToLocal(mapImg.localToGlobal(pt));
			panContainer.x = -containerPt.x;
			panContainer.y = -containerPt.y;
			checkBounds();	// make sure it didn't move out of bounds
		}
		
		// Click and drag panning
		private function startPan(e:MouseEvent):void
		{
			panContainer.startDrag(false,dragLimits);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopPan);
			stage.addEventListener(Event.MOUSE_LEAVE,stopPan);
		}
		private function stopPan(e:MouseEvent):void
		{
			panContainer.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopPan);
			stage.removeEventListener(Event.MOUSE_LEAVE,stopPan);
		}
		
		// If panContainer has gone out of bounds, move it back. This can happen when it's moved or when scale changes.
		private function checkBounds():void
		{
			if (panContainer.x < dragLimits.left) {
				panContainer.x = this.dragLimits.left;
			}
			if (panContainer.y < this.dragLimits.top) {
				panContainer.y = this.dragLimits.top;
			}
			if (panContainer.x > dragLimits.right) {
				panContainer.x = dragLimits.right;
			}
			if (panContainer.y > dragLimits.bottom) {
				panContainer.y = dragLimits.bottom;
			}
		}
		
		/* Calculate the panning boundaries based on scale.
			The leftmost limit, for example, in stage coordiantes, is:
				leftLimit = viewerWidth/2 - mapWidth/2
			But we need the limit in the coordinates of zoomContainer. The above is actually like this:
				globalLeftLimit = viewerWidth/2 - globalMapWidth/2
			Which equals
				globalLeftLimit = viewerWidth/2 - zoomAmount*mapWidth/2
			To get the local coordinates of the left limit, divide by zoom amount. So, divide both sides of the equation by zoomAmount:
				globalLeftLimit/zoomAmount = (viewerWidth/2)/zoomAmount - mapWidth/2
			Or,
				leftLimit = (viewerWidth/2)/zoomAmount - mapWidth/2
				
			The other sides are done similarly.
		*/
		private function getLimits() {
			var left = (size.width/2)/(zoomAmount) - (mapWidth/2);
			if (left > 0) {
				left=0;
			}
			var top = (size.height/2)/(zoomAmount) - (mapHeight/2);
			if (top > 0) {
				top=0;
			}
			var right = (mapWidth/2) - (size.width/2)/(zoomAmount);
			if (right < 0) {
				right=0;
			}
			var bottom = (mapHeight/2) - (size.height/2)/(zoomAmount);
			if (bottom < 0) {
				bottom=0;
			}
			dragLimits = new Rectangle(left, top, (right-left), (bottom-top));
		}
	}
}