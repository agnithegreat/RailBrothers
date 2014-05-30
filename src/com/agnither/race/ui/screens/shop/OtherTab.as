/**
 * Created by agnither on 08.04.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.ui.common.TiledImage;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

public class OtherTab extends AbstractView {

    private var _title: TextField;

    private var _adsOff: Sprite;
    private var _adsOffText: TextField;
    private var _money: TextField;

    public function OtherTab(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _title = new TextField(500, 60, "BUY ENERGY", "shop_text", -1, 0xFFFFFF);
        _title.x = 250;
        _title.y = 27;
        addChild(_title);

        var sep: Image = new Image(_refs.gui.getTexture("separator.png"));
        sep.x = 39;
        sep.y = 166;
        sep.width = 932;
        addChild(sep);

        var tile1: EnergyTile = new EnergyTile(_refs, {title: "8 GAMES", price: 10000});
        tile1.x = 38;
        tile1.y = 99;
        addChild(tile1);

        var tile2: EnergyTile = new EnergyTile(_refs, {title: "ALL TIME", price: 500000});
        tile2.x = 38;
        tile2.y = 183;
        addChild(tile2);

        _adsOff = TiledImage.generateTiled(_refs.gui.getTexture("money_back_left.png"), _refs.gui.getTexture("money_back_centre.png"), _refs.gui.getTexture("money_back_right.png"), 934);
        _adsOff.x = 38;
        _adsOff.y = 319;
        addChild(_adsOff);

        _adsOffText = new TextField(140, 56, "$ 0.99", "money", -1, 0xFFFFFF);
        _adsOffText.x = 815;
        _adsOffText.y = 325;
        addChild(_adsOffText);

        _money = new TextField(400, 48, "DISABLE ADVERTISING", "shop_text", -1, 0xFFFFFF);
        _money.hAlign = "left";
        _money.x = 64;
        _money.y = 329;
        addChild(_money);
    }
}
}
