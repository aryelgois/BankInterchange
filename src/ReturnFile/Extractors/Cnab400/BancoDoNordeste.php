<?php
/**
 * This Software is part of aryelgois/bank-interchange and is provided "as is".
 *
 * @see LICENSE
 */

namespace aryelgois\BankInterchange\ReturnFile\Extractors\Cnab400;

use aryelgois\BankInterchange\ReturnFile;

/**
 * Extracts useful data from parsed Banco do Nordeste's CNAB 400 Return Files
 *
 * @author Aryel Mota Góis
 * @license MIT
 * @link https://www.github.com/aryelgois/bank-interchange
 */
class BancoDoNordeste extends ReturnFile\Extractors\Cnab400
{
    const CHARGING_TYPES = [
        'cs',
    ];
}
