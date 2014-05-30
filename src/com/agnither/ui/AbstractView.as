/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.utils.CommonRefs;

import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;

public class AbstractView extends Sprite {

    protected var _refs: CommonRefs;

    protected var _data: Object;
    public function set data(value:Object):void {
        _data = value;
    }

    public function AbstractView(refs: CommonRefs) {
        _refs = refs;

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
    }

    protected function initialize():void {
    }

    public function open():void {
    }

    public function close():void {

    }

    private function handleAddedToStage(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        initialize();
    }

    private function handleAdded(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
        open();
    }

    private function handleRemoved(event: Event):void {
//        close();
        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
    }

    public function destroy():void {
        _refs = null;
    }
}
}