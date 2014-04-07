/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:35 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {

public class AreaVO {

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

            area.opened = area.unlockcost==0;
            AREAS.push(area);
        }
    }

    public var opened: Boolean;
}
}
