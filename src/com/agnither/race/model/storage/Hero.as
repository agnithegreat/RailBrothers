/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.model.storage {
import com.agnither.race.data.HeroVO;

import starling.events.EventDispatcher;

public class Hero extends EventDispatcher {

    public static const UPDATE: String = "update_Hero";

    private var _data: Object;

    public function get hero():HeroVO {
        return HeroVO.getHero(_data.id);
    }

    public function get opened():Boolean {
        return _data.opened;
    }

    public function Hero(data: Object) {
        _data = data
    }

    public function open():void {
        _data.opened = true;

        update();
    }

    private function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
