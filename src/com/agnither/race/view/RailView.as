/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view {
import com.agnither.ui.AbstractView;
import com.agnither.ui.TiledImage;
import com.agnither.utils.CommonRefs;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;

public class RailView extends AbstractView {

    private var _rail: TiledImage;

    private var _sleepers: Sprite;
    private var _last: int;

    public function RailView(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _rail = new TiledImage(_refs.gui.getTexture("rail.png"), 16);
        addChild(_rail);

        _sleepers = new Sprite();
        _sleepers.y = 17;
        addChild(_sleepers);

        for (var i:int = 0; i < 15; i++) {
            var sleeper: Image = new Image(_refs.gui.getTexture("sleeper.png"));
            sleeper.x = 81 * _last++;
            _sleepers.addChild(sleeper);
        }
    }

    public function progress(value: int):void {
        _sleepers.pivotX = value;

        var sleeper: Image = _sleepers.getChildAt(0) as Image;
        var bounds: Rectangle = sleeper.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            sleeper.x = 81 * _last++;
            _sleepers.addChild(sleeper);
        }
    }
}
}
