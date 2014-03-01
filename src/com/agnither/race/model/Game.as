/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.model {
import com.agnither.race.data.HeroVO;
import com.agnither.race.data.LevelVO;

import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const INIT: String = "init_Game";
    public static const TICK: String = "tick_Game";

    private var _level: LevelVO;
    private var _hero: HeroVO;

    private var _player: Trolley;
    public function get player():Trolley {
        return _player;
    }

    private var _enemy: Trolley;
    public function get enemy():Trolley {
        return _enemy;
    }

    public function get location():String {
        return _level.location;
    }

    public function get difficulty():Number {
        var base: int = _level.difficulty;
        if (_level.hero > _hero.id-1) {
            return 1.1;
        }
        return base/100 * _hero.difficulty/100;
    }

    public function get length():int {
        return _level.length;
    }

    public function get playerProgress():Number {
        return Math.min(1, _player.position/length);
    }

    public function get enemyProgress():Number {
        return Math.min(1, _enemy.position/length);
    }

    private var _finished: Boolean;

    public function Game() {
        _player = new Trolley();
        _enemy = new Trolley();
    }

    public function prepare(id: int, hero: int):void {
        _level = LevelVO.getLevel(id);
        _hero = HeroVO.getHero(hero);
    }

    public function init():void {
        _player.init(1);

        _enemy.init(difficulty);
        _enemy.press(-1);

        dispatchEventWith(INIT);
    }

    public function step(delta: Number):void {
        if (!_finished && playerProgress==1) {
            press(0);
            _finished = true;
        }

        if (_enemy.locked) {
            _enemy.press(-_enemy.locked);
        }

        _player.step(delta);
        _enemy.step(delta);

//        trace(_player.pushes, _enemy.pushes, _player.position / _enemy.position);

        dispatchEventWith(TICK);
    }

    public function press(direction: int):void {
        if (!_finished) {
            _player.press(direction);
        }
    }
}
}
