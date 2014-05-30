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

public class ForestBackgroundView extends BackgroundView {

    private var _back: TiledImage;

    private var _sun: Image;

    private var _clouds: Sprite;

    private var _grass: Sprite;
    private var _trees: Sprite;

    public function ForestBackgroundView(refs:CommonRefs, game: Game) {
        super(refs, game);
    }

    override protected function initialize():void {
        _back = new TiledImage(_refs.game.getTexture("sky.png"), 16);
        addChild(_back);

        _sun = new Image(_refs.game.getTexture("sun.png"));
        _sun.x = 826;
        _sun.y = 47;
        addChild(_sun);

        _clouds = new Sprite();
        addChild(_clouds);

        super.initialize();

        addToContainer("cloud1.png", -17, 124, _clouds);
        addToContainer("cloud2.png", 593, 11, _clouds);
        addToContainer("cloud3.png", 1101, 95, _clouds);
        addToContainer("cloud1.png", 1119, 124, _clouds);
        addToContainer("cloud2.png", 1729, 11, _clouds);
        addToContainer("cloud3.png", 2237, 95, _clouds);

        _grass = new Sprite();
        addChild(_grass);

        addToContainer("grass.png", 0, 246, _grass);
        addToContainer("grass.png", 1498, 246, _grass);

        _trees = new Sprite();
        addChild(_trees);

        addToContainer("trees.png", 0, 148, _trees);
        addToContainer("trees.png", 1500, 148, _trees);
    }

    override protected function handleTick(e: Event):void {
        _container.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _sun.x = 826-_game.player.position/_game.length*220;

        _clouds.pivotX += 0.3;
        _grass.pivotX = _game.player.position/3;
        _trees.pivotX = _game.player.position/2;

        var first: Image = _clouds.getChildAt(0) as Image;
        var bounds: Rectangle = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2996;
            _clouds.addChild(first);
        }

        first = _grass.getChildAt(0) as Image;
        bounds = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2996;
            _grass.addChild(first);
        }

        first = _trees.getChildAt(0) as Image;
        bounds = first.getBounds(stage);
        if (bounds.x + bounds.width <= 0) {
            first.x += 2996;
            _trees.addChild(first);
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

        while (_grass.numChildren>0) {
            _grass.removeChildAt(0, true);
        }
        removeChild(_grass, true);
        _grass = null;

        while (_trees.numChildren>0) {
            _trees.removeChildAt(0, true);
        }
        removeChild(_trees, true);
        _trees = null;

        super.destroy();
    }
}
}
