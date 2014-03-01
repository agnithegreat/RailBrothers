/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view {
import com.agnither.race.model.Trolley;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;

public class TrolleyView extends AbstractView {

    private var _trolley: Trolley;

    private var _steer: Image;
    private var _base: Image;
    private var _wheel1: Image;
    private var _wheel2: Image;

    public function TrolleyView(refs: CommonRefs, trolley: Trolley) {
        _trolley = trolley;

        super(refs);
    }

    override protected function initialize():void {
        _trolley.addEventListener(Trolley.UPDATE, handleUpdate);

        _steer = new Image(_refs.gui.getTexture("steer.png"));
        _steer.pivotX = _steer.width/2;
        _steer.pivotY = _steer.height/2;
        _steer.y = -81;
        addChild(_steer);

        _base = new Image(_refs.gui.getTexture("trolley.png"));
        _base.pivotX = _base.width/2;
        _base.pivotY = 90;
        addChild(_base);

        _wheel1 = new Image(_refs.gui.getTexture("wheel.png"));
        _wheel1.pivotX = _wheel1.width/2;
        _wheel1.pivotY = _wheel1.height/2;
        _wheel1.x = -60;
        addChild(_wheel1);

        _wheel2 = new Image(_refs.gui.getTexture("wheel.png"));
        _wheel2.pivotX = _wheel2.width/2;
        _wheel2.pivotY = _wheel2.height/2;
        _wheel2.x = 60;
        addChild(_wheel2);
    }

    private function handleUpdate(e: Event):void {
        _wheel1.rotation = _trolley.position * Math.PI * 50 / 10000;
        _wheel2.rotation = _trolley.position * Math.PI * 50 / 10000;

        _steer.rotation = _trolley.balance * Math.PI/6 - Math.PI * 0.093;
    }
}
}
