/**
 * Created by agnither on 29.01.14.
 */
package com.agnither.utils {
import flash.display.Stage;

public class DeviceResInfo {

    public static function getInfo(stage: Stage):DeviceResInfo {
        var info: DeviceResInfo = new DeviceResInfo();
        if (stage.stageWidth > 800) {
            info.art = 1136;
            info.scaleFactor = 1;
            info.font = 1136;
        } else {
            info.art = 1136;
            info.scaleFactor = 0.5;
            info.font = 1136;
        }
        return info;
    }

    public var art: int = 1136;
    public var scaleFactor: Number = 1;
    public var font: int = 1136;
    public var frameRate: int = 60;
}
}
