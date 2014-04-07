/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:35 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {

public class LevelVO {

    public static const LEVELS: Vector.<LevelVO> = new <LevelVO>[];
    public static function getLevel(id: int):LevelVO {
        return LEVELS[id-1];
    }

    public static const AREAS: Object = {};
    public static function getArea(id: int):Vector.<LevelVO> {
        return AREAS[id];
    }

    public var id: int;
    public var area: AreaVO;
    public var difficulty: int;
    public var length: int;
    public var bonus: int;

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var level: LevelVO = new LevelVO();
            for (var key: String in object) {
                if (key == "area") {
                    level[key] = AreaVO.getArea(object[key]);
                } else {
                    level[key] = object[key];
                }
            }

            LEVELS.push(level);

            if (!AREAS[level.area.id]) {
                AREAS[level.area.id] = new <LevelVO>[];
            }
            AREAS[level.area.id].push(level);
        }
    }

    public var opened: Boolean;
}
}
