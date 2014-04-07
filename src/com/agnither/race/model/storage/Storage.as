/**
 * Created by agnither on 21.03.14.
 */
package com.agnither.race.model.storage {
import starling.events.EventDispatcher;

public class Storage extends EventDispatcher {

    private var _areas: Vector.<Area>;

    private var _levels: Vector.<Level>;

    private var _heroes: Vector.<Hero>;

    public function Storage() {
        _areas = new <Area>[];
        _levels = new <Level>[];
        _heroes = new <Hero>[];
    }

    public function init(areas: Object, levels: Object, heroes: Object):void {

    }
}
}
