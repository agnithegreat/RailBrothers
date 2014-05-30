/**
 * Created by agnither on 23.04.14.
 */
package com.agnither.race.ui.screens.menu {
import com.agnither.race.GameController;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;

public class MenuScreen extends Screen {

    public static const ID: String = "MenuScreen";

    private var _back: Image;

    private var _shop: Button;
    private var _local: Button;
    private var _online: Button;
    private var _about: Button;
    private var _gameCenter: Button;

    public function MenuScreen(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("menu_back.png"));
        addChild(_back);

        _shop = new Button(_refs.gui.getTexture("shop_button.png"));
        _shop.addEventListener(Event.TRIGGERED, handleClick);
        _shop.x = 21;
        _shop.y = 24;
        addChild(_shop);

        _local = new Button(_refs.gui.getTexture("local_game_button.png"));
        _local.addEventListener(Event.TRIGGERED, handleClick);
        _local.x = stage.stageWidth - 407;
        _local.y = 305;
        addChild(_local);

//        _online = new Button(_refs.gui.getTexture("online_game_button.png"));
//        _online.addEventListener(Event.TRIGGERED, handleClick);
//        _online.x = stage.stageWidth - 407;
//        _online.y = 352;
//        addChild(_online);

        _about = new Button(_refs.gui.getTexture("about.png"));
        _about.addEventListener(Event.TRIGGERED, handleClick);
        _about.x = stage.stageWidth - 201;
        _about.y = 483;
        addChild(_about);

        _gameCenter = new Button(_refs.gui.getTexture("game_center_button.png"));
        _gameCenter.addEventListener(Event.TRIGGERED, handleClick);
        _gameCenter.x = 17;
        _gameCenter.y = 530;
        addChild(_gameCenter);
    }

    private function handleClick(e: Event):void {
        switch (e.currentTarget) {
            case _shop:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.SHOP);
                break;
            case _local:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.LOCAL_GAME);
                break;
            case _online:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.ONLINE_GAME);
                break;
            case _about:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.ABOUT);
                break;
            case _gameCenter:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.GAME_CENTER);
                break;
        }
    }
}
}
