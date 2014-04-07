/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.ui.screens.area {
import com.agnither.race.GameController;
import com.agnither.race.data.AreaVO;
import com.agnither.race.ui.common.EnergyDisplayView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;
import com.gesture.GestureEvent;
import com.gesture.MouseGesture;

import flash.geom.Point;
import flash.geom.Rectangle;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.TextField;

public class AreaSelectScreen extends Screen {

    public static const ID: String = "AreaSelectScreen";

    public static const SELECT_AREA: String = "select_area_AreaSelectScreen";

    private static var tile: int = 444;
    private static var buttonScale: Number = 0.825;

    private var _controller: GameController;

    private var _back: Image;

    private var _energy: EnergyDisplayView;

    private var _coinsBack: Image;
    private var _coins: TextField;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _areas: Vector.<AreaTile>;
    private var _container: Sprite;

    private var _backBtn: Button;
    private var _shopBtn: Button;

    private var _current: int;

    private var _gesture: MouseGesture;

    public function AreaSelectScreen(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("wood_back.png"));
        addChild(_back);

        _energy = new EnergyDisplayView(_refs, _controller.player);
        addChild(_energy);

        _coinsBack = new Image(_refs.gui.getTexture("coins_back.png"));
        _coinsBack.x = 707;
        _coinsBack.y = 20;
        addChild(_coinsBack);

        _container = new Sprite();
        addChild(_container);

        _areas = new <AreaTile>[];

        _backBtn = new Button(_refs.gui.getTexture("back_button.png"));
        _backBtn.addEventListener(Event.TRIGGERED, handleClick);
        _backBtn.x = 42;
        _backBtn.y = 26;
        addChild(_backBtn);

        _shopBtn = new Button(_refs.gui.getTexture("shop_button.png"));
        _shopBtn.addEventListener(Event.TRIGGERED, handleClick);
        _shopBtn.x = 909;
        _shopBtn.y = 539;
        addChild(_shopBtn);

        _titleStroke = new TextField(400, 100, "", "area_name_stroke", -1, 0xFFFFFF);
        _titleStroke.x = (stage.stageWidth-_titleStroke.width)/2-7;
        _titleStroke.y = 27;
        addChild(_titleStroke);

        _title = new TextField(400, 100, "", "area_name", -1, 0xFFFFFF);
        _title.x = (stage.stageWidth-_title.width)/2;
        _title.y = 20;
        addChild(_title);

        _coins = new TextField(171, 52, "", "coins", -1, 0xFFFFFF);
        _coins.x = 779;
        _coins.y = 31;
        addChild(_coins);

        _gesture = new MouseGesture(this);
        _gesture.addGesture("left", "4");
        _gesture.addGesture("right", "0");
    }

    override public function open():void {
        super.open();

        _current = 0;
        addAreas(AreaVO.AREAS);
        if (_controller.currentArea) {
            _current = _controller.currentArea-1;
        }
        update(_current, false);

        _coins.text = FormatUtil.formatMoney(_controller.player.money);

        _gesture.addEventListener(GestureEvent.GESTURE_MATCH, handleGesture);
        stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
        _gesture.start();
    }

    override public function close():void {
        _gesture.stop();
        stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
        _gesture.removeEventListener(GestureEvent.GESTURE_MATCH, handleGesture);

        super.close();

        clear();
    }

    private function addAreas(areas: Vector.<AreaVO>):void {
        var l: int = areas.length;
        for (var i:int = 0; i < l; i++) {
            var area: AreaTile = new AreaTile(_refs, areas[i]);
            area.addEventListener(Event.TRIGGERED, handleSelectArea);
            _container.addChild(area);
            _areas.push(area);

            if (area.area.opened) {
                _current = i;
            }
        }
    }

    private function update(current: int, animated: Boolean = true):void {
        _current = current;

        var l: int = _areas.length;
        for (var i:int = 0; i < l; i++) {
            var area: AreaTile = _areas[i];
            var nx: int = 568 - tile * (_current-i);
            var ny: int = 327;
            var scale: Number = i==_current ? 1 : buttonScale;
            Starling.juggler.tween(area, animated ? 0.5 : 0, {x: nx, y: ny, scaleX: scale, scaleY: scale, transition: Transitions.EASE_OUT});
        }

        _titleStroke.text = _areas[current].area.name.toUpperCase();
        _title.text = _areas[current].area.name.toUpperCase();
    }

    private function handleEnterFrame(e: EnterFrameEvent):void {
        var l: int = _areas.length;
        for (var i:int = 0; i < l; i++) {
            var area: AreaTile = _areas[i];
            var bounds: Rectangle = area.getBounds(stage);
            area.visible = (bounds.x <= stage.stageWidth) && (bounds.x + bounds.width >= 0);
        }

        _gesture.step();
    }

    private function handleGesture(e: GestureEvent):void {
        var first: Point = e.result.points[0];
        var last: Point = e.result.points[e.result.points.length-1];
        if (Point.distance(first, last) < 100) {
            return;
        }

        switch (e.result.name) {
            case "left":
                if (_current+1 < _areas.length) {
                    update(_current+1);
                }
                break;
            case "right":
                if (_current > 0) {
                    update(_current-1);
                }
                break;
        }
    }

    private function clear():void {
        while (_areas.length>0) {
            var area: AreaTile = _areas.pop();
            area.destroy();
            area.removeFromParent(true);
        }
    }

    private function handleSelectArea(e: Event):void {
        var area: AreaTile = e.currentTarget as AreaTile;
        if (area.area.id-1 == _current) {
            dispatchEventWith(SELECT_AREA, true, area.area);
        } else {
            update(area.area.id-1);
        }
    }

    private function handleClick(e: Event):void {
        switch (e.currentTarget) {
            case _backBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.BACK);
                break;
            case _shopBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.SHOP);
                break;
        }
    }
}
}
