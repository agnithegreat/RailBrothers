/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 27.11.13
 * Time: 21:51
 * To change this template use File | Settings | File Templates.
 */
package com.gesture {
import flash.geom.Point;

public class GesturePath {

    public var lastPoint: Point;				// Last mouse point
    public var touch: Point;	    	        // Mouse zone
    public var rect:Object;						// Rectangle zone

    public var points:Vector.<Point>;			// Mouse points
    public var moves:Array;						// Mouse gestures

    public function GesturePath() {
        touch = new Point();
        points = new <Point>[];
        moves = [];

        rect = {
            minx:Number.POSITIVE_INFINITY,
            maxx:Number.NEGATIVE_INFINITY,
            miny:Number.POSITIVE_INFINITY,
            maxy:Number.NEGATIVE_INFINITY
        };
    }

    public function capture():void{
        if (!lastPoint) {
            points.push(touch);
            lastPoint = touch.clone();
        }

        var difx:int=touch.x-lastPoint.x;
        var dify:int=touch.y-lastPoint.y;
        var sqDist:Number=difx*difx+dify*dify;
        var sqPrec:Number=MouseGesture.DEFAULT_PRECISION*MouseGesture.DEFAULT_PRECISION;

        if (sqDist>sqPrec){
            points.push(touch);
            addMove(difx,dify);
            lastPoint.x=touch.x;
            lastPoint.y=touch.y;

            if (touch.x<rect.minx)rect.minx=touch.x;
            if (touch.x>rect.maxx)rect.maxx=touch.x;
            if (touch.y<rect.miny)rect.miny=touch.y;
            if (touch.y>rect.maxy)rect.maxy=touch.y;
        }
    }

    protected function addMove(dx:int,dy:int):void{
        var angle:Number=Math.atan2(dy,dx)+MouseGesture.sectorRad/2;
        if (angle<0)angle+=Math.PI*2;
        var no:int=Math.floor(angle/(Math.PI*2)*100);
        moves.push(MouseGesture.anglesMap[no]);
    }

    public function destroy():void {
        lastPoint = null;
        touch = null;
        rect = null;
        points = null;
        moves = null;
    }
}
}
