/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.model {
import com.adobe.crypto.MD5;
import com.agnither.race.data.AreaVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.data.LevelVO;

import flash.net.SharedObject;

import starling.events.EventDispatcher;

public class Player extends EventDispatcher {

    public static const UPDATE: String = "update_Player";

    public static const version: int = 3;

    private static var energyRecoveryTime: int = 300;

    private var _data: SharedObject;

    public function get uid():String {
        return _data.data.uid;
    }

    public function get level():int {
        return _data.data.level;
    }

    public function get money():int {
        return _data.data.money;
    }

    public function get energy():int {
        var energyTime: Date = new Date(_data.data.energyTime);
        var now: Date = new Date();
        var energyByTime: int = _data.data.energyTime ? (now.time-energyTime.time)*0.001 / energyRecoveryTime : 0;
        return Math.min(_data.data.energy + energyByTime, 8);
    }

    public function get hero():int {
        return _data.data.hero;
    }

    public function Player() {
    }

    public function init():void {
        _data = SharedObject.getLocal("player");
        if (!_data.data.version || _data.data.version < 2) {
            createProgress();
        } else if (_data.data.version < version) {
            for (var i:int = _data.data.version; i < version; i++) {
                updateProgress(i+1);
            }
        }

        updateAreas();
        updateLevels();
        updateHeroes();
    }

    private function createProgress():void {
        _data.data.deviceID = MD5.hash(String(Math.random()));
        _data.data.money = 0;
        _data.data.level = 1;

        _data.data.energy = 8;
        _data.data.energyTime = null;

        _data.data.hero = 1;
        _data.data.heroes = {};
        for (var key:* in HeroVO.HEROES) {
            var hero: HeroVO = HeroVO.HEROES[key];
            var opened: Boolean = hero.unlockcost==0 ? 1 : 0;
            _data.data.heroes[key] = {"opened": opened};
        }

        _data.data.areas = {};
        var l: int = AreaVO.AREAS.length;
        for (var i:int = 0; i < l; i++) {
            var area: AreaVO = AreaVO.AREAS[i];
            opened = area.unlockcost==0 ? 1 : 0;
            _data.data.areas[area.id] = {"opened": opened};
        }

        _data.data.music = 1;
        _data.data.sound = 1;
        _data.data.version = version;
    }

    private function updateProgress(ver: int):void {
        switch (ver) {
            case 3:
                _data.data.energy = 8;
                _data.data.energyTime = null;
                break;
        }
        _data.data.version = version;
    }

    private function updateAreas():void {
        for (var key:* in _data.data.areas) {
            AreaVO.getArea(key).opened = Boolean(_data.data.areas[key].opened);
        }
    }

    private function updateLevels():void {
        for (var i:int = 0; i < level; i++) {
            LevelVO.getLevel(i+1).opened = true;
        }
    }

    private function updateHeroes():void {
        for (var key:* in _data.data.heroes) {
            HeroVO.getHero(key).opened = Boolean(_data.data.heroes[key].opened);
        }
    }

    public function unlockArea(area: AreaVO):void {
        _data.data.money -= area.unlockcost;
        _data.data.areas[area.id].opened = 1;

        updateAreas();
        update();
    }

    public function unlockLevel(level: int):void {
        if (_data.data.level < level) {
            _data.data.level = level;
        }

        updateLevels();
        update();
    }

    public function unlockHero(hero: HeroVO):void {
        _data.data.money -= hero.unlockcost;
        _data.data.heroes[hero.id].opened = true;

        updateHeroes();
        update();
    }

    public function selectHero(id: int):void {
        _data.data.hero = id;

        update();
    }

    public function addMoney(value: int):void {
        _data.data.money += value;

        update()
    }

    public function useEnergy():void {
        if (!_data.data.energyTime || energy == 8) {
            _data.data.energy = 8;
            _data.data.energyTime = (new Date()).time;
        }

        _data.data.energy--;

        update();
    }

    private function update():void {
        _data.flush();
        dispatchEventWith(UPDATE);
    }
}
}
