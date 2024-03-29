/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:22 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {

public class HeroVO {

    public static const HEROES: Object = {};
    public static function getHero(id: int):HeroVO {
        return HEROES[id];
    }

    public var id: int;
    public var description: String;
    public var speedup: int;
    public var skin: int;
    public var unlockcost: int;
    public var hat: String;
    public var moustache: String;
    public var jacket: String;

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var hero: HeroVO = new HeroVO();
            for (var key: String in object) {
                hero[key] = object[key];
            }

            HEROES[hero.id] = hero;
        }
    }

    public function get icon():String {
        return "men"+id+".png";
    }
}
}
