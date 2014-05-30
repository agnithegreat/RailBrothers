/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/23/13
 * Time: 11:17 PM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race {
import com.agnither.race.data.AreaVO;
import com.agnither.race.data.BankVO;
import com.agnither.race.data.ClothVO;
import com.agnither.race.data.HeroVO;
import com.agnither.race.data.LevelVO;
import com.agnither.race.view.Animations;
import com.agnither.utils.DeviceResInfo;
import com.agnither.utils.ResourcesManager;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

public class App extends Sprite {

    private var _resources: ResourcesManager;

    private var _controller: GameController;

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, start);
    }

    public function start(e: Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, start);

        var info: DeviceResInfo = DeviceResInfo.getInfo(Starling.current.nativeOverlay.stage);

        _resources = new ResourcesManager(info);
        _resources.addEventListener(ResourcesManager.COMPLETE, handleLoadMain);
        _resources.loadMain();

        _controller = new GameController(stage, _resources);
    }

    private function handleLoadMain():void {
        _resources.removeEventListener(ResourcesManager.COMPLETE, handleLoadMain);

        loadConfig();

        Animations.init(_resources.animations);

        _resources.addEventListener(ResourcesManager.COMPLETE, handleLoadGUI);
        _resources.loadGUI();
    }

    private function loadConfig():void {
        var config: Object = _resources.main.getObject("config");

        HeroVO.parseData(config.heroes);
        ClothVO.parseData(config.clothes);
        AreaVO.parseData(config.areas);
        LevelVO.parseData(config.levels);
        BankVO.parseData(config.bank);
//        SoundVO.parseData(config.sounds);
    }

    private function handleLoadGUI():void {
        _resources.removeEventListener(ResourcesManager.COMPLETE, handleLoadGUI);

        _resources.addEventListener(ResourcesManager.COMPLETE, handleInit);
        _resources.loadAnimations();
    }

    private function handleInit():void {
        _resources.removeEventListener(ResourcesManager.COMPLETE, handleInit);

        Animations.loadAnimation();

        _controller.init();
    }
}
}
