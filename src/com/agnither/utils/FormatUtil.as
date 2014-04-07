/**
 * Created by agnither on 27.03.14.
 */
package com.agnither.utils {
public class FormatUtil {

    public static function formatMoney(money: int):String {
        return String(money).replace(/(\s)+/g, '').replace(/(\d{1,3})(?=(?:\d{3})+$)/g, '$1 ');
    }
}
}
