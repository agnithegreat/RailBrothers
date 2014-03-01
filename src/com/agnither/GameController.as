/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/25/13
 * Time: 12:13 PM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither {
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import flash.geom.Point;

import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class GameController extends EventDispatcher {

    public static const INIT: String = "init_GameController";
    public static const PAUSE: String = "pause_GameController";
    public static const SHOW_SCREEN: String = "show_screen_GameController";
    public static const SHOW_POPUP: String = "show_popup_GameController";
    public static const CLEAR_SCREEN: String = "clear_screen_GameController";

    public static const UI_ACTION: String = "ui_action_GameController";
    public static const MENU: String = "menu";
    public static const REPLAY: String = "replay";
    public static const NEXT: String = "next";
    public static const CONTINUE: String = "continue";
    public static const PLAY: String = "play";
    public static const START: String = "start";
    public static const MUSIC: String = "music";
    public static const SOUND: String = "sound";
    public static const HELP: String = "help";

    public static const CHEAT: String = "cheat_GameController";
    public static const UNLOCK: String = "unlock";
    public static const DEBUG: String = "debug";
    public static const RESET: String = "reset";

    public static var gameJuggler: Juggler;

    private var _stage: Stage;
    private var _refs: CommonRefs;
    private var _resources: ResourcesManager;

    private var _player: Player;
    public function get player():Player {
        return _player;
    }

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    private var _level: int;

    private var _paused: Boolean;

    private var _view: MainScreen;
    private var _ui: UI;

    public function GameController(stage: Stage, resources: ResourcesManager) {
        _stage = stage;
        _resources = resources;
        _refs = new CommonRefs(_resources);
    }

    public function init():void {
        _player = new Player();
        _player.init();

        _paused = true;

        _game = new Game(_player);
        _game.initField(520, 720, _stage.stageWidth, _stage.stageHeight);
        _game.addEventListener(Game.LOCK, handleLockGame);
        _game.addEventListener(Game.END_GAME, handleEndGame);

        _ui = new UI(_refs, this);
        _ui.addEventListener(TopPanelUI.PAUSE, handlePause);
        _ui.addEventListener(ShopTile.BUY, handleShopBuy);
        _ui.addEventListener(ShopTile.UNLOCK, handleShopUnlock);
        _ui.addEventListener(ShopTile.UPGRADE, handleShopUpgrade);
        _ui.addEventListener(UI_ACTION, handleUIAction);
        _ui.addEventListener(CHEAT, handleCheat);
        _stage.addChildAt(_ui, 0);

        _view = new MainScreen(_refs, this);
        _view.addEventListener(CastleView.LEVEL_SELECTED, handleLevelSelect);
        _stage.addChildAt(_view, 0);

        _stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);

        dispatchEventWith(INIT);

        showMap();
    }

    // screens
    private function showPreloader():void {
        dispatchEventWith(SHOW_SCREEN, false, PreloaderScreen.ID);
    }
    private function showLevelLoader():void {
        dispatchEventWith(SHOW_SCREEN, false, LevelLoaderScreen.ID);
    }
    private function showTutorialLoader():void {
        dispatchEventWith(SHOW_SCREEN, false, TutorialLoaderScreen.ID);
    }
    private function showMenu():void {
        dispatchEventWith(SHOW_SCREEN, false, MenuScreen.ID);
    }
    private function showBattle():void {
        dispatchEventWith(SHOW_SCREEN, false, BattleScreen.ID);
    }
    private function showTutorial():void {
        dispatchEventWith(SHOW_SCREEN, false, TutorialScreen.ID);
    }
    private function clearScreen():void {
        dispatchEventWith(CLEAR_SCREEN);
    }

    // popups
    private function showShop():void {
        dispatchEventWith(SHOW_POPUP, false, ShopPopup.ID);
        dispatchEventWith(MENU, false, true);
//        SoundManager.musicMultiplier = 0.4;
    }
    private function showPause():void {
        dispatchEventWith(SHOW_POPUP, false, PausePopup.ID);
        dispatchEventWith(MENU, false, true);
    }
    private function showResults():void {
        dispatchEventWith(SHOW_POPUP, false, ResultsPopup.ID);
        dispatchEventWith(MENU, false, false);
    }

    private function showMap():void {
        clearScreen();

        showMenu();

        _view.showMap();
    }

    public function prepareLevel(id: int):void {
        gameJuggler = new Juggler();

        _level = id;

        showMenu();

        if (_game.player.shopOpened) {
            showShop();
        } else {
            startLevel(_level);
        }
    }

    public function startLevel(id: int):void {
        Statistics.startLevelEvent(id);

        clearScreen();

        if (!_player.getTutorial(id)) {
            _tutorial.prepare(id);
            showTutorialLoader();
        } else {
            _game.prepare(id);
            showLevelLoader();
        }

        _resources.addEventListener(ResourcesManager.COMPLETE, handleLoadAnimation);
        _resources.loadAnimations();
    }

    private function handleLoadAnimation():void {
        _resources.removeEventListener(ResourcesManager.COMPLETE, handleLoadAnimation);

        Animations.loadAnimation();

        if (!_player.getTutorial(_level)) {
            GameScreen.createMobs(_tutorial.mobs);
//            GameScreen.createSpells(_player.spells);

            _resources.loadGame(_tutorial.location, _tutorial.player.hp);
        } else {
            GameScreen.createMobs(_game.level.mobs);
//            GameScreen.createSpells(_player.spells);

            _resources.loadGame(_game.level.location, _game.player.hp);
        }
    }

    private function startAfterLoading():void {
        clearScreen();

        if (!_player.getTutorial(_level)) {
            showTutorial();
            _view.showTutorial();
            _tutorial.init();
        } else {
            showBattle();
            _view.showGame();
            _game.init();
        }

        addGameHandlers();

        pause(false);
    }

    public function endLevel():void {
        if (_game.isInited || _tutorial.active) {
            removeGameHandlers();

            pause(true);

            SoundManager.reset();

            if (_tutorial.active) {
                _tutorial.destroy()
            } else {
                _game.destroy();
            }

            _view.destroyCurrent();

            Animations.dispose();

            _resources.clearGame();
            _resources.clearAnimations();
        }
    }

    private function addGameHandlers():void {
        _view.addEventListener(WizardView.END_ANIMATION, handleEndWizardAnimation);

        _view.addEventListener(EnemyView.END_ANIMATION, handleEndAnimation);
        _view.addEventListener(EnemyView.HIT_EVENT, handleHitEvent);
        _view.addEventListener(EnemyView.HEAL_EVENT, handleHealEvent);
        _view.addEventListener(EnemyView.SHOT_EVENT, handleShotEvent);
        _view.addEventListener(EnemyView.BOMB_EVENT, handleBombEvent);

        _view.addEventListener(SpellView.ACTIVATE, handleActivateSpell);
        _view.addEventListener(SpellView.EXPLODE, handleExplodeSpell);
        _view.addEventListener(DropView.COLLECT, handleCollectDrop);

        _ui.addEventListener(ActiveTileUI.APPLY, handleApplyActive);

        _stage.addEventListener(TouchEvent.TOUCH, handleTouch);
        _stage.addEventListener(PAUSE, handleStarlingPause);
        _gesture.addEventListener(GestureEvent.GESTURE_MATCH, handleGesture);
    }

    private function removeGameHandlers():void {
        _view.removeEventListener(WizardView.END_ANIMATION, handleEndWizardAnimation);

        _view.removeEventListener(EnemyView.END_ANIMATION, handleEndAnimation);
        _view.removeEventListener(EnemyView.HIT_EVENT, handleHitEvent);
        _view.removeEventListener(EnemyView.HEAL_EVENT, handleHealEvent);
        _view.removeEventListener(EnemyView.SHOT_EVENT, handleShotEvent);
        _view.removeEventListener(EnemyView.BOMB_EVENT, handleBombEvent);

        _view.removeEventListener(SpellView.ACTIVATE, handleActivateSpell);
        _view.removeEventListener(SpellView.EXPLODE, handleExplodeSpell);
        _view.removeEventListener(DropView.COLLECT, handleCollectDrop);

        _ui.removeEventListener(ActiveTileUI.APPLY, handleApplyActive);

        _stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
        _stage.removeEventListener(PAUSE, handleStarlingPause);
        _gesture.removeEventListener(GestureEvent.GESTURE_MATCH, handleGesture);
    }

    private function handleStarlingPause(e: Event):void {
        if (_tutorial.active) {
            return;
        }

        pause(true);
        showMenu();
        showPause();
    }

    private function handleEnterFrame(e: EnterFrameEvent):void {
        WorldClock.clock.advanceTime(-1);

        var delta: int = e.passedTime*1000;

        if (_paused) {
            return;
        } else {
            if (_tutorial.active) {
                _tutorial.step(delta);
            } else {
                _game.step(delta);
            }
            _gesture.step();
        }
    }

    public function pause(value: Boolean):void {
        _player.save();
        if (_paused==value) {
            return;
        }
        _paused = value;
        if (!_tutorial.active) {
            _game.pause(_paused);
        }
        if (_paused) {
            _gesture.stop();

            SoundManager.pause(false);

            Starling.juggler.remove(gameJuggler);
            WorldClock.clock.remove(gameClock);
        } else {
            dispatchEventWith(MENU, false, false);

            if (!_tutorial.active) {
                showBattle();
            }

            _gesture.start();

            SoundManager.unpause();

            Starling.juggler.add(gameJuggler);
            WorldClock.clock.add(gameClock);
        }
    }

    private function handleLevelSelect(e: Event):void {
        if (e.data > _player.level) {
            return;
        }

        prepareLevel(e.data as int);
    }

    private function handleShopBuy(e: Event):void {
        _player.buy(e.data);
    }

    private function handleShopUnlock(e: Event):void {
        _player.unlock(e.data);
    }

    private function handleShopUpgrade(e: Event):void {
        _player.upgrade(e.data);
    }

    private function handleTouch(e: TouchEvent):void {
        if (!_paused) {
            var l: int = e.touches.length;
            for (var i:int = 0; i < l; i++) {
                var touch: Touch = e.touches[i];
                if (touch.phase == TouchPhase.BEGAN) {
                    if (_tutorial.active) {
                        _tutorial.applySpell(SpellVO.TAP, new <Point>[touch.getLocation(_stage)]);
                    } else {
                        _game.applySpell(SpellVO.TAP, new <Point>[touch.getLocation(_stage)]);
                    }
                }
            }
        }
    }

    private function handleGesture(e: GestureEvent):void {
        if (_tutorial.active) {
            _tutorial.applySpell(e.result.name, e.result.points);
        } else {
            _game.applySpell(e.result.name, e.result.points);
        }
    }

    private function handleApplyActive(e: Event):void {
        if (_tutorial.active) {
            _tutorial.applyActive(e.data as ActiveData);
        } else {
            _game.applyActive(e.data as ActiveData);
        }
    }

    private function handleEndWizardAnimation(e: Event):void {
        if (_tutorial.active) {
            _tutorial.endWizardAnimation();
        } else {
            _game.endWizardAnimation();
        }
    }

    private function handleEndAnimation(e: Event):void {
        if (_tutorial.active) {
            _tutorial.endAnimation(e.data as int);
        } else {
            _game.endAnimation(e.data as int);
        }
    }

    private function handleHitEvent(e: Event):void {
        if (_tutorial.active) {
            _tutorial.hitTower(e.data as int);
        } else {
            _game.hitTower(e.data as int);
        }
    }

    private function handleHealEvent(e: Event):void {
        if (!_tutorial.active) {
            _game.heal(e.data as int);
        }
    }

    private function handleShotEvent(e: Event):void {
        if (_tutorial.active) {
            _tutorial.shoot(e.data as int);
        } else {
            _game.shoot(e.data as int);
        }
    }

    private function handleBombEvent(e: Event):void {
        if (_tutorial.active) {
            _tutorial.bomb(e.data as int);
        } else {
            _game.bomb(e.data as int);
        }
    }

    private function handleActivateSpell(e: Event):void {
        if (_tutorial.active) {
            _tutorial.activateSpell(e.data as int);
        } else {
            _game.activateSpell(e.data as int);
        }
    }

    private function handleExplodeSpell(e: Event):void {
        if (_tutorial.active) {
            _tutorial.explodeSpell(e.data as int);
        } else {
            _game.explodeSpell(e.data as int);
        }
    }

    private function handleCollectDrop(e: Event):void {
        if (!_tutorial.active) {
            _game.collectDrop(e.data as Drop);
        }
    }

    private function handlePause(e: Event):void {
        if (_tutorial.active) {
            return;
        }

        pause(true);
        showMenu();
        showPause();
    }

    private function handleLockGame(e: Event):void {
        removeGameHandlers();
    }

    private function handleEndGame(e: Event):void {
        _game.removeAll();

        pause(true);
        clearScreen();
        showResults();

        _player.storage.setLevelScore(_game.levelID, _game.money, _game.stars);
        _player.addMoney(_game.money);
        _player.addMoney(_player.goals.check());

        if (_game.win) {
            _player.addMoney(_game.level.reward[_game.stars-1]);

            _player.updateLevel(_game.levelID+1);
        }
    }

    private function handleEndTutorial(e: Event):void {
        _player.completeTutorial(_level);

        clearScreen();

        endLevel();
        prepareLevel(_level);
    }

    private function handleUIAction(e: Event):void {
        switch (e.data) {
            case MENU:
                endLevel();
                showMap();
                break;
            case REPLAY:
                endLevel();
                prepareLevel(_game.levelID);
                break;
            case NEXT:
                endLevel();
                showMap();
                break;
            case CONTINUE:
                pause(false);
                break;
            case PLAY:
                startLevel(_level);
                break;
            case START:
                startAfterLoading();
                break;

            case MUSIC:
                _player.music = _player.music ? 0 : 1;
                break;
            case SOUND:
                _player.sound = _player.sound ? 0 : 1;
                break;
            case HELP:
                // TODO: show help
                break;
        }
    }

    private function handleCheat(e: Event):void {
        switch (e.data) {
            case UNLOCK:
                _player.updateLevel(100);
                _player.addMoney(1000);
                break;
            case DEBUG:
                Starling.current.showStats = !Starling.current.showStats;
                break;
            case RESET:
                _player.reset();
                break;
        }
    }
}
}
