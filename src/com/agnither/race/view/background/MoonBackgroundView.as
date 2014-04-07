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

public class MoonBackgroundView extends BackgroundView {

    private var _back: TiledImage;

    private var _clouds: Sprite;
    private var _stars: Image;

    private var _earth: Image;
    private var _shuttle: Image;

    private var _moon: Sprite;

    public function MoonBackgroundView(refs:CommonRefs, game: Game) {
        super(refs, game);
    }

    override protected function initialize():void {
        _back = new TiledImage(_refs.game.getTexture("back.png"), 16);
        addChild(_back);

        super.initialize();

        _clouds = new Sprite();
        addChild(_clouds);

        addToContainer("cloud1.png", 6, 0, _clouds);
        addToContainer("cloud2.png", 759, 195, _clouds);
        addToContainer("cloud1.png", 1142, 0, _clouds);
        addToContainer("cloud2.png", 1895, 195, _clouds);

        _stars = new Image(_refs.game.getTexture("stars.png"));
        _stars.x = 8;
        addChild(_stars);

        _earth = new Image(_refs.game.getTexture("earth.png"));
        _earth.x = 996;
        _earth.y = 98;
        addChild(_earth);

        _shuttle = new Image(_refs.game.getTexture("shuttle.png"));
        _shuttle.x = 236;
        _shuttle.y = 167;
        addChild(_shuttle);

        _moon = new Sprite();
        _moon.y = 256;
        addChild(_moon);

        addToContainer("moon.png", 0, 0, _moon);
        addToContainer("moon.png", 1498, 0, _moon);
    }

    override protected function handleTick(e: Event):void {
        _clouds.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _moon.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _earth.x = 996-_game.player.position/_game.length*220;
        _shuttle.x = 236+_game.player.position/_game.length*100;
        _shuttle.y = 167-_game.player.position/_game.length*20;

        var first: Image = _clouds.getChildAt(0) as Image;
        var bounds: Rectangle = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 1136;
            _clouds.addChild(first);
        }

        first = _moon.getChildAt(0) as Image;
        bounds = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 1498;
            _moon.addChild(first);
        }
    }

    override public function destroy():void {
        _back.destroy();
        removeChild(_back);
        _back = null;

        while (_clouds.numChildren>0) {
            _clouds.removeChildAt(0, true);
        }
        removeChild(_clouds, true);
        _clouds = null;

        removeChild(_stars, true);
        _stars = null;

        removeChild(_earth, true);
        _earth = null;

        removeChild(_shuttle, true);
        _shuttle = null;

        super.destroy();
    }
}
}
