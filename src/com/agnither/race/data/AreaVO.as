/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:35 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {
import starling.events.EventDispatcher;

public class AreaVO extends EventDispatcher {

    public static const UPDATE: String = "update_AreaVO";

    public static const AREAS: Vector.<AreaVO> = new <AreaVO>[];
    public static function getArea(id: int):AreaVO {
        return AREAS[id-1];
    }

    public var id: int;
    public var name: String;
    public var hero: int;
    public var unlockcost: int;

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var area: AreaVO = new AreaVO();
            for (var key: String in object) {
                if (area.hasOwnProperty(key)) {
                    area[key] = object[key];
                }
            }

            if (area.unlockcost==0) {
                area.open();
            }
            AREAS.push(area);
        }
    }

    private var _opened: Boolean;
    public function get opened():Boolean {
        return _opened;
    }

    public function open():void {
        _opened = true;
        dispatchEventWith(UPDATE);
    }
}
}
