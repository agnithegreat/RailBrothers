/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.ui {
import com.agnither.race.GameController;
import com.agnither.race.model.Game;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class GameScreen extends Screen {

    public static const ID: String = "GameScreen";

    private var _game: Game;

    private var _panel: GamePanel;

    private var _buttonLeft: Button;
    private var _buttonRight: Button;

    public function GameScreen(refs:CommonRefs, game: Game) {
        _game = game;
        super(refs);
    }

    override protected function initialize():void {
        _buttonLeft = new Button(_refs.gui.getTexture("button_up.png"), "", _refs.gui.getTexture("button_down.png"));
        _buttonLeft.addEventListener(TouchEvent.TOUCH, handleTouch);
        _buttonLeft.x = 80;
        _buttonLeft.y = 501;
        addChild(_buttonLeft);

        _buttonRight = new Button(_refs.gui.getTexture("button_up.png"), "", _refs.gui.getTexture("button_down.png"));
        _buttonRight.addEventListener(TouchEvent.TOUCH, handleTouch);
        _buttonRight.x = 849;
        _buttonRight.y = 501;
        addChild(_buttonRight);

        _panel = new GamePanel(_refs, _game);
        addChild(_panel);
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(e.currentTarget as DisplayObject);
        if (touch) {
            var event: String = touch.phase==TouchPhase.BEGAN ? GameController.PRESS : touch.phase==TouchPhase.ENDED ? GameController.RELEASE : null;
            if (event) {
                switch (e.currentTarget) {
                    case _buttonLeft:
                        dispatchEventWith(event, true, GameController.LEFT);
                        break;
                    case _buttonRight:
                        dispatchEventWith(event, true, GameController.RIGHT);
                        break;
                }
            }
        }
    }
}
}
