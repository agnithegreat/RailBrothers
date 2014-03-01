/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view.background {
import com.agnither.race.model.Game;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class BackgroundView extends AbstractView {

    public static const SEA: String = "sea";
    public static const DESERT: String = "desert";

    public static function getBackground(location: String):Class {
        switch (location) {
            case SEA:
                return SeaBackgroundView;
            case DESERT:
                return DesertBackgroundView;
        }
        return null;
    }

    protected var _game: Game;

    protected var _container: Sprite;

    public function BackgroundView(refs:CommonRefs, game: Game) {
        _game = game;

        super(refs);
    }

    override protected function initialize():void {
        _game.addEventListener(Game.TICK, handleTick);

        _container = new Sprite();
        addChild(_container);
    }

    protected function addToContainer(name: String, x: int, y: int, container: Sprite):void {
        var image: Image = new Image(_refs.game.getTexture(name));
        image.x = x;
        image.y = y;
        container.addChild(image);
    }

    protected function handleTick(e: Event):void {

    }
}
}
