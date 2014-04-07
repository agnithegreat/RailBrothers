package com.gesture {
import flash.geom.Rectangle;
import flash.events.EventDispatcher;

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class MouseGesture extends EventDispatcher {

    public static const DEFAULT_NB_SECTORS:uint=8;		// Number of sectors
    public static const DEFAULT_PRECISION:uint=8;		// Precision of catpure in pixels
    public static const DEFAULT_TIME_STEP:uint=10;		// Capture interval in ms
    public static const DEFAULT_FIABILITY:uint=30;		// Default fiability level

    public static var sectorRad:Number;					// Angle of one sector
    public static var anglesMap:Array;					// Angles map

    private var mouseZone:DisplayObject;	    	// Mouse zone
    private var gestures:Vector.<Gesture>;			// Gestures to match

    private var paths: Vector.<GesturePath>;

    function MouseGesture(pZone:DisplayObject){
        mouseZone=pZone;

        init();
    }

    protected function init():void{
        buildAnglesMap();

        gestures = new <Gesture>[];
    }

    protected function buildAnglesMap():void{
        sectorRad=Math.PI*2/DEFAULT_NB_SECTORS;

        anglesMap=[];

        var step:Number=Math.PI*2/100;

        var sector:Number;
        for (var i:Number=-sectorRad/2;i<=Math.PI*2-sectorRad/2;i+=step){
            sector=Math.floor((i+sectorRad/2)/sectorRad);
            anglesMap.push(sector);
        }
    }

    public function addGesture(name:String,gesture:String):void{
        var g:Array=[];
        for (var i:uint=0;i<gesture.length;i++){
            g.push(gesture.charAt(i)=="." ? -1 : parseInt(gesture.charAt(i),16));
        }
        gestures.push(new Gesture(name, g));
    }

    public function start():void {
        paths = new <GesturePath>[null];
        mouseZone.addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    public function stop():void {
        paths = null;
        mouseZone.removeEventListener(TouchEvent.TOUCH, handleTouch);
    }

    public function step():void {
        if (!paths) {
            return;
        }

        for (var i:int = 0; i < paths.length; i++) {
            if (paths[i]) {
                paths[i].capture();
            }
        }

        dispatchEvent(new GestureEvent(GestureEvent.CAPTURING));
    }

    protected function handleTouch(e: TouchEvent):void {
        for (var i:int = 0; i < e.touches.length; i++) {
            var t: Touch = e.touches[i];
            if (t.phase != TouchPhase.HOVER) {
                paths[i] = (t.phase==TouchPhase.BEGAN) ? new GesturePath() : paths[i];
                if (paths[i]) {
                    paths[i].touch = t.getLocation(mouseZone);
                    if (t.phase == TouchPhase.ENDED) {
                        stopCapture(paths[i]);
                        paths[i] = null;
                    }
                }
            }
        }
    }

    protected function stopCapture(path: GesturePath):void{
        var res: GestureResult = matchGesture(path);
        if (res) {
            var evt: GestureEvent = new GestureEvent(GestureEvent.GESTURE_MATCH);
            evt.result = res;
            dispatchEvent(evt);
        } else {
            dispatchEvent(new GestureEvent(GestureEvent.NO_MATCH));
        }
        path.destroy();
    }

    protected function matchGesture(path: GesturePath):GestureResult {
        var bestCost:uint=1000000;
        var nbGestures:uint=gestures.length;
        var cost:uint;
        var gest:Array;
        var bestGesture:Object=null;
        var infos:Object={	points: path.points,
                            moves: path.moves,
                            lastPoint: path.lastPoint,
                            rect:new Rectangle(	path.rect.minx,
                                                path.rect.miny,
                                                path.rect.maxx-path.rect.minx,
                                                path.rect.maxy-path.rect.miny)};

        for (var i:uint=0;i<nbGestures;i++){
            gest=gestures[i].moves;
            infos.name=gestures[i].name;
            cost=costLeven(gest,path.moves);

            if (cost<=DEFAULT_FIABILITY){
                if (cost<bestCost){
                    bestCost=cost;
                    bestGesture=gestures[i];
                }
            }
        }

        return bestGesture ? new GestureResult(bestGesture.name, path.points) : null;
    }

    protected function difAngle(a:uint,b:uint):uint{
        var dif:uint=Math.abs(a-b);
        if (dif>DEFAULT_NB_SECTORS/2)dif=DEFAULT_NB_SECTORS-dif;
        return dif;
    }

    protected function fill2DTable(w:uint,h:uint,f:*):Array{
        var o:Array=new Array(w);
        for (var x:uint=0;x<w;x++){
            o[x]=new Array(h);
            for (var y:uint=0;y<h;y++)o[x][y]=f;
        }
        return o;
    }

    protected function costLeven(a:Array,b:Array):uint{
        if (a[0]==-1){
            return b.length==0 ? 0 : 100000;
        }

        var d:Array=fill2DTable(a.length+1,b.length+1,0);
        var w:Array=d.slice();

        for (var x:uint=1;x<=a.length;x++){
            for (var y:uint=1;y<b.length;y++){
                d[x][y]=difAngle(a[x-1],b[y-1]);
            }
        }

        for (y=1;y<=b.length;y++)w[0][y]=100000;
        for (x=1;x<=a.length;x++)w[x][0]=100000;
        w[0][0]=0;

        var cost:uint=0;
        var pa:uint;
        var pb:uint;
        var pc:uint;

        for (x=1;x<=a.length;x++){
            for (y=1;y<b.length;y++){
                cost=d[x][y];
                pa=w[x-1][y]+cost;
                pb=w[x][y-1]+cost;
                pc=w[x-1][y-1]+cost;
                w[x][y]=Math.min(Math.min(pa,pb),pc)
            }
        }

        return w[x-1][y-1];
    }
}
}