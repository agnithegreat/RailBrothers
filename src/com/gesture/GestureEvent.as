package com.gesture {
import flash.events.Event;
import flash.geom.Point;

public class GestureEvent extends Event {
		
    public static const START_CAPTURE:String="startCapture";
    public static const STOP_CAPTURE:String="stopCapture";
    public static const CAPTURING:String="capturing";
    public static const GESTURE_MATCH:String="gestureMatch";
    public static const NO_MATCH:String="noMatch";

    public var result: GestureResult;

    public function GestureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
        super (type,bubbles,cancelable);
    }

    public override function clone():Event{
        return new GestureEvent(type, bubbles, cancelable) as Event;
    }
}
}
		
    