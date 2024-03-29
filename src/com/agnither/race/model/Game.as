/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.model {
import com.agnither.race.data.ClothVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.data.LevelVO;

import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const INIT: String = "init_Game";
    public static const TICK: String = "tick_Game";
    public static const FINISHED: String = "finished_Game";

    private var _level: LevelVO;
    private var _hero: HeroVO;
    private var _cloth: ClothVO;

    private var _player: Trolley;
    public function get player():Trolley {
        return _player;
    }

    private var _enemy: Trolley;
    public function get enemy():Trolley {
        return _enemy;
    }

    public function get location():String {
        return _level.area.name;
    }

    public function get difficulty():Number {
        var base: int = _level.difficulty;
        if (_level.area.hero > _hero.id-1) {
            return (100+HeroVO.getHero(_level.area.hero).speedup)/100;
        }
        return base/100;
    }

    public function get length():int {
        return _level.length/3;
    }

    public function get playerProgress():Number {
        return Math.min(1, _player.position/length);
    }

    public function get enemyProgress():Number {
        return Math.min(1, _enemy.position/length);
    }

    private var _finished: Boolean;

    public function get isRunning():Boolean {
        return !_finished;
    }

    private var _win: Boolean;
    public function get win():Boolean {
        return _win;
    }

    public function Game() {
        _player = new Trolley();
        _enemy = new Trolley();
    }

    public function prepare(id: int, hero: int, cloth: int):void {
        _level = LevelVO.getLevel(id);
        _hero = HeroVO.getHero(hero);
        _cloth = ClothVO.getCloth(cloth);
    }

    public function init():void {
        var speedup: Number = _cloth ? _hero.speedup+_cloth.speedup : _hero.speedup;
        _player.init(_hero, (100+speedup)/100);

        _enemy.init(null, difficulty);
        _enemy.press(-1);

        _finished = false;
        _win = false;

        dispatchEventWith(INIT);
    }

    public function step(delta: Number):void {
        if (!_finished && (playerProgress==1 || enemyProgress==1)) {
            _player.press(0);
            _enemy.press(0);
            _finished = true;
            _win = enemyProgress < playerProgress;
            _player.endGame(_win);
            dispatchEventWith(FINISHED);
        }

        if (!_finished && _enemy.locked) {
            _enemy.press(-_enemy.locked);
        }

        _player.step(delta);
        _enemy.step(delta);

        dispatchEventWith(TICK);
    }

    public function press(direction: int):void {
        if (!_finished) {
            _player.press(direction);
        }
    }

    public function destroy():void {
        _level = null;
        _hero = null;
    }
}
}
