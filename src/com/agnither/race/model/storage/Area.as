/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.model.storage {
import com.agnither.race.data.AreaVO;

import starling.events.EventDispatcher;

public class Area extends EventDispatcher {

    public static const UPDATE: String = "update_Area";

    private var _data: Object;

    public function get area():AreaVO {
        return AreaVO.getArea(_data.id);
    }

    public function get opened():Boolean {
        return _data.opened;
    }

    public function Area(data: Object) {
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
