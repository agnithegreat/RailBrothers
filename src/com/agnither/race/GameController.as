/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race {
import com.agnither.race.data.LevelVO;
import com.agnither.race.model.Game;
import com.agnither.race.ui.GameScreen;
import com.agnither.race.ui.UI;
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

    public static const PRESS: String = "press";
    public static const RELEASE: String = "release";
    public static const LEFT: String = "left";
    public static const RIGHT: String = "right";

    private var _stage: Stage;
    private var _refs: CommonRefs;
    private var _resources: ResourcesManager;

    private var _view: MainScreen;
    private var _ui: UI;

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    private var _direction: int;

    public function GameController(stage: Stage, resources: ResourcesManager) {
        _stage = stage;
        _resources = resources;
        _refs = new CommonRefs(_resources);
    }

    public function init():void {
        _game = new Game();

        _view = new MainScreen(_refs, this);
        _stage.addChildAt(_view, 0);

        _ui = new UI(_refs, this);
        _ui.addEventListener(PRESS, handlePress);
        _ui.addEventListener(RELEASE, handleRelease);
        _stage.addChildAt(_ui, 1);

        _stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        _stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
    }

    public function start(level: int):void {
        _game.prepare(level, 1);

        _resources.addEventListener(ResourcesManager.COMPLETE, handleStart);
        _resources.loadGame(_game.location);
    }

    private function handleStart(e: Event):void {
        _game.init();

        _view.showGame();
        _ui.showScreen(GameScreen.ID);

        _stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
    }

    private function handleEnterFrame(e: EnterFrameEvent):void {
        _game.step(e.passedTime);
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
}
}
