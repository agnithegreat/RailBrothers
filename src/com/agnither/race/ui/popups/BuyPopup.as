/**
 * Created by agnither on 23.04.14.
 */
package com.agnither.race.ui.popups {
import com.agnither.race.data.ClothVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.model.Player;
import com.agnither.race.ui.common.TiledImage;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class BuyPopup extends Popup {

    public static const ID: String = "BuyPopup";

    public static const BUY: String = "buy_BuyPopup";

    private var _player: Player;

    private var _back: Image;

    private var _window: Image;
    private var _icon: Image;

    private var _buy: Button;
    private var _close: Button;

    private var _description: TextField;

    private var _coinsBack: Sprite;
    private var _coin: Image;
    private var _coins: TextField;

    public function BuyPopup(refs:CommonRefs, player: Player) {
        _player = player;

        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("shop_popup_back.png"));
        addChild(_back);

        x = (stage.stageWidth-width)/2;
        y = (stage.stageHeight-height)/2;

        _buy = new Button(_refs.gui.getTexture("buy_button.png"));
        _buy.addEventListener(Event.TRIGGERED, handleBuy);
        _buy.x = 441;
        _buy.y = 401
        addChild(_buy);

        _window = new Image(_refs.gui.getTexture("window_big.png"));
        _window.x = 22;
        _window.y = 22;
        addChild(_window);

        _icon = new Image(_refs.gui.getTexture("window_big.png"));
        _icon.x = _window.x + _window.width/2;
        _icon.y = _window.y + _window.height/2;
        addChild(_icon);

        _close = new Button(_refs.gui.getTexture("close_button.png"));
        _close.addEventListener(Event.TRIGGERED, handleClose);
        _close.x = 658;
        _close.y = -42;
        addChild(_close);

        _description = new TextField(300, 340, "", "shop_text", -1, 0xFFFFFF);
        _description.x = 395;
        _description.y = 35;
        addChild(_description);

        _coinsBack = TiledImage.generateTiled(_refs.gui.getTexture("money_back_left.png"), _refs.gui.getTexture("money_back_centre.png"), _refs.gui.getTexture("money_back_right.png"), 256);
        _coinsBack.x = 81;
        _coinsBack.y = 415;
        addChild(_coinsBack);

        _coin = new Image(_refs.gui.getTexture("coin.png"));
        _coin.x = 6;
        _coin.y = 6;
        _coinsBack.addChild(_coin);

        _coins = new TextField(190, 52, "", "coins", -1, 0xFFFFFF);
        _coins.x = 138;
        _coins.y = 426;
        addChild(_coins);
    }

    override public function open():void {
        super.open();

        var item: Object = _data;

        _description.text = item.description;

        _icon.texture = _refs.gui.getTexture(item.icon);
        _icon.readjustSize();
        _icon.scaleX = 0.7;
        _icon.scaleY = 0.7;
        _icon.pivotX = _icon.width/2 / _icon.scaleX;
        _icon.pivotY = _icon.height/2 / _icon.scaleY;

        var bought: Boolean;
        var used: Boolean;
        if (item is ClothVO) {
            bought = _player.hasCloth(item.id);
            used = _player.cloth == item.id;
        } else if (item is HeroVO) {
            bought = _player.hasHero(item.id);
            used = _player.hero == item.id;
        }
        _buy.upState = bought ? _refs.gui.getTexture("btn_use_now.png") : _refs.gui.getTexture("buy_button.png");
        _buy.visible = !used;

        _coins.text = FormatUtil.formatMoney(item.unlockcost);
    }

    private function handleBuy(e: Event):void {
        dispatchEventWith(BUY, true, _data);
        dispatchEventWith(CLOSE);
    }

    private function handleClose(e: Event):void {
        dispatchEventWith(CLOSE);
    }
}
}
