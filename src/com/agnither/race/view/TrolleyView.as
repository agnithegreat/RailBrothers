/**
 * Created by agnither on 27.02.14.
 */
package com.agnither.race.view {
import com.agnither.race.data.ClothVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.model.Player;
import com.agnither.race.model.Trolley;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

public class TrolleyView extends AbstractView {

    private var _trolley: Trolley;

    private var _player: Player;

    private var _animation: Armature;

    private var _base: Image;
    private var _wheel1: Image;
    private var _wheel2: Image;

    public function TrolleyView(refs: CommonRefs, trolley: Trolley, player: Player) {
        _trolley = trolley;
        _player = player;

        super(refs);
    }

    override protected function initialize():void {
        _trolley.addEventListener(Trolley.UPDATE, handleUpdate);
        _trolley.addEventListener(Trolley.WIN, handleWin);
        _trolley.addEventListener(Trolley.LOSE, handleLose);

        _animation = Animations.buildArmature("HERO"+ _trolley.hero.skin +"/ANIMATION", "animations", "animations", "animations");
        _animation.display.y = -81;
        addChild(_animation.display as Sprite);
        WorldClock.clock.add(_animation);

        var hero: HeroVO = HeroVO.getHero(_player.hero);
        var cloth: ClothVO = ClothVO.getCloth(_player.cloth);
        var slots: Array = [hero.hat, hero.moustache, hero.jacket, cloth ? cloth.name : "default"];
        var bones: Vector.<Bone> = _animation.getBones();
        for (var i:int = 0; i < bones.length; i++) {
            if (bones[i].childArmature) {
                for (var j:int = 0; j < slots.length; j++) {
                    var tag: String = slots[j];
                    if (bones[i].childArmature.animation.hasAnimation(tag)) {
                        bones[i].childArmature.animation.gotoAndPlay(tag);
                    }
                }
            }
        }

        _base = new Image(_refs.gui.getTexture("trolley.png"));
        _base.pivotX = _base.width/2;
        _base.pivotY = 90;
        addChild(_base);

        _wheel1 = new Image(_refs.gui.getTexture("wheel.png"));
        _wheel1.pivotX = _wheel1.width/2;
        _wheel1.pivotY = _wheel1.height/2;
        _wheel1.x = -60;
        addChild(_wheel1);

        _wheel2 = new Image(_refs.gui.getTexture("wheel.png"));
        _wheel2.pivotX = _wheel2.width/2;
        _wheel2.pivotY = _wheel2.height/2;
        _wheel2.x = 60;
        addChild(_wheel2);
    }

    private function handleUpdate(e: Event):void {
        _wheel1.rotation = _trolley.position * Math.PI * 50 / 10000;
        _wheel2.rotation = _trolley.position * Math.PI * 50 / 10000;

        if (!_trolley.end) {
            var balanceFrame:int = Math.round(_trolley.balance * 8);
            var frameLabel:String = balanceFrame < 0 ? "sl" + (-balanceFrame) : (balanceFrame > 0 ? "sr" + balanceFrame : "sc0");
            _animation.animation.gotoAndPlay(frameLabel, 0.3);
        }
    }

    private function handleWin(e: Event):void {
        _animation.animation.gotoAndPlay("win");
    }

    private function handleLose(e: Event):void {
        _animation.animation.gotoAndPlay("lose");
    }

    override public function destroy():void {
        _trolley.removeEventListener(Trolley.UPDATE, handleUpdate);
        _trolley.removeEventListener(Trolley.WIN, handleWin);
        _trolley.removeEventListener(Trolley.LOSE, handleLose);
        _trolley = null;

        removeChild(_animation.display as Sprite);
        WorldClock.clock.remove(_animation);
        _animation.dispose();
        _animation = null;

        removeChild(_base, true);
        _base = null;

        removeChild(_wheel1, true);
        _wheel1 = null;

        removeChild(_wheel2, true);
        _wheel2 = null;

        super.destroy();
    }
}
}
