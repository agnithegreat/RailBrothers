/**
 * Created by agnither on 29.03.14.
 */
package com.agnither.race.ui.popups {
import com.agnither.ui.Popup;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

public class LocationUnlockedPopup extends Popup {

    public static const ID: String = "LocationUnlockedPopup";

    private var _back: Image;

    private var _titleStroke: TextField;
    private var _title: TextField;

    private var _closeBtn: Button;

    public function LocationUnlockedPopup(refs:CommonRefs) {
        super(refs, true);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("pause_back.png"));
        addChild(_back);

        _titleStroke = new TextField(_back.width, 200, "YOU HAVE BOUGHT NEW LOCATION!", "popup_title_stroke", -1, 0xFFFFFF);
        _titleStroke.x = int((_back.width-_titleStroke.width)/2)-7;
        _titleStroke.y = 67;
        addChild(_titleStroke);

        _title = new TextField(_back.width, 200, "YOU HAVE BOUGHT NEW LOCATION!", "popup_title", -1, 0xFFFFFF);
        _title.x = int((_back.width-_titleStroke.width)/2);
        _title.y = 60;
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
            case _closeBtn:
                break;
        }
        dispatchEventWith(CLOSE, true);
    }
}
}
