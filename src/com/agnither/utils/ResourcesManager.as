/**
 * Created by agnither on 30.01.14.
 */
package com.agnither.utils {
import starling.events.EventDispatcher;
import starling.utils.AssetManager;

public class ResourcesManager extends EventDispatcher {

    public static const PROGRESS: String = "progress";
    public static const COMPLETE: String = "complete";

    private var _info: DeviceResInfo;

    private var _main: AssetManager;
    public function get main():AssetManager {
        return _main;
    }

    private var _gui: AssetManager;
    public function get gui():AssetManager {
        return _gui;
    }

    private var _game: AssetManager;
    public function get game():AssetManager {
        return _game;
    }

    public function ResourcesManager(info: DeviceResInfo) {
        _info = info;

        _main = new AssetManager(_info.scaleFactor);
        _gui = new AssetManager(_info.scaleFactor);
        _game = new AssetManager(_info.scaleFactor);
    }

    public function loadMain():void {
        _main.enqueue(
                "config/config.json"
        );
        _main.loadQueue(handleProgress);
    }

    public function loadGUI():void {
        for (var i:int = 0; i < Fonts.fonts.length; i++) {
            _gui.enqueue(
                    "textures/"+_info.font+"/fonts/"+Fonts.fonts[i]+".png",
                    "textures/"+_info.font+"/fonts/"+Fonts.fonts[i]+".xml"
            );
        }
        _gui.enqueue(
                "textures/"+_info.art+"/gui/gui.png",
                "textures/"+_info.art+"/gui/gui.xml"
        );
        _gui.loadQueue(handleProgress);
    }

    public function loadGame(location: String):void {
        _game.enqueue(
            "textures/"+_info.art+"/game/"+location+"/game.png",
            "textures/"+_info.art+"/game/"+location+"/game.xml"
        );
        _game.loadQueue(handleProgress);
    }
    public function clearGame():void {
        _game.purge();
        _game.dispose();
    }

    private function handleProgress(value: Number):void {
        dispatchEventWith(PROGRESS, false, value);

        if (value == 1) {
            dispatchEventWith(COMPLETE);
        }
    }
}
}
