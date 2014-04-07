/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.GameController;
import com.agnither.race.ui.common.EnergyDisplayView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class ShopScreen extends Screen {

    public static const ID: String = "ShopScreen";

    private var _controller: GameController;

    private var _back: Image;

    private var _energy: EnergyDisplayView;

    private var _coinsBack: Image;
    private var _coins: TextField;

    private var _popupBack: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _backBtn: Button;

    public function ShopScreen(refs:CommonRefs, controller: GameController) {
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

        _backBtn = new Button(_refs.gui.getTexture("back_button.png"));
        _backBtn.addEventListener(Event.TRIGGERED, handleClick);
        _backBtn.x = 42;
        _backBtn.y = 26;
        addChild(_backBtn);

        _popupBack = new Image(_refs.gui.getTexture("shop_back.png"));
        _popupBack.x = 64;
        _popupBack.y = 176;
        addChild(_popupBack);

        _titleStroke = new TextField(400, 100, "SHOP", "area_name_stroke", -1, 0xFFFFFF);
        _titleStroke.x = (stage.stageWidth-_titleStroke.width)/2-7;
        _titleStroke.y = 27;
        addChild(_titleStroke);

        _title = new TextField(400, 100, "SHOP", "area_name", -1, 0xFFFFFF);
        _title.x = (stage.stageWidth-_title.width)/2;
        _title.y = 20;
        addChild(_title);

        _coins = new TextField(171, 52, "", "coins", -1, 0xFFFFFF);
        _coins.x = 779;
        _coins.y = 31;
        addChild(_coins);
    }

    override public function open():void {
        super.open();

        _coins.text = FormatUtil.formatMoney(_controller.player.money);
    }

    private function handleClick(e: Event):void {
        switch (e.currentTarget) {
            case _backBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.BACK);
                break;
        }
    }
}
}
