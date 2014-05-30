/**
 * Created by agnither on 29.03.14.
 */
package com.agnither.race.ui.popups {
import com.agnither.race.GameController;
import com.agnither.race.ui.common.TiledImage;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class RestorePopup extends Popup {

    public static const ID: String = "RestorePopup";

    private var _back: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _coinsBack: Sprite;
    private var _coin: Image;
    private var _coins: TextField;

    private var _buyBtn: Button;
    private var _closeBtn: Button;

    public function RestorePopup(refs:CommonRefs) {
        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("pause_back.png"));
        addChild(_back);

        _coinsBack = TiledImage.generateTiled(_refs.gui.getTexture("money_back_left.png"), _refs.gui.getTexture("money_back_centre.png"), _refs.gui.getTexture("money_back_right.png"), 252);
        _coinsBack.x = 136;
        _coinsBack.y = 142;
        addChild(_coinsBack);

        _coin = new Image(_refs.gui.getTexture("coin.png"));
        _coin.x = 6;
        _coin.y = 6;
        _coinsBack.addChild(_coin);

        _buyBtn = new Button(_refs.gui.getTexture("buy_btn.png"));
        _buyBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _buyBtn.x = 150;
        _buyBtn.y = 217;
        addChild(_buyBtn);

        _titleStroke = new TextField(_back.width * 0.8, 130, "RESTORE ENERGY?", "popup_title_stroke", -1, 0xFFFFFF);
        _titleStroke.x = int((_back.width-_titleStroke.width)/2)-7;
        _titleStroke.y = 15;
        addChild(_titleStroke);

        _title = new TextField(_back.width * 0.8, 130, "RESTORE ENERGY?", "popup_title", -1, 0xFFFFFF);
        _title.x = int((_back.width-_titleStroke.width)/2);
        _title.y = 10;
        addChild(_title);

        _coins = new TextField(144, 52, "10 000", "coins", -1, 0xFFFFFF);
        _coins.x = 200;
        _coins.y = 152;
        addChild(_coins);

        pivotX = int(width/2);
        x = stage.stageWidth/2;
        y = 114;

        _closeBtn = new Button(_refs.gui.getTexture("close_btn.png"));
        _closeBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _closeBtn.x = 452;
        _closeBtn.y = -13;
        addChild(_closeBtn);
    }

    private function handleTriggered(e: Event):void {
        switch (e.currentTarget) {
            case _buyBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.BUY_ENERGY);
                break;
            case _closeBtn:
                break;
        }
        dispatchEventWith(CLOSE, true);
    }
}
}
