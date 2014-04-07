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

public class MountainBackgroundView extends BackgroundView {

    private var _back: TiledImage;

    private var _mountainBack: Sprite;
    private var _mountainFront: Sprite;

    private var _sand: TiledImage;
    private var _grass: Image;

    private var _clouds: Sprite;
    private var _spots: Sprite;

    override public function get rail():int {
        return 447;
    }

    public function MountainBackgroundView(refs:CommonRefs, game: Game) {
        super(refs, game);
    }

    override protected function initialize():void {
        _back = new TiledImage(_refs.game.getTexture("back.png"), 16);
        addChild(_back);

        _mountainBack = new Sprite();
        _mountainBack.y = 163;
        addChild(_mountainBack);

        _mountainFront = new Sprite();
        _mountainFront.y = 359;
        addChild(_mountainFront);

        _sand = new TiledImage(_refs.game.getTexture("sand.png"), 16);
        _sand.y = 462;
        addChild(_sand);

        _spots = new Sprite();
        addChild(_spots);

        _grass = new Image(_refs.game.getTexture("grass.png"));
        _grass.y = 498;
        addChild(_grass);

        _clouds = new Sprite();
        addChild(_clouds);

        super.initialize();

        addToContainer("mountain_back.png", 0, 0, _mountainBack);
        addToContainer("mountain_back.png", 1498, 0, _mountainBack);

        addToContainer("mountain_front.png", 0, 0, _mountainFront);
        addToContainer("mountain_front.png", 1498, 0, _mountainFront);

        addToContainer("cloud1.png", -34, 131, _clouds);
        addToContainer("cloud2.png", 568, 18, _clouds);
        addToContainer("cloud3.png", 1076, 102, _clouds);
        addToContainer("cloud1.png", 1102, 131, _clouds);
        addToContainer("cloud2.png", 1704, 18, _clouds);
        addToContainer("cloud3.png", 2212, 102, _clouds);

        addToContainer("spot1.png", 67, 478, _spots);
        addToContainer("spot2.png", 229, 482, _spots);
        addToContainer("spot3.png", 695, 488, _spots);
        addToContainer("spot4.png", 988, 478, _spots);
        addToContainer("spot1.png", 1203, 478, _spots);
        addToContainer("spot2.png", 1365, 482, _spots);
        addToContainer("spot3.png", 1831, 488, _spots);
        addToContainer("spot4.png", 2124, 478, _spots);
    }

    override protected function handleTick(e: Event):void {
        _container.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _mountainBack.pivotX = _game.player.position/_game.length * 7000;
        _mountainFront.pivotX = _game.player.position/_game.length * 10000;
        _spots.pivotX = _game.player.position;
        _clouds.pivotX += 0.3;

        var first: Image = _mountainBack.getChildAt(0) as Image;
        var bounds: Rectangle = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2996;
            _mountainBack.addChild(first);
        }

        first = _mountainFront.getChildAt(0) as Image;
        bounds = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2996;
            _mountainFront.addChild(first);
        }

        var spot: Image = _spots.getChildAt(0) as Image;
        bounds = spot.getBounds(stage);
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

        super.destroy();
    }
}
}
