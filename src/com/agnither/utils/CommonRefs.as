/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.06.13
 * Time: 10:26
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.utils {
import starling.utils.AssetManager;

public class CommonRefs {

    private var _resources: ResourcesManager;
    public function get resources():ResourcesManager {
        return _resources;
    }

    public function get gui():AssetManager {
        return _resources.gui;
    }

    public function get game():AssetManager {
        return _resources.game;
    }

    public function CommonRefs(resources: ResourcesManager) {
        _resources = resources;
    }
}
}
