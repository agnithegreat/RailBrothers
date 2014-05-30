/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.ui {
import com.agnither.race.GameController;
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
import com.agnither.race.ui.screens.shop.ShopScreen;
import com.agnither.ui.Popup;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import flash.utils.Dictionary;

import starling.display.Quad;
import starling.events.Event;

public class UI extends Screen {

    public static var SCREENS: Dictionary = new Dictionary();
    public static var POPUPS: Dictionary = new Dictionary();

    private var _controller: GameController;

    private var _currentScreen: Screen;
    public function get currentScreen():Screen {
        return _currentScreen;
    }

    private var _currentPopup: Popup;

    private var _darkness: Quad;

    public function UI(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        SCREENS[MenuScreen.ID] = new MenuScreen(_refs);
        SCREENS[AreaSelectScreen.ID] = new AreaSelectScreen(_refs, _controller);
        SCREENS[LevelSelectScreen.ID] = new LevelSelectScreen(_refs, _controller);
        SCREENS[ShopScreen.ID] = new ShopScreen(_refs, _controller);
        SCREENS[GameScreen.ID] = new GameScreen(_refs, _controller.game);

        POPUPS[PausePopup.ID] = new PausePopup(_refs);
        POPUPS[DefeatPopup.ID] = new DefeatPopup(_refs);
        POPUPS[VictoryPopup.ID] = new VictoryPopup(_refs);
        POPUPS[RestorePopup.ID] = new RestorePopup(_refs);
        POPUPS[NotEnoughPopup.ID] = new NotEnoughPopup(_refs);
        POPUPS[LocationUnlockedPopup.ID] = new LocationUnlockedPopup(_refs);
        POPUPS[BuyPopup.ID] = new BuyPopup(_refs, _controller.player);

        _darkness = new Quad(stage.stageWidth, stage.stageHeight, 0, false);
        _darkness.alpha = 0.5;
    }

    public function showScreen(id: String):void {
        if (_currentScreen == SCREENS[id]) {
            return;
        }

        _currentScreen = SCREENS[id];
        if (_currentScreen) {
            addChild(_currentScreen);
        }
    }
    public function hideScreen():void {
        if (_currentScreen) {
            _currentScreen.close();
            _currentScreen = null;
        }
    }

    public function showPopup(id: String, data: Object = null):void {
        if (_currentPopup == POPUPS[id]) {
            return;
        }

        hidePopup();

        _currentPopup = POPUPS[id];
        if (_currentPopup) {
            _currentPopup.data = data;
            if (_currentPopup.darkened) {
                addChild(_darkness);
            }
            _currentPopup.addEventListener(Popup.CLOSE, hidePopup);
            addChild(_currentPopup);
        }
    }
    public function hidePopup(e: Event = null):void {
        if (_currentPopup) {
            if (_currentPopup.darkened) {
                removeChild(_darkness);
            }
            _currentPopup.removeEventListener(Popup.CLOSE, hidePopup);
            _currentPopup.close();
            _currentPopup = null;
        }
    }

    public function clearScreen():void {
        hideScreen();
        hidePopup();
    }

    override public function destroy():void {
        super.destroy();

        _controller = null;

        hideScreen();

        for (var index: String in SCREENS) {
            var s: Screen = SCREENS[index]
            s.destroy();
            s.removeFromParent(true);
            delete SCREENS[index];
        }
    }
}
}
