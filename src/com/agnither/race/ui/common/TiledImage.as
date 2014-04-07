/**
 * Created by agnither on 04.04.14.
 */
package com.agnither.race.ui.common {
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class TiledImage {

    public static function generateTiled(left: Texture, centre: Texture, right: Texture, width: int):Sprite {
        var tiled: Sprite = new Sprite();

        var l: Image = new Image(left);
        tiled.addChild(l);

        var amount: int = (width-left.width-right.width)/centre.width;
        for (var i:int = 0; i < amount; i++) {
            var c: Image = new Image(centre);
            c.x = l.width + i * c.width;
            tiled.addChild(c);
        }

        var r: Image = new Image(right);
        r.x = width - r.width;
        tiled.addChild(r);

        return tiled;
    }

}
}
