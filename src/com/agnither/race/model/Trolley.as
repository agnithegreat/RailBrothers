/**
 * Created by agnither on 28.02.14.
 */
package com.agnither.race.model {
import starling.events.EventDispatcher;

public class Trolley extends EventDispatcher {

    public static const UPDATE: String = "update_Trolley";

    private static var acceleraion: int = 100;
    private static var deceleration: Number = 0.05;
    private static var maxSpeed: int = 2000;

    private var _acceleration: Number;
    private var _speed: Number;

    private var _position: Number;
    public function get position():int {
        return _position;
    }

    private var _balance: Number;
    public function get balance():Number {
        return _balance;
    }

    private var _target: int;
    private var _balanceDelta: int;
    private var _range: Number;

    private var _locked: int;
    public function get locked():int {
        return _locked;
    }

    private var _pushes: int;
    public function get pushes():int {
        return _pushes;
    }

    public function Trolley() {
    }

    public function init(range: Number):void {
        _speed = 0;
        _acceleration = 0;
        _position = 0;
        _balanceDelta = 0;
        _balance = 0;
        _range = range;
        _locked = 0;
        _pushes = 0;
    }

    public function step(delta: Number):void {
        var power: Number = Math.min((0.5+3.5*_speed/maxSpeed) * Math.abs(_balanceDelta * delta), Math.abs(_balance-_target));
        if (power) {
            _locked = 0;
            _balance += _balanceDelta>0 ? power : -power;
            _balance = Math.max(-1, Math.min(_balance, 1));

            _acceleration += acceleraion * power;
        } else {
            _locked = _target;
            _acceleration = 0;
        }
        _speed += _acceleration * delta;
        _speed *= 1 - deceleration * delta;
        _speed = Math.max(0, Math.min(_speed, maxSpeed));

        _position += _range * _speed * delta;

        dispatchEventWith(UPDATE);
    }

    public function press(direction: int):void {
        _pushes++;

        _balanceDelta = direction;
        _target = direction;
        _acceleration = 0;
    }
}
}
