/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.ui.screens.level {
import com.agnither.race.data.LevelVO;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.textures.Texture;

public class LevelTile extends AbstractView {

    private var _level: LevelVO;
    public function get level():LevelVO {
        return _level;
    }

    private var _icon: Button;

    private var _lock: Button;

    public function LevelTile(refs:CommonRefs, level: LevelVO) {
        _level = level;

        super(refs);
    }

    override protected function initialize():void {
        var texture: Texture = _refs.gui.getTexture(_level.area.name+"_button.png");
        if (texture) {
            _icon = new Button(texture);
            _icon.scaleWhenDown = 1;
            _icon.pivotX = 212;
            _icon.pivotY = 212;
            addChild(_icon);
        }

        if (!_level.opened) {
            _lock = new Button(_refs.gui.getTexture("button_lock.png"));
            _lock.scaleWhenDown = 1;
            _lock.pivotX = _lock.width/2;
            _lock.pivotY = _lock.height/2;
            _lock.scaleX = 1.22;
            _lock.scaleY = 1.22;
            addChild(_lock);
        }
    }

    override public function destroy():void {
        super.destroy();

        _level = null;

        if (_icon) {
            removeChild(_icon, true);
            _icon = null;
        }

        if (_lock) {
            removeChild(_lock, true);
            _lock = null;
        }
    }
}
}
