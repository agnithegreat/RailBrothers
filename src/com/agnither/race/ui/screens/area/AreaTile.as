/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.ui.screens.area {
import com.agnither.race.data.AreaVO;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import starling.display.Button;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;

public class AreaTile extends AbstractView {

    private var _area: AreaVO;
    public function get area():AreaVO {
        return _area;
    }

    private var _icon: Button;

    private var _lock: Button;
    private var _unlockCost: Sprite;
    private var _unlockCoins: Sprite;

    public function AreaTile(refs:CommonRefs, area: AreaVO) {
        _area = area;

        super(refs);
    }

    override protected function initialize():void {
        var texture: Texture = _refs.gui.getTexture(_area.name+"_button.png");
        if (texture) {
            _icon = new Button(texture);
            _icon.scaleWhenDown = 1;
            _icon.pivotX = 212;
            _icon.pivotY = 212;
            addChild(_icon);
        }

        if (!_area.opened) {
            _lock = new Button(_refs.gui.getTexture("button_lock.png"));
            _lock.scaleWhenDown = 1;
            _lock.pivotX = _lock.width/2;
            _lock.pivotY = _lock.height/2;
            _lock.scaleX = 1.22;
            _lock.scaleY = 1.22;
            addChild(_lock);

            _unlockCost = TextField.getBitmapFont("area_cost").createSprite(_lock.width, 70, FormatUtil.formatMoney(_area.unlockcost));
            _unlockCost.touchable = false;
            _unlockCost.pivotX = _lock.width/2;
            _unlockCost.y = 20;
            addChild(_unlockCost);

            _unlockCoins = TextField.getBitmapFont("area_coins").createSprite(_lock.width, 60, "COINS");
            _unlockCoins.touchable = false;
            _unlockCoins.pivotX = _lock.width/2;
            _unlockCoins.y = 70;
            addChild(_unlockCoins);
        }
    }

    override public function destroy():void {
        super.destroy();

        _area = null;

        if (_icon) {
            removeChild(_icon, true);
            _icon = null;
        }

        if (_lock) {
            removeChild(_lock, true);
            _lock = null;
        }

        if (_unlockCost) {
            removeChild(_unlockCost, true);
            _unlockCost = null;
        }

        if (_unlockCoins) {
            removeChild(_unlockCoins, true);
            _unlockCoins = null;
        }
    }
}
}
