/**
 * Created by agnither on 27.12.13.
 */
package com.agnither.race.ui.common {
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class CustomButton extends AbstractView {

    private var _buttonTexture: String;
    private var _iconTexture: String;

    private var _button: Button;

    private var _enabled: Boolean = true;

    public function CustomButton(refs: CommonRefs, button: String, icon: String = null) {
        _buttonTexture = button;
        _iconTexture = icon;

        super(refs);
    }

    override protected function initialize():void {
        _button = new Button(_refs.gui.getTexture(_buttonTexture));
        _button.alphaWhenDisabled = 1;
        addChild(_button);

        if (_iconTexture) {
            var icon: Image = new Image(_refs.gui.getTexture(_iconTexture));
            addChild(icon);
        }

        addEventListener(TouchEvent.TOUCH, handleTouch);

        enabled = _enabled;
    }

    public function set enabled(value: Boolean):void {
        _enabled = value;

        if (_button) {
            _button.enabled = value;
        }
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(this);
        if (touch) {
            if (touch.phase == TouchPhase.BEGAN) {
                dispatchEventWith(Event.TRIGGERED, true);
            }
        }
    }
}
}
