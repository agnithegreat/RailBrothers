/**
 * Created by agnither on 04.04.14.
 */
package com.agnither.race.ui.common {
import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.textures.Texture;

public class TiledImage {

    public static function generateTiled(left: Texture, centre: Texture, right: Texture, width: int):Sprite {
        var tiled: Sprite = new Sprite();

        var qb: QuadBatch = new QuadBatch();
        tiled.addChild(qb);

        var l: Image = new Image(left);
        qb.addImage(l);

        var c: Image = new Image(centre);
        var amount: int = (width-left.width-right.width)/centre.width;
        for (var i:int = 0; i < amount; i++) {
            c.x = l.width + i * c.width;
            qb.addImage(c);
        }

        var r: Image = new Image(right);
        r.x = width - r.width;
        qb.addImage(r);

        return tiled;
    }

}
}
