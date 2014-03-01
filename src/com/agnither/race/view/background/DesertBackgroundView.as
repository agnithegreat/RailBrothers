/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view.background {
import com.agnither.race.model.Game;
import com.agnither.ui.TiledImage;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;

public class DesertBackgroundView extends BackgroundView {

    private var _back: TiledImage;

    private var _sand1: Image;
    private var _sand2: Image;
    private var _sandBottom: TiledImage;
    private var _sandTop: TiledImage;

    private var _bone: Image;

    private var _sun: Image;

    public function DesertBackgroundView(refs:CommonRefs, game: Game) {
        super(refs, game);
    }

    override protected function initialize():void {
        _back = new TiledImage(_refs.game.getTexture("back.png"), 16);
        addChild(_back);

        super.initialize();

        _sand1 = new Image(_refs.game.getTexture("sand1.png"));
        _sand1.pivotY = _sand1.height;
        _sand1.y = 360;
        _container.addChild(_sand1);

        _sand2 = new Image(_refs.game.getTexture("sand2.png"));
        _sand2.pivotY = _sand2.height;
        _sand2.x = stage.stageWidth;
        _sand2.y = 360;
        _container.addChild(_sand2);

        _sandBottom = new TiledImage(_refs.game.getTexture("sand_bottom.png"), 32);
        _sandBottom.pivotY = _sandBottom.height;
        _sandBottom.y = stage.stageHeight;
        _container.addChild(_sandBottom);

        _sandTop = new TiledImage(_refs.game.getTexture("sand_top.png"), 16);
        _sandTop.pivotY = _sandTop.height;
        _sandTop.y = stage.stageHeight;
        addChild(_sandTop);

        _bone = new Image(_refs.game.getTexture("bone.png"));
        _bone.x = 356;
        _bone.y = 558;
        addChild(_bone);

        addToContainer("cactus1.png", 88, 333, _container);
        addToContainer("mountain1.png", 160, 254, _container);
        addToContainer("mountain2.png", 581, 306, _container);
        addToContainer("mountain3.png", 896, 318, _container);
        addToContainer("cactus2.png", 1117, 338, _container);
        addToContainer("mountain4.png", 1223, 307, _container);
        addToContainer("mountain5.png", 1722, 270, _container);

        _sun = new Image(_refs.game.getTexture("sun.png"));
        _sun.x = 889;
        _sun.y = 3;
        addChild(_sun);
    }

    override protected function handleTick(e: Event):void {
        _container.pivotX = _game.player.position/_game.length * stage.stageWidth/2;
        _sun.x = 889-_game.player.position/_game.length*440;
    }
}
}
