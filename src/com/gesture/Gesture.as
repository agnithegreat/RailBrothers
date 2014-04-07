/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 27.11.13
 * Time: 21:53
 * To change this template use File | Settings | File Templates.
 */
package com.gesture {

public class Gesture {

    public var name: String;
    public var moves: Array;

    public function Gesture(name: String, gesture: Array) {
        this.name = name;
        moves = gesture;
    }
}
}
