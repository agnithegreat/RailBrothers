/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.12.13
 * Time: 12:18
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {
import com.agnither.utils.Random;

import flash.utils.Dictionary;

public class SoundVO {

    public static const EVENT_MAIN: String = "main";
    public static const EVENT_INGAME: String = "ingame";
    public static const EVENT_LEVEL: String = "level";
    public static const EVENT_ACTIVE: String = "active";
    public static const EVENT_SPELL: String = "spell";
    public static const EVENT_BUTTON: String = "button";
    public static const EVENT_ATTACK: String = "attack";
    public static const EVENT_DEATH: String = "death";
    public static const EVENT_SPECIAL: String = "special";
    public static const EVENT_NOTIFY: String = "notify";

    public static const TYPE_MUSIC: String = "music";
    public static const TYPE_SOUND: String = "sound";

    public static const SOUNDS: Dictionary = new Dictionary();
    public static function getSound(event: String, value: String = null):SoundVO {
        return value ? (SOUNDS[event+"."+value] ? SOUNDS[event+"."+value] : SOUNDS[event]) : SOUNDS[event];
    }

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var sound: SoundVO = new SoundVO();
            for (var key: String in object) {
                sound[key] = object[key];
            }

            if (sound.value) {
                SOUNDS[sound.event+"."+sound.value] = sound;
            } else {
                SOUNDS[sound.event] = sound;
            }
        }
    }

    public var id: int;
    public var event: String;
    public var value: String;
    public var sound: String;
    public var variants: int;
    public var loop: Boolean;
    public var type: String;

    public function get soundName():String {
        if (variants>0) {
            var val: int = Random.random()*variants+1;
            return sound+"_"+val;
        }
        return sound;
    }
}
}
