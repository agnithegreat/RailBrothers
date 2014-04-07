/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race {
import com.agnither.race.data.AreaVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.data.LevelVO;
import com.agnither.race.model.Game;
import com.agnither.race.model.Player;
import com.agnither.race.ui.GameScreen;
import com.agnither.race.ui.UI;
import com.agnither.race.ui.popups.DefeatPopup;
import com.agnither.race.ui.popups.PausePopup;
import com.agnither.race.ui.popups.VictoryPopup;
import com.agnither.race.ui.screens.area.AreaSelectScreen;
import com.agnither.race.ui.screens.level.LevelSelectScreen;
import com.agnither.race.ui.screens.shop.ShopScreen;
import com.agnither.race.view.MainScreen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import flash.ui.Keyboard;

import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.KeyboardEvent;

public class GameController extends EventDispatcher {

    public static const UI_ACTION: String = "ui_action_GameController";
    public static const BACK: String = "back";
    public static const SHOP: String = "shop";
    public static const MENU: String = "menu";
    public static const PAUSE: String = "pause";
    public static const REPLAY: String = "replay";
    public static const CONTINUE: String = "continue";
    public static const NEXT: String = "next";

    public static const PRESS: String = "press";
    public static const RELEASE: String = "release";
    public static const LEFT: String = "left";
    public static const RIGHT: String = "right";

    private var _stage: Stage;
    private var _refs: CommonRefs;
    private var _resources: ResourcesManager;

    private var _view: MainScreen;
    private var _ui: UI;

    private var _player: Player;
    public function get player():Player {
        return _player;
    }

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    private var _currentArea: int;
    public function get currentArea():int {
        return _currentArea;
    }

    private var _currentLevel: int;

    private var _direction: int;

    private var _paused: Boolean;

    public function GameController(stage: Stage, resources: ResourcesManager) {
        _stage = stage;
        _resources = resources;
        _refs = new CommonRefs(_resources);
    }

    public function init():void {
        _player = new Player();
        _player.init();

        _game = new Game();
        _game.addEventListener(Game.FINISHED, handleFinished);

        _view = new MainScreen(_refs, this);
        _stage.addChildAt(_view, 0);

        _ui = new UI(_refs, this);
        _ui.addEventListener(PRESS, handlePress);
        _ui.addEventListener(RELEASE, handleRelease);
        _ui.addEventListener(AreaSelectScreen.SELECT_AREA, handleSelectArea);
        _ui.addEventListener(LevelSelectScreen.SELECT_LEVEL, handleSelectLevel);
        _stage.addChildAt(_ui, 1);

        _stage.addEventListener(UI_ACTION, handleUIAction);

        showAreas();
    }

    private function showAreas():void {
        _ui.clearScreen();

        _ui.showScreen(AreaSelectScreen.ID);
    }

    private function showLevels():void {
        _ui.clearScreen();

        _ui.showScreen(LevelSelectScreen.ID);
    }

    private function showShop():void {
        _ui.clearScreen();

        _ui.showScreen(ShopScreen.ID);
    }

    public function start(level: int):void {
        if (_player.energy < 1) {
            return;
        }

        _currentLevel = level;

        _game.prepare(_currentLevel, _player.hero);

        _resources.addEventListener(ResourcesManager.COMPLETE, handleStart);
        _resources.loadGame(_game.location);
    }

    private function handleStart(e: Event):void {
        _direction = 0;

        _player.useEnergy();
        _game.init();

        _view.showGame();

        _ui.clearScreen();
        _ui.showScreen(GameScreen.ID);

        _stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
        _stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        _stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
    }

    private function end():void {
        _stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
        _stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        _stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);

        _view.destroyGame();

        _resources.clearGame();

        _game.destroy();
    }

    public function pause(value: Boolean):void {
        _paused = value;
        if (_paused) {
            _ui.showPopup(PausePopup.ID);
        }
    }



    private function handleSelectArea(e: Event):void {
        var area: AreaVO = e.data as AreaVO;
        if (area.opened) {
            _currentArea = area.id;
            showLevels();
        } else if (area.unlockcost <= _player.money) {
            _player.unlockArea(area);
        } else {

        }
    }

    private function handleSelectLevel(e: Event):void {
        var level: LevelVO = e.data as LevelVO;
        if (level.opened) {
            start(level.id);
        }
    }

    private function handleSelectHero(e: Event):void {
        var hero: HeroVO = e.data as HeroVO;
        if (hero.opened) {
            _player.selectHero(hero.id);
        } else {
            _player.unlockHero(hero);
        }
    }

    private function handleFinished(e: Event):void {
        if (_game.win) {
            var level: LevelVO = LevelVO.getLevel(_currentLevel);
            _player.addMoney(level.bonus);

            _player.unlockLevel(_currentLevel+1);

            _ui.showPopup(VictoryPopup.ID, level.bonus);
        } else {
            _ui.showPopup(DefeatPopup.ID);
        }
    }




    private function handleEnterFrame(e: EnterFrameEvent):void {
        if (!_paused) {
            _game.step(e.passedTime);
        }
    }

    private function handlePress(e: Event):void {
        switch (e.data) {
            case LEFT:
                if (_direction != -1) {
                    _direction = -1;
                    _game.press(_direction);
                }
                break;
            case RIGHT:
                if (_direction != 1) {
                    _direction = 1;
                    _game.press(_direction);
                }
                break;
        }
    }
    private function handleRelease(e: Event):void {
        switch (e.data) {
            case LEFT:
                if (_direction==-1) {
                    _game.press(0);
                    _direction = 0;
                }
                break;
            case RIGHT:
                if (_direction==1) {
                    _game.press(0);
                    _direction = 0;
                }
                break;
        }
        _direction = 0;
    }

    private function handleKeyDown(e: KeyboardEvent):void {
        switch (e.keyCode) {
            case Keyboard.LEFT:
                if (_direction != -1) {
                    _direction = -1;
                    _game.press(_direction);
                }
                break;
            case Keyboard.RIGHT:
                if (_direction != 1) {
                    _direction = 1;
                    _game.press(_direction);
                }
                break;
        }
    }
    private function handleKeyUp(e: KeyboardEvent):void {
        switch (e.keyCode) {
            case Keyboard.LEFT:
                if (_direction==-1) {
                    _game.press(0);
                    _direction = 0;
                }
                break;
            case Keyboard.RIGHT:
                if (_direction==1) {
                    _game.press(0);
                    _direction = 0;
                }
                break;
        }
    }




    private function handleUIAction(e: Event):void {
        switch (e.data) {
            case BACK:
                showAreas();
                break;
            case SHOP:
                showShop();
                break;
            case MENU:
                end();
                showLevels();
                break;
            case PAUSE:
                pause(true);
                break;
            case REPLAY:
                end();
                start(_currentLevel);
                break;
            case CONTINUE:
                pause(false);
                break;
            case NEXT:
                end();
                // TODO: проверка на открытость локации
                start(_currentLevel+1);
                break;
        }
    }
}
}
