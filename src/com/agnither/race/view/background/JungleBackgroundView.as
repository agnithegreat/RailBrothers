/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view.background {
import com.agnither.race.model.Game;
import com.agnither.ui.TiledImage;
import com.agnither.utils.CommonRefs;

import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class JungleBackgroundView extends BackgroundView {

    private var _back: TiledImage;

    private var _sun: Image;

    private var _clouds: Sprite;

    private var _second: Sprite;
    private var _front: Sprite;

    public function JungleBackgroundView(refs:CommonRefs, game: Game) {
        super(refs, game);
    }

    override protected function initialize():void {
        _back = new TiledImage(_refs.game.getTexture("back.png"), 16);
        addChild(_back);

        _sun = new Image(_refs.game.getTexture("sun.png"));
        _sun.x = 702;
        _sun.y = 20;
        addChild(_sun);

        _clouds = new Sprite();
        addChild(_clouds);

        super.initialize();

        addToContainer("cloud1.png", 59, 84, _clouds);
        addToContainer("cloud2.png", 493, 76, _clouds);
        addToContainer("cloud3.png", 973, 156, _clouds);
        addToContainer("cloud1.png", 1205, 84, _clouds);
        addToContainer("cloud2.png", 1629, 76, _clouds);
        addToContainer("cloud3.png", 2109, 156, _clouds);

        _second = new Sprite();
        addChild(_second);

        addToContainer("second.png", 0, 182, _second);
        addToContainer("second.png", 1497, 182, _second);

        _front = new Sprite();
        addChild(_front);

        addToContainer("front.png", 0, 168, _front);
        addToContainer("front.png", 1497, 168, _front);
    }

    override protected function handleTick(e: Event):void {
        _container.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _sun.x = 702-_game.player.position/_game.length*220;

        _clouds.pivotX += 0.3;
        _second.pivotX = _game.player.position/3;
        _front.pivotX = _game.player.position/2;

        var first: Image = _clouds.getChildAt(0) as Image;
        var bounds: Rectangle = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2994;
            _clouds.addChild(first);
        }

        first = _second.getChildAt(0) as Image;
        bounds = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2994;
            _second.addChild(first);
        }

        first = _front.getChildAt(0) as Image;
        bounds = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2994;
            _front.addChild(first);
        }
    }

    override public function destroy():void {
        _back.destroy();
        removeChild(_back);
        _back = null;

        removeChild(_sun, true);
        _sun = null;

        while (_clouds.numChildren>0) {
            _clouds.removeChildAt(0, true);
        }
        removeChild(_clouds, true);
        _clouds = null;

        while (_second.numChildren>0) {
            _second.removeChildAt(0, true);
        }
        removeChild(_second, true);
        _second = null;

        while (_front.numChildren>0) {
            _front.removeChildAt(0, true);
        }
        removeChild(_front, true);
        _front = null;

        super.destroy();
    }
}
}
