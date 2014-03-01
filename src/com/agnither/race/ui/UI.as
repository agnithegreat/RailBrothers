/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.ui {
import com.agnither.race.GameController;
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
    private var _currentPopup: Popup;

    private var _darkness: Quad;

    public function UI(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        SCREENS[GameScreen.ID] = new GameScreen(_refs, _controller.game);

        _darkness = new Quad(stage.stageWidth, stage.stageHeight, 0);
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
    private function hideScreen():void {
        if (_currentScreen) {
            removeChild(_currentScreen);
            _currentScreen = null;
        }
    }

    public function showPopup(id: String):void {
        if (_currentPopup == POPUPS[id]) {
            return;
        }

        hidePopup();

        _currentPopup = POPUPS[id];
        if (_currentPopup) {
            if (_currentPopup.darkened) {
                addChildAt(_darkness, 0);
            }
            _currentPopup.addEventListener(Popup.CLOSE, hidePopup);
            addChild(_currentPopup);
        }
    }
    private function hidePopup(e: Event = null):void {
        if (_currentPopup) {
            if (_currentPopup.darkened) {
                removeChild(_darkness);
            }
            _currentPopup.removeEventListener(Popup.CLOSE, hidePopup);
            removeChild(_currentPopup);
            _currentPopup = null;
        }
    }

    private function handleShowScreen(e: Event):void {
        showScreen(e.data as String);
    }

    private function handleShowPopup(e: Event):void {
        showPopup(e.data as String);
    }

    private function handleClearScreen(e: Event):void {
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
