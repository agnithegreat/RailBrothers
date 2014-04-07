/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view {
import com.agnither.race.GameController;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class MainScreen extends Screen {

    private var _controller: GameController;

    private var _gameScreen: GameScreen;

    public function MainScreen(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    public function showGame():void {
        _gameScreen = new GameScreen(_refs, _controller);
        _gameScreen.touchable = false;
        addChild(_gameScreen);
    }

    public function destroyGame():void {
        if (_gameScreen) {
            _gameScreen.destroy();
            removeChild(_gameScreen, true);
            _gameScreen = null;
        }
    }
}
}
