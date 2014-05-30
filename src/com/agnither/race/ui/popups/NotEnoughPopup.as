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

public class NotEnoughPopup extends Popup {

    public static const ID: String = "NotEnoughPopup";

    private var _back: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _buyBtn: Button;
    private var _closeBtn: Button;

    public function NotEnoughPopup(refs:CommonRefs) {
        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("pause_back.png"));
        addChild(_back);

        _buyBtn = new Button(_refs.gui.getTexture("buy_btn.png"));
        _buyBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        _buyBtn.x = 150;
        _buyBtn.y = 217;
        addChild(_buyBtn);

        _titleStroke = new TextField(_back.width * 0.8, 130, "NOT ENOUGH MONEY", "popup_title_stroke", -1, 0xFFFFFF);
        _titleStroke.x = int((_back.width-_titleStroke.width)/2)-7;
        _titleStroke.y = 55;
        addChild(_titleStroke);

        _title = new TextField(_back.width * 0.8, 130, "NOT ENOUGH MONEY", "popup_title", -1, 0xFFFFFF);
        _title.x = int((_back.width-_titleStroke.width)/2);
        _title.y = 50;
        addChild(_title);

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
                dispatchEventWith(GameController.UI_ACTION, true, GameController.BUY_MONEY);
                break;
            case _closeBtn:
                break;
        }
        dispatchEventWith(CLOSE, true);
    }
}
}
