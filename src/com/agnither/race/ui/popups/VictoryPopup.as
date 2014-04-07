/**
 * Created by agnither on 29.03.14.
 */
package com.agnither.race.ui.popups {
import com.agnither.race.GameController;
import com.agnither.race.data.LevelVO;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class VictoryPopup extends Popup {

    public static const ID: String = "VictoryPopup";

    private var _back: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _coinsBack: Image;
    private var _coins: TextField;

    private var _menuBtn: Button;
    private var _replayBtn: Button;
    private var _continueBtn: Button;

    public function VictoryPopup(refs:CommonRefs) {
        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("pause_back.png"));
        addChild(_back);

        _coinsBack = new Image(_refs.gui.getTexture("coins_back.png"));
        _coinsBack.x = 136;
        _coinsBack.y = 122;
        addChild(_coinsBack);

        _menuBtn = new Button(_refs.gui.getTexture("menu_button.png"));
        _menuBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _menuBtn.x = 77;
        _menuBtn.y = 220;
        addChild(_menuBtn);

        _replayBtn = new Button(_refs.gui.getTexture("restart_button.png"));
        _replayBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _replayBtn.x = 225;
        _replayBtn.y = 212;
        addChild(_replayBtn);

        _continueBtn = new Button(_refs.gui.getTexture("next_button.png"));
        _continueBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _continueBtn.x = 398;
        _continueBtn.y = 215;
        addChild(_continueBtn);

        _titleStroke = new TextField(_back.width, 100, "YOU WIN!", "popup_title_stroke", -1, 0xFFFFFF);
        _titleStroke.x = int((_back.width-_titleStroke.width)/2)-7;
        _titleStroke.y = 17;
        addChild(_titleStroke);

        _title = new TextField(_back.width, 100, "YOU WIN!", "popup_title", -1, 0xFFFFFF);
        _title.x = int((_back.width-_titleStroke.width)/2);
        _title.y = 10;
        addChild(_title);

        _coins = new TextField(108, 52, "", "coins", -1, 0xFFFFFF);
        _coins.x = 218;
        _coins.y = 132;
        addChild(_coins);

        pivotX = int(width/2);
        x = stage.stageWidth/2;
        y = 114;
    }

    override public function open():void {
        super.open();

        _coins.text = String(_data);
    }

    private function handleTriggered(e: Event):void {
        switch (e.currentTarget) {
            case _menuBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.MENU);
                break;
            case _replayBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.REPLAY);
                break;
            case _continueBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.NEXT);
                break;
        }
        close();
    }
}
}
