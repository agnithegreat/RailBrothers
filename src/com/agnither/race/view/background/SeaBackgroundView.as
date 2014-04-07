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

public class SeaBackgroundView extends BackgroundView {

    private var _back: TiledImage;

    private var _sea: TiledImage;
    private var _sand: TiledImage;

    private var _clouds: Sprite;
    private var _spots: Sprite;

    private var _ship: Image;

    public function SeaBackgroundView(refs:CommonRefs, game: Game) {
        super(refs, game);
    }

    override protected function initialize():void {
        _back = new TiledImage(_refs.game.getTexture("back.png"), 16);
        addChild(_back);

        _sea = new TiledImage(_refs.game.getTexture("sea.png"), 16);
        _sea.y = 304;
        addChild(_sea);

        _sand = new TiledImage(_refs.game.getTexture("sand.png"), 16);
        _sand.y = 377;
        addChild(_sand);

        _clouds = new Sprite();
        addChild(_clouds);

        _spots = new Sprite();
        addChild(_spots);

        super.initialize();

        addToContainer("wave1.png", 62, 326, _container);
        addToContainer("wave2.png", 368, 342, _container);
        addToContainer("wave3.png", 590, 319, _container);
        addToContainer("wave4.png", 891, 341, _container);
        addToContainer("wave5.png", 1271, 345, _container);
        addToContainer("wave6.png", 1705, 335, _container);
        addToContainer("wave7.png", 2047, 332, _container);

        addToContainer("cloud1.png", 0, 239, _clouds);
        addToContainer("cloud2.png", 163, 113, _clouds);
        addToContainer("cloud3.png", 782, 97, _clouds);
        addToContainer("cloud4.png", 1076, 139, _clouds);
        addToContainer("cloud1.png", 1136, 239, _clouds);
        addToContainer("cloud2.png", 1299, 113, _clouds);
        addToContainer("cloud3.png", 1918, 97, _clouds);
        addToContainer("cloud4.png", 2212, 139, _clouds);

        addToContainer("spot1.png", 38, 485, _spots);
        addToContainer("spot2.png", 350, 504, _spots);
        addToContainer("spot3.png", 568, 477, _spots);
        addToContainer("spot4.png", 952, 484, _spots);
        addToContainer("spot5.png", 1393, 490, _spots);
        addToContainer("spot6.png", 1783, 484, _spots);
        addToContainer("spot7.png", 2164, 496, _spots);

        _ship = new Image(_refs.game.getTexture("ship.png"));
        _ship.x = 996;
        _ship.y = 258;
        addChild(_ship);
    }

    override protected function handleTick(e: Event):void {
        _container.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _spots.pivotX = _game.player.position;
        _clouds.pivotX += 0.3;
        _ship.x = 996-_game.player.position/_game.length*495;

        var spot: Image = _spots.getChildAt(0) as Image;
        var bounds: Rectangle = spot.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            spot.x += stage.stageWidth * 2;
            _spots.addChild(spot);
        }

        var cloud: Image = _clouds.getChildAt(0) as Image;
        bounds = cloud.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            cloud.x += stage.stageWidth * 2;
            _clouds.addChild(cloud);
        }
    }

    override public function destroy():void {
        _back.destroy();
        removeChild(_back);
        _back = null;

        _sea.destroy();
        removeChild(_sea);
        _sea = null;

        _sand.destroy();
        removeChild(_sand);
        _sand = null;

        while (_clouds.numChildren>0) {
            _clouds.removeChildAt(0, true);
        }
        removeChild(_clouds, true);
        _clouds = null;

        while (_spots.numChildren>0) {
            _spots.removeChildAt(0, true);
        }
        removeChild(_spots, true);
        _spots = null;

        removeChild(_ship, true);
        _ship = null;

        super.destroy();
    }
}
}
