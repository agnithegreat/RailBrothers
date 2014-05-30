/**
 * Created by agnither on 08.04.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class EnergyTile extends AbstractView {

    public static const BUY_ENERGY: String = "buy_energy_EnergyTile";

    private var _value: Object;

    private var _label: TextField;
    private var _coin: Image;
    private var _money: TextField;

    public function EnergyTile(refs: CommonRefs, value: Object) {
        _value = value;

        super(refs);
    }

    override protected function initialize():void {
        _coin = new Image(_refs.gui.getTexture("coin.png"));
        addChild(_coin);

        _label = new TextField(400, 50, _value.title, "shop_text", -1, 0xFFFFFF);
        _label.hAlign = "left";
        _label.x = 5;
        _label.y = 5;
        addChild(_label);

        _money = new TextField(150, 50, FormatUtil.formatMoney(_value.price), "coins", -1, 0xFFFFFF);
        _money.hAlign = "right";
        _money.x = 780;
        _money.y = 5;
        addChild(_money);

        _coin.x = _money.x - 70 + _money.textBounds.left;

        // TODO: доделать интерактивность
        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.ENDED);
        if (touch) {
            dispatchEventWith(BUY_ENERGY, true, _value);
        }
    }
}
}
