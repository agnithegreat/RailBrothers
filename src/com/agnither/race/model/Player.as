/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.model {
import com.adobe.crypto.MD5;
import com.agnither.race.data.AreaVO;
import com.agnither.race.data.ClothVO;
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

    public function get money():int {
        return _data.data.money;
    }
    public function get moneyObtained():int {
        return _data.data.moneyObtained;
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

    public function get cloth():int {
        return _data.data.cloth;
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
    }

    private function createProgress():void {
        _data.data.deviceID = MD5.hash(String(Math.random()));
        _data.data.money = 0;
        _data.data.moneyObtained = 0;
        _data.data.levels = {1: true};

        _data.data.energy = 8;
        _data.data.energyTime = null;

        _data.data.hero = 1;
        _data.data.heroes = {};
        for (var key:* in HeroVO.HEROES) {
            var hero: HeroVO = HeroVO.HEROES[key];
            var opened: Boolean = hero.unlockcost==0 ? 1 : 0;
            _data.data.heroes[key] = {"opened": opened};
        }

        _data.data.cloth = 0;
        _data.data.clothes = {};
        for (key in ClothVO.CLOTHES) {
            _data.data.clothes[key] = {"opened": false};
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
            if (_data.data.areas[key].opened) {
                AreaVO.getArea(key).open();
            }
        }
    }

    private function updateLevels():void {
        for (var key: * in _data.data.levels) {
            LevelVO.getLevel(key).opened = true;
        }
    }

    public function unlockArea(area: AreaVO):void {
        _data.data.money -= area.unlockcost;
        _data.data.areas[area.id].opened = 1;

        var level: LevelVO = LevelVO.getArea(area.id)[0];
        unlockLevel(level.id);

        updateAreas();
        update();
    }

    public function unlockLevel(level: int):void {
        _data.data.levels[level] = true;

        updateLevels();
        update();
    }

    public function unlockHero(hero: HeroVO):void {
        _data.data.money -= hero.unlockcost;
        _data.data.heroes[hero.id].opened = true;

        update();
    }

    public function hasHero(id: int):Boolean {
        return _data.data.heroes[id].opened;
    }

    public function selectHero(id: int):void {
        _data.data.hero = id;

        update();
    }

    public function unlockCloth(cloth: ClothVO):void {
        _data.data.money -= cloth.unlockcost;
        _data.data.clothes[cloth.id].opened = true;

        update();
    }

    public function hasCloth(id: int):Boolean {
        return _data.data.clothes[id].opened;
    }

    public function selectCloth(id: int):void {
        _data.data.cloth = id;

        update();
    }

    public function addMoney(value: int):void {
        _data.data.money += value;
        _data.data.moneyObtained += value;

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

    public function refillEnergy():void {
        _data.data.money -= 10000;

        _data.data.energy = 8;
        _data.data.energyTime = null;

        update();
    }

    private function update():void {
        _data.flush();
        dispatchEventWith(UPDATE);
    }
}
}
