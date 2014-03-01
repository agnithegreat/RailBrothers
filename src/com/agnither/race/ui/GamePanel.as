/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.ui {
import com.agnither.race.model.Game;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class GamePanel extends AbstractView {

    private var _game: Game;

    private var _back: Image;

    private var _name1: Sprite;
    private var _name2: Sprite;

    private var _line1: Image;
    private var _line2: Image;

    private var _icon1: Image;
    private var _icon2: Image;

    private var _finish: Image;

    public function GamePanel(refs:CommonRefs, game: Game) {
        _game = game;
        super(refs);
    }

    override protected function initialize():void {
        _game.addEventListener(Game.TICK, handleTick);

        _back = new Image(_refs.gui.getTexture("top_panel.png"));
        _back.x = 17;
        _back.y = 10;
        addChild(_back);

        _line1 = new Image(_refs.gui.getTexture("line.png"));
        _line1.x = 210;
        _line1.y = 32;
        addChild(_line1);

        _line2 = new Image(_refs.gui.getTexture("line.png"));
        _line2.x = 210;
        _line2.y = 83;
        addChild(_line2);

        _finish = new Image(_refs.gui.getTexture("finish.png"));
        _finish.x = 1078;
        _finish.y = 15;
        addChild(_finish);

        _icon1 = new Image(_refs.gui.getTexture("circle.png"));
        _icon1.pivotX = _icon1.width/2;
        _icon1.pivotY = _icon1.height/2;
        _icon1.x = 210;
        _icon1.y = 35;
        addChild(_icon1);

        _icon2 = new Image(_refs.gui.getTexture("circle.png"));
        _icon2.pivotX = _icon2.width/2;
        _icon2.pivotY = _icon2.height/2;
        _icon2.x = 210;
        _icon2.y = 86;
        addChild(_icon2);

        _name1 = TextField.getBitmapFont("name").createSprite(150, 30, "mr_cat");
        _name1.x = 20;
        _name1.y = 21;
        addChild(_name1);

        _name2 = TextField.getBitmapFont("name").createSprite(150, 30, "girl_1999");
        _name2.x = 20;
        _name2.y = 72;
        addChild(_name2);
    }

    private function handleTick(e: Event):void {
        _icon1.x = 210 + _game.playerProgress * _line1.width;
        _icon2.x = 210 + _game.enemyProgress * _line2.width;
    }
}
}
