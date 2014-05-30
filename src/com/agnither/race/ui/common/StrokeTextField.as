/**
 * Created by agnither on 15.04.14.
 */
package com.agnither.race.ui.common {
import starling.display.Sprite;
import starling.text.TextField;

public class StrokeTextField extends Sprite {

    private var _stroke: TextField;
    private var _text: TextField;

    public function set text(value: String):void {
        _stroke.text = value;
        _text.text = value;
    }

    public function StrokeTextField(width: int, height: int, text: String, scale: Number = 1) {
        _stroke = new TextField(width/scale, height/scale, text, "area_name_stroke", -1, 0xFFFFFF);
        addChild(_stroke);

        _text = new TextField(width/scale, height/scale, text, "area_name", -1, 0xFFFFFF);
        _text.x = 7;
        _text.y = -7;
        addChild(_text);

        scaleX = scale;
        scaleY = scale;
        touchable = false;
    }
}
}
