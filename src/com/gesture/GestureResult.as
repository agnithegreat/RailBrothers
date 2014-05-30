/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 27.11.13
 * Time: 21:53
 * To change this template use File | Settings | File Templates.
 */
package com.gesture {
import flash.geom.Point;

public class GestureResult {

    public var name: String;
    public var points: Vector.<Point>;
    public var duration: Number;
    public var distance: Number;
    public var speed: Number;

    public function GestureResult(name: String, gesture: Vector.<Point>, time: Number) {
        this.name = name;
        points = gesture;
        duration = time;

        distance = 0;
        var l: int = points.length;
        for (var i:int = 0; i < l-1; i++) {
            distance += Point.distance(points[i], points[i+1]);
        }

        speed = distance/time;
    }
}
}
