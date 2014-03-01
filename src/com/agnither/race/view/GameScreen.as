/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view {
import com.agnither.race.GameController;
import com.agnither.race.model.Game;
import com.agnither.race.view.background.BackgroundView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import starling.events.Event;

public class GameScreen extends Screen {

    private var _controller: GameController;

    private var _background: BackgroundView;
    private var _rail: RailView;
    private var _trolley: TrolleyView;

    public function GameScreen(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        _controller.game.addEventListener(Game.TICK, handleTick);

        var BackClass: Class = BackgroundView.getBackground(_controller.game.location);
        _background = new BackClass(_refs, _controller.game);
        addChild(_background);

        _rail = new RailView(_refs);
        _rail.y = 428;
        addChild(_rail);

        _trolley = new TrolleyView(_refs, _controller.game.player);
        _trolley.x = 154;
        _trolley.y = 398;
        addChild(_trolley);
    }

    private function handleTick(e: Event):void {
        _rail.progress(_controller.game.player.position);
    }
}
}
