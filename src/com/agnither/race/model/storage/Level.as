/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.model.storage {
import com.agnither.race.data.LevelVO;

import starling.events.EventDispatcher;

public class Level extends EventDispatcher {

    public static const UPDATE: String = "update_Level";

    private var _data: Object;

    public function get level():LevelVO {
        return LevelVO.getLevel(_data.id);
    }

    public function get opened():Boolean {
        return _data.opened;
    }

    public function Level(data: Object) {
        _data = data;
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
