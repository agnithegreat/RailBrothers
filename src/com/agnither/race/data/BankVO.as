/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 9/21/13
 * Time: 9:35 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.race.data {

public class BankVO {

    public static const BANK: Vector.<BankVO> = new <BankVO>[];

    public var id: int;
    public var amount: int;
    public var price: Number;

    public static function parseData(data: Object):void {
        for each (var object:Object in data) {
            var bank: BankVO = new BankVO();
            for (var key: String in object) {
                bank[key] = object[key];
            }

            BANK.push(bank);
        }
    }
}
}
