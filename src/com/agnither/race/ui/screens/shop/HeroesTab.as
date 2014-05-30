/**
 * Created by agnither on 08.04.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.data.HeroVO;
import com.agnither.race.model.Player;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.gesture.GestureEvent;
import com.gesture.MouseGesture;

import flash.geom.Rectangle;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class HeroesTab extends AbstractView {

    public static var swipe: Boolean;

    private var _player: Player;

    private var _gesture: MouseGesture;

    private var _current: int;

    private var _items: Vector.<HeroTile>;

    public function HeroesTab(refs:CommonRefs, player: Player) {
        _player = player;

        super(refs);
    }

    override protected function initialize():void {
        _items = new <HeroTile>[];
        for (var i:* in HeroVO.HEROES) {
            var tile: HeroTile = new HeroTile(_refs, HeroVO.HEROES[i]);
            tile.addEventListener(TouchEvent.TOUCH, handleTouch);
            tile.x = 29 + _items.length * 325;
            tile.y = 34;
            addChild(tile);
            _items.push(tile);
        }

        _gesture = new MouseGesture(stage);
        _gesture.addGesture("left", "4");
        _gesture.addGesture("right", "0");

        stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
    }

    override public function open():void {
        super.open();

        _current = 0;
        update(_current, false);

        _gesture.addEventListener(GestureEvent.GESTURE_MATCH, handleGesture);
        _gesture.start();

        _player.addEventListener(Player.UPDATE, handleUpdate);
        handleUpdate(null);
    }

    private function handleUpdate(e: Event):void {
        for (var i:int = 0; i < _items.length; i++) {
            var tile: HeroTile = _items[i];
            tile.update(_player.hero==i+1, _player.hasHero(i+1));
        }
    }

    override public function close():void {
        _player.removeEventListener(Player.UPDATE, handleUpdate);

        _gesture.stop();
        _gesture.removeEventListener(GestureEvent.GESTURE_MATCH, handleGesture);

        super.close();
    }

    private function update(current: int, animated: Boolean = true):void {
        _current = Math.max(0, Math.min(current, _items.length-3));
        swipe = true;

        var l: int = _items.length;
        for (var i:int = 0; i < l; i++) {
            var level: HeroTile = _items[i];
            var nx: int = 29 - 325 * (_current-i);
            Starling.juggler.tween(level, animated ? 0.5 : 0, {x: nx, transition: Transitions.EASE_OUT});
        }
    }

    private function handleEnterFrame(e: EnterFrameEvent):void {
        if (!stage) {
            return;
        }

        var l: int = _items.length;
        for (var i:int = 0; i < l; i++) {
            var level: HeroTile = _items[i];
            var bounds: Rectangle = level.getBounds(stage);
            level.visible = (bounds.x <= stage.stageWidth) && (bounds.x + bounds.width >= 0);
        }

        _gesture.step(e.passedTime);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(e.currentTarget as DisplayObject, TouchPhase.ENDED);
        if (touch) {
//            dispatchEventWith();
        }
    }

    private function handleGesture(e: GestureEvent):void {
        if (e.result.distance < 50) {
            return;
        }

        var speed: int = e.result.speed/1000;
        switch (e.result.name) {
            case "left":
                update(_current+speed);
                break;
            case "right":
                update(_current-speed);
                break;
        }
    }
}
}
