/**
 * Created by agnither on 08.04.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.data.HeroVO;
import com.agnither.race.ui.common.TiledImage;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class HeroTile extends AbstractView {

    public static const BUY_HERO: String = "buy_hero_ClothTile";

    private var _value: HeroVO;

    private var _back: Image;
    private var _icon: Image;
    private var _lock: Image;

    private var _coinsBack: Sprite;
    private var _coin: Image;
    private var _coins: TextField;

    public function HeroTile(refs: CommonRefs, value: HeroVO) {
        _value = value;

        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("tile.png"));
        addChild(_back);

        _icon = new Image(_refs.gui.getTexture(_value.icon));
        _icon.scaleX = 0.6;
        _icon.scaleY = 0.6;
        _icon.pivotX = _icon.width/2 / _icon.scaleX;
        _icon.pivotY = _icon.height/2 / _icon.scaleY;
        _icon.x = _back.width/2;
        _icon.y = _back.height/2;
        addChild(_icon);

        _lock = new Image(_refs.gui.getTexture("lock.png"));
        _lock.pivotX = int(_lock.width/2);
        _lock.pivotY = int(_lock.height/2);
        _lock.x = _back.width/2;
        _lock.y = _back.height/2;
        addChild(_lock);

        _coinsBack = TiledImage.generateTiled(_refs.gui.getTexture("money_back_left.png"), _refs.gui.getTexture("money_back_centre.png"), _refs.gui.getTexture("money_back_right.png"), 256);
        _coinsBack.x = 21;
        _coinsBack.y = 325;
        addChild(_coinsBack);

        _coin = new Image(_refs.gui.getTexture("coin.png"));
        _coin.x = 6;
        _coin.y = 6;
        _coinsBack.addChild(_coin);

        _coins = new TextField(190, 52, FormatUtil.formatMoney(_value.unlockcost), "coins", -1, 0xFFFFFF);
        _coins.x = 78;
        _coins.y = 336;
        addChild(_coins);

        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    public function update(selected: Boolean, opened: Boolean):void {
        _back.texture = selected ? _refs.gui.getTexture("window_small.png") : _refs.gui.getTexture("tile.png");
        _lock.visible = !opened;

        _coinsBack.visible = !opened;
        _coin.visible = !opened;
        _coins.visible = !opened;
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this);
        if (touch) {
            if (touch.phase == TouchPhase.BEGAN) {
                HeroesTab.swipe = false;
            } else if (touch.phase == TouchPhase.ENDED) {
                Starling.juggler.delayCall(buy, 0.1);
            }
        }
    }

    private function buy():void {
        if (!HeroesTab.swipe) {
            dispatchEventWith(BUY_HERO, true, _value);
        }
    }
}
}
