/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.ui.screens.shop {
import com.agnither.race.GameController;
import com.agnither.race.model.Player;
import com.agnither.race.ui.common.EnergyDisplayView;
import com.agnither.race.ui.common.StrokeTextField;
import com.agnither.race.ui.common.TiledImage;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;
import com.agnither.utils.FormatUtil;

import flash.geom.Rectangle;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;

public class ShopScreen extends Screen {

    public static const ID: String = "ShopScreen";

    private var _controller: GameController;

    private var _back: Image;

    private var _backBtn: Button;

    private var _energy: EnergyDisplayView;

    private var _coinsBack: Sprite;
    private var _coin: Image;
    private var _coins: TextField;

    private var _shop: Sprite;
    private var _popupBack: Image;
    private var _tab1: Button;
    private var _tab2: Button;
    private var _tab3: Button;
    private var _tab4: Button;

    private var _container: Sprite;
    private var _coinsTab: CoinsTab;
    private var _heroesTab: HeroesTab;
    private var _clothesTab: ClothesTab;
    private var _otherTab: OtherTab;

    private var _title: StrokeTextField;

    private var _tab1Label: TextField;
    private var _tab2Label: TextField;
    private var _tab3Label: TextField;
    private var _tab4Label: TextField;

    public function ShopScreen(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.gui.getTexture("wood_back.png"));
        addChild(_back);

        _energy = new EnergyDisplayView(_refs, _controller.player);
        addChild(_energy);

        _coinsBack = TiledImage.generateTiled(_refs.gui.getTexture("money_back_left.png"), _refs.gui.getTexture("money_back_centre.png"), _refs.gui.getTexture("money_back_right.png"), 267);
        _coinsBack.x = stage.stageWidth-429;
        _coinsBack.y = 20;
        addChild(_coinsBack);

        _coin = new Image(_refs.gui.getTexture("coin.png"));
        _coin.x = 6;
        _coin.y = 6;
        _coinsBack.addChild(_coin);

        _backBtn = new Button(_refs.gui.getTexture("back_button.png"));
        _backBtn.addEventListener(Event.TRIGGERED, handleClick);
        _backBtn.x = 16;
        _backBtn.y = 16;
        addChild(_backBtn);

        _shop = new Sprite();
        _shop.y = 116;
        addChild(_shop);

        _popupBack = new Image(_refs.gui.getTexture("shop_back.png"));
        _popupBack.y = 60;
        _shop.addChild(_popupBack);

        _tab1 = new Button(_refs.gui.getTexture("tab1.png"));
        _tab1.scaleWhenDown = 1;
        _tab1.addEventListener(Event.TRIGGERED, handleTab);
        _shop.addChild(_tab1);

        _tab2 = new Button(_refs.gui.getTexture("tab2.png"));
        _tab2.scaleWhenDown = 1;
        _tab2.addEventListener(Event.TRIGGERED, handleTab);
        _tab2.x = 190;
        _shop.addChild(_tab2);

        _tab3 = new Button(_refs.gui.getTexture("tab3.png"));
        _tab3.scaleWhenDown = 1;
        _tab3.addEventListener(Event.TRIGGERED, handleTab);
        _tab3.x = 380;
        _shop.addChild(_tab3);

        _tab4 = new Button(_refs.gui.getTexture("tab4.png"));
        _tab4.scaleWhenDown = 1;
        _tab4.addEventListener(Event.TRIGGERED, handleTab);
        _tab4.x = 570;
        _shop.addChild(_tab4);

        _container = new Sprite();
        _container.y = 60;
        _container.clipRect = new Rectangle(5, 5, 990, 430);
        _shop.addChild(_container);

        _coinsTab = new CoinsTab(_refs);
        _heroesTab = new HeroesTab(_refs, _controller.player);
        _clothesTab = new ClothesTab(_refs, _controller.player);
        _otherTab = new OtherTab(_refs);

        _shop.x = int((stage.stageWidth-_shop.width)/2);

        _tab1Label = new TextField(_tab1.width, 75, "COINS", "shop_text", -1, 0xFFFFFF);
        _tab1Label.touchable = false;
        _tab1Label.x = _tab1.x + _shop.x;
        _tab1Label.y = _tab1.y + _shop.y;
        addChild(_tab1Label);

        _tab2Label = new TextField(_tab2.width, 75, "HEROES", "shop_text", -1, 0xFFFFFF);
        _tab2Label.touchable = false;
        _tab2Label.x = _tab2.x + _shop.x;
        _tab2Label.y = _tab2.y + _shop.y;
        addChild(_tab2Label);

        _tab3Label = new TextField(_tab3.width, 75, "CLOTHES", "shop_text", -1, 0xFFFFFF);
        _tab3Label.touchable = false;
        _tab3Label.x = _tab3.x + _shop.x;
        _tab3Label.y = _tab3.y + _shop.y;
        addChild(_tab3Label);

        _tab4Label = new TextField(_tab4.width, 75, "OTHER", "shop_text", -1, 0xFFFFFF);
        _tab4Label.touchable = false;
        _tab4Label.x = _tab4.x + _shop.x;
        _tab4Label.y = _tab4.y + _shop.y;
        addChild(_tab4Label);

        _title = new StrokeTextField(400, 100, "SHOP");
        _title.x = 200;
        _title.y = 20;
        addChild(_title);

        _coins = new TextField(200, 52, "", "coins", -1, 0xFFFFFF);
        _coins.x = stage.stageWidth-372;
        _coins.y = 31;
        addChild(_coins);
    }

    private function handleUpdate(e: Event):void {
        _coins.text = FormatUtil.formatMoney(_controller.player.money);
    }

    override public function open():void {
        updateTabs(_tab1);

        super.open();

        _controller.player.addEventListener(Player.UPDATE, handleUpdate);
        handleUpdate(null);
    }

    override public function close():void {
        _controller.player.removeEventListener(Player.UPDATE, handleUpdate);

        super.close();
    }

    private function updateTabs(tab: Button):void {
        _container.removeChildren();

        _shop.addChild(_tab4);
        _shop.addChild(_tab3);
        _shop.addChild(_tab2);
        _shop.addChild(_tab1);
        _shop.addChild(_popupBack);
        _shop.addChild(tab);
        _shop.addChild(_container);

        switch (tab) {
            case _tab1:
                _container.addChild(_coinsTab);
                break;
            case _tab2:
                _container.addChild(_heroesTab);
                break;
            case _tab3:
                _container.addChild(_clothesTab);
                break;
            case _tab4:
                _container.addChild(_otherTab);
                break;
        }
    }

    private function handleTab(e: Event):void {
        updateTabs(e.currentTarget as Button);
    }

    private function handleClick(e: Event):void {
        switch (e.currentTarget) {
            case _backBtn:
                dispatchEventWith(GameController.UI_ACTION, true, GameController.BACK);
                break;
        }
    }
}
}
