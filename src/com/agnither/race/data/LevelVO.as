/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:35 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {

public class LevelVO {

    public static const LEVELS: Object = {};
    public static function getLevel(id: int):LevelVO {
        return LEVELS[id];
    }

    public var id: int;
    public var location: String;
    public var hero: int;
    public var difficulty: int;
    public var length: int;
    public var bonus: int;
    public var unlockcost: int;

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var level: LevelVO = new LevelVO();
            for (var key: String in object) {
                level[key] = object[key];
            }

            LEVELS[level.id] = level;
        }
    }
}
}
