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

    public function GestureResult(name: String, gesture: Vector.<Point>) {
        this.name = name;
        points = gesture;
    }
}
}
