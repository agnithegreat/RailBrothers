/**
 * Created by agnither on 08.04.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.data.BankVO;
import com.agnither.race.ui.common.TiledImage;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

public class CoinsTile extends AbstractView {

    public static const BUY_COINS: String = "buy_coins_CoinsTile";

    private var _value: BankVO;

    private var _coinsBack: Sprite;
    private var _coin: Image;
    private var _coins: TextField;
    private var _money: TextField;

    public function CoinsTile(refs: CommonRefs, value: BankVO) {
        _value = value;

        super(refs);
    }

    override protected function initialize():void {
        _coinsBack = TiledImage.generateTiled(_refs.gui.getTexture("money_back_left.png"), _refs.gui.getTexture("money_back_centre.png"), _refs.gui.getTexture("money_back_right.png"), 256);
        addChild(_coinsBack);

        _coin = new Image(_refs.gui.getTexture("coin.png"));
        _coin.x = 6;
        _coin.y = 6;
        _coinsBack.addChild(_coin);

        _coins = new TextField(190, 52, FormatUtil.formatMoney(_value.amount), "coins", -1, 0xFFFFFF);
        _coins.x = 57;
        _coins.y = 11;
        addChild(_coins);

        _money = new TextField(140, 56, "$ "+_value.price, "money", -1, 0xFFFFFF);
        _money.x = 790;
        _money.y = 6;
        addChild(_money);

        // TODO: доделать интерактивность
        addEventListener(TouchEvent.TOUCH, handleTouch);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this, TouchPhase.ENDED);
        if (touch) {
            dispatchEventWith(BUY_COINS, true, _value);
        }
    }
}
}
