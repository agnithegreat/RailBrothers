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
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class GameScreen extends Screen {

    public static const ID: String = "GameScreen";

    private var _game: Game;

    private var _panel: GamePanel;

    private var _buttonLeft: Button;
    private var _buttonRight: Button;

    private var _indication: IndicationView;

    private var _pauseBtn: Button;

    public function GameScreen(refs:CommonRefs, game: Game) {
        _game = game;
        super(refs);
    }

    override protected function initialize():void {
        _game.addEventListener(Game.TICK, handleTick);

        _panel = new GamePanel(_refs, _game);
        _panel.touchable = false;
        addChild(_panel);

        _buttonLeft = new Button(_refs.gui.getTexture("button_up.png"), "", _refs.gui.getTexture("button_down.png"));
        _buttonLeft.addEventListener(TouchEvent.TOUCH, handleTouch);
        _buttonLeft.x = 80;
        _buttonLeft.y = 500;
        addChild(_buttonLeft);

        _buttonRight = new Button(_refs.gui.getTexture("button_up.png"), "", _refs.gui.getTexture("button_down.png"));
        _buttonRight.addEventListener(TouchEvent.TOUCH, handleTouch);
        _buttonRight.x = 850;
        _buttonRight.y = 500;
        addChild(_buttonRight);

        _indication = new IndicationView(_refs);
        _indication.x = 369;
        _indication.y = 553;
        addChild(_indication);

        _pauseBtn = new Button(_refs.gui.getTexture("pause_btn.png"));
        _pauseBtn.addEventListener(Event.TRIGGERED, handlePause);
        _pauseBtn.pivotX = _pauseBtn.width/2;
        _pauseBtn.pivotY = _pauseBtn.height;
        _pauseBtn.x = stage.stageWidth/2;
        _pauseBtn.y = stage.stageHeight;
        _pauseBtn.scaleWhenDown = 1;
        addChild(_pauseBtn);
    }

    private function handleTick(e: Event):void {
        _indication.setBalance(_game.player.balance);
    }

    private function handlePause(e: Event):void {
        dispatchEventWith(GameController.UI_ACTION, true, GameController.PAUSE);
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
