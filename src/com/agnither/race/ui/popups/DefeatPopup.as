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

public class DefeatPopup extends Popup {

    public static const ID: String = "DefeatPopup";

    private var _back: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _menuBtn: Button;
    private var _replayBtn: Button;

    public function DefeatPopup(refs:CommonRefs) {
        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("pause_back.png"));
        addChild(_back);

        _menuBtn = new Button(_refs.gui.getTexture("menu_button.png"));
        _menuBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _menuBtn.x = 155;
        _menuBtn.y = 215;
        addChild(_menuBtn);

        _replayBtn = new Button(_refs.gui.getTexture("restart_button.png"));
        _replayBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _replayBtn.x = 303;
        _replayBtn.y = 207;
        addChild(_replayBtn);

        _titleStroke = new TextField(_back.width, 200, "YOU LOSE!", "popup_title_big_stroke", -1, 0xFFFFFF);
        _titleStroke.x = int((_back.width-_titleStroke.width)/2)-7;
        _titleStroke.y = 15;
        addChild(_titleStroke);

        _title = new TextField(_back.width, 200, "YOU LOSE!", "popup_title_big", -1, 0xFFFFFF);
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
        }
        close();
    }
}
}
