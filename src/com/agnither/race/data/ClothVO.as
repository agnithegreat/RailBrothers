/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:22 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {

public class ClothVO {

    public static const CLOTHES: Object = {};
    public static function getCloth(id: int):ClothVO {
        return CLOTHES[id];
    }

    public var id: int;
    public var name: String;
    public var speedup: int;
    public var unlockcost: int;
    public var description: String;

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var cloth: ClothVO = new ClothVO();
            for (var key: String in object) {
                cloth[key] = object[key];
            }

            CLOTHES[cloth.id] = cloth;
        }
    }

    public function get icon():String {
        return name+".png";
    }
}
}
