/**
 * Created by agnither on 29.03.14.
 */
package com.agnither.race.ui.popups {
import com.agnither.race.GameController;
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class PausePopup extends Popup {

    public static const ID: String = "PausePopup";

    private var _back: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _menuBtn: Button;
    private var _replayBtn: Button;
    private var _continueBtn: Button;

    public function PausePopup(refs:CommonRefs) {
        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("pause_back.png"));
        addChild(_back);

        _menuBtn = new Button(_refs.gui.getTexture("menu_button.png"));
        _menuBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _menuBtn.x = 80;
        _menuBtn.y = 215;
        addChild(_menuBtn);

        _replayBtn = new Button(_refs.gui.getTexture("restart_button.png"));
        _replayBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _replayBtn.x = 228;
        _replayBtn.y = 207;
        addChild(_replayBtn);

        _continueBtn = new Button(_refs.gui.getTexture("next_button.png"));
        _continueBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _continueBtn.x = 401;
        _continueBtn.y = 210;
        addChild(_continueBtn);

        _titleStroke = new TextField(_back.width, 200, "PAUSE", "popup_title_big_stroke", -1, 0xFFFFFF);
        _titleStroke.x = int((_back.width-_titleStroke.width)/2)-7;
        _titleStroke.y = 17;
        addChild(_titleStroke);

        _title = new TextField(_back.width, 200, "PAUSE", "popup_title_big", -1, 0xFFFFFF);
        _title.x = int((_back.width-_titleStroke.width)/2);
        _title.y = 10;
        addChild(_title);

        pivotX = int(width/2);
        x = stage.stageWidth/2;
        y = 114;
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
                dispatchEventWith(GameController.UI_ACTION, true, GameController.CONTINUE);
                break;
        }
        dispatchEventWith(CLOSE);
    }
}
}
