/**
 * Created by agnither on 08.04.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.data.BankVO;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;

public class CoinsTab extends AbstractView {

    public function CoinsTab(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        var sep: Image = new Image(_refs.gui.getTexture("separator.png"));
        sep.x = 39;
        sep.y = 88;
        sep.width = 932;
        addChild(sep);

        sep = new Image(_refs.gui.getTexture("separator.png"));
        sep.x = 39;
        sep.y = 158;
        sep.width = 932;
        addChild(sep);

        sep = new Image(_refs.gui.getTexture("separator.png"));
        sep.x = 39;
        sep.y = 228;
        sep.width = 932;
        addChild(sep);

        sep = new Image(_refs.gui.getTexture("separator.png"));
        sep.x = 39;
        sep.y = 298;
        sep.width = 932;
        addChild(sep);

        sep = new Image(_refs.gui.getTexture("separator.png"));
        sep.x = 39;
        sep.y = 368;
        sep.width = 932;
        addChild(sep);

        for (var i:int = 0; i < 6; i++) {
            var tile: CoinsTile = new CoinsTile(_refs, BankVO.BANK[i]);
            tile.x = 39;
            tile.y = 24 + i * 70;
            addChild(tile);
        }
    }
}
}
