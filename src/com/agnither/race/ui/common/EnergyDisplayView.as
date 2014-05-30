/**
 * Created by agnither on 22.03.14.
 */
package com.agnither.race.ui.common {
import com.agnither.race.GameController;
import com.agnither.race.model.Player;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.EnterFrameEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class EnergyDisplayView extends AbstractView {

    private var _player: Player;

    private var _back: Image;

    private var _bullets: Vector.<Image>;

    public function EnergyDisplayView(refs:CommonRefs, player: Player) {
        _player = player;

        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("cylinder.png"));
        _back.pivotX = 93;
        _back.pivotY = 70;
        addChild(_back);

        _bullets = new <Image>[];

        addBullet(-13, -29);
        addBullet(-30, -12);
        addBullet(-30, 12);
        addBullet(-13, 29);
        addBullet(12, 29);
        addBullet(29, 12);
        addBullet(29, -12);
        addBullet(12, -29);

        setBullet(_bullets[0], false);

        x = stage.stageWidth-89;
        y = 70;

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    override public function open():void {
        super.open();

        addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
    }

    override public function close():void {
        super.close();

        removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
    }

    private function addBullet(x: int, y: int):void {
        var bullet: Image = new Image(_refs.gui.getTexture("bullet.png"));
        bullet.pivotX = 10;
        bullet.pivotY = 10;
        bullet.x = x;
        bullet.y = y;
        addChild(bullet);
        _bullets.push(bullet);
    }

    private function setBullet(bullet: Image, full: Boolean):void {
        bullet.texture = full ? _refs.gui.getTexture("bullet.png") : _refs.gui.getTexture("bullet_empty.png");
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.ENDED);
        if (touch) {
            dispatchEventWith(GameController.UI_ACTION, true, GameController.SHOW_ENERGY);
        }
    }

    private function handleEnterFrame(e: EnterFrameEvent):void {
        var energy: int = _player.energy;

        var l: int = _bullets.length;
        for (var i:int = 0; i < l; i++) {
            setBullet(_bullets[i], energy>i);
        }
    }
}
}
