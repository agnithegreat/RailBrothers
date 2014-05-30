/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race {
import com.agnither.race.data.AreaVO;
import com.agnither.race.data.BankVO;
import com.agnither.race.data.ClothVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.data.LevelVO;
import com.agnither.race.managers.Services;
import com.agnither.race.model.Game;
import com.agnither.race.model.Player;
import com.agnither.race.ui.GameScreen;
import com.agnither.race.ui.UI;
import com.agnither.race.ui.popups.BuyPopup;
import com.agnither.race.ui.popups.DefeatPopup;
import com.agnither.race.ui.popups.LocationUnlockedPopup;
import com.agnither.race.ui.popups.NotEnoughPopup;
import com.agnither.race.ui.popups.PausePopup;
import com.agnither.race.ui.popups.RestorePopup;
import com.agnither.race.ui.popups.VictoryPopup;
import com.agnither.race.ui.screens.area.AreaSelectScreen;
import com.agnither.race.ui.screens.level.LevelSelectScreen;
import com.agnither.race.ui.screens.menu.MenuScreen;
import com.agnither.race.ui.screens.shop.ClothTile;
import com.agnither.race.ui.screens.shop.CoinsTile;
import com.agnither.race.ui.screens.shop.HeroTile;
import com.agnither.race.ui.screens.shop.ShopScreen;
import com.agnither.race.view.MainScreen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.ResourcesManager;

import dragonBones.animation.WorldClock;

import flash.ui.Keyboard;

import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.KeyboardEvent;

public class GameController extends EventDispatcher {

    public static const UI_ACTION: String = "ui_action_GameController";
    public static const ONLINE_GAME: String = "online";
    public static const LOCAL_GAME: String = "local";
    public static const ABOUT: String = "about";
    public static const GAME_CENTER: String = "game_center";
    public static const BACK: String = "back";
    public static const SHOP: String = "shop";
    public static const MENU: String = "menu";
    public static const PAUSE: String = "pause";
    public static const REPLAY: String = "replay";
    public static const CONTINUE: String = "continue";
    public static const NEXT: String = "next";
    public static const SHOW_ENERGY: String = "show_energy";
    public static const BUY_ENERGY: String = "buy_energy";
    public static const BUY_MONEY: String = "buy_money";

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

    private var _services: Services;

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

        _services = Services.getServices();
        _services.init();
//        _services.addPurchaseListener(handleIAPSuccess, handleIAPCancel);
//        _services.getProducts(ShopVO.purchasesIds);

        _view = new MainScreen(_refs, this);
        _stage.addChildAt(_view, 0);

        _ui = new UI(_refs, this);
        _ui.addEventListener(PRESS, handlePress);
        _ui.addEventListener(RELEASE, handleRelease);
        _ui.addEventListener(AreaSelectScreen.SELECT_AREA, handleSelectArea);
        _ui.addEventListener(LevelSelectScreen.SELECT_LEVEL, handleSelectLevel);
        _ui.addEventListener(CoinsTile.BUY_COINS, handleBuyCoins);
        _ui.addEventListener(HeroTile.BUY_HERO, handleBuyPopup);
        _ui.addEventListener(ClothTile.BUY_CLOTH, handleBuyPopup);
        _ui.addEventListener(BuyPopup.BUY, handleBuy);
        _stage.addChildAt(_ui, 1);

        _stage.addEventListener(UI_ACTION, handleUIAction);

        showMenu();
    }

    private function showMenu():void {
        _ui.clearScreen();

        _ui.showScreen(MenuScreen.ID);
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
        if (!LevelVO.getLevel(level).area.opened) {
            showAreas();
            return;
        }

        if (_player.energy < 1) {
            showLevels();
            _ui.showPopup(RestorePopup.ID);
            return;
        }

        _currentLevel = level;

        _game.prepare(_currentLevel, _player.hero, _player.cloth);

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
        _stage.addEventListener("quit", handleQuit);

        pause(false);
    }

    private function end():void {
        _stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
        _stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        _stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
        _stage.removeEventListener("quit", handleQuit);

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

    private function handleQuit(e: Event):void {
        if (_game.isRunning) {
            pause(true);
        }
    }



    private function handleSelectArea(e: Event):void {
        var area: AreaVO = e.data as AreaVO;
        if (area.opened) {
            _currentArea = area.id;
            showLevels();
        } else if (area.unlockcost <= _player.money) {
            _player.unlockArea(area);
            _ui.showPopup(LocationUnlockedPopup.ID);
        } else {
            _ui.showPopup(NotEnoughPopup.ID);
        }
    }

    private function handleSelectLevel(e: Event):void {
        var level: LevelVO = e.data as LevelVO;
        if (level.opened) {
            start(level.id);
        }
    }

    private function handleBuyCoins(e: Event):void {
        var bank: BankVO = e.data as BankVO;
        // TODO: окно оплаты и подтверждение
        _player.addMoney(bank.amount);
    }

    private function handleBuyPopup(e: Event):void {
        _ui.showPopup(BuyPopup.ID, e.data);
    }

    private function handleBuy(e: Event):void {
        var hero: HeroVO = e.data as HeroVO;
        if (hero) {
            if (_player.hasHero(hero.id)) {
                _player.selectHero(hero.id);
            } else if (_player.money >= hero.unlockcost) {
                _player.unlockHero(hero);
                _player.selectHero(hero.id);
            } else {
                _ui.showPopup(NotEnoughPopup.ID);
            }
            return;
        }

        var cloth: ClothVO = e.data as ClothVO;
        if (cloth) {
            if (_player.hasCloth(cloth.id)) {
                _player.selectCloth(cloth.id);
            } else if (_player.money >= cloth.unlockcost) {
                _player.unlockCloth(cloth);
                _player.selectCloth(cloth.id);
            } else {
                _ui.showPopup(NotEnoughPopup.ID);
            }
            return;
        }
    }

    private function handleFinished(e: Event):void {
        if (_game.win) {
            var level: LevelVO = LevelVO.getLevel(_currentLevel);
            _player.addMoney(level.bonus);

            // TODO: replace ID
            _services.reportScore("railbrothers.money", _player.moneyObtained);

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

        WorldClock.clock.advanceTime(-1);
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
            case LOCAL_GAME:
                showAreas();
                break;
            case GAME_CENTER:
                // TODO: replace ID
                _services.showLeaderboard("railbrothers.money");
                break;
            case BACK:
                if (_ui.currentScreen is AreaSelectScreen) {
                    showMenu();
                } else {
                    showAreas();
                }
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
                start(_currentLevel+1);
                break;

            case SHOW_ENERGY:
                if (_player.energy==0) {
                    _ui.showPopup(RestorePopup.ID);
                }
                break;
            case BUY_ENERGY:
                if (_player.money >= 10000) {
                    _player.refillEnergy();
                }
                break;
            case BUY_MONEY:
                _ui.hideScreen();
                _ui.showScreen(ShopScreen.ID);
                break;
        }
    }
}
}
