/**
 * Created by agnither on 04.04.14.
 */
package com.agnither.race.ui {
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;

public class IndicationView extends AbstractView {

    private var _back: Image;
    private var _roll: Image;

    public function IndicationView(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("indication_line.png"));
        addChild(_back);

        _roll = new Image(_refs.gui.getTexture("indication_roll.png"));
        _roll.pivotX = _roll.width/2;
        _roll.x = _back.width/2;
        _roll.y = -40;
        addChild(_roll);
    }

    public function setBalance(value: Number):void {
        _roll.x = _back.width * (0.5 + value * 0.5);
    }
}
}
