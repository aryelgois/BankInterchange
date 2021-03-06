<?php
/**
 * This Software is part of aryelgois/bank-interchange and is provided "as is".
 *
 * @see LICENSE
 */

namespace aryelgois\BankInterchange\ShippingFile\Views\Cnab400;

use aryelgois\BankInterchange;
use aryelgois\BankInterchange\Utils;
use aryelgois\BankInterchange\Models;

/**
 * Generates CNAB400 shipping files for Bano do Nordeste
 *
 * @author Aryel Mota Góis
 * @license MIT
 * @link https://www.github.com/aryelgois/bank-interchange
 */
class BancoDoNordeste extends BankInterchange\ShippingFile\Views\Cnab400
{
    /**
     * List of masks to apply in a Title registry based on its movement
     *
     * NOTE:
     * - Some movements are not implemented
     * - '10' should have the protest_days value set accordingly
     * - '31' should mask '02' + changed fields only, but currently it masks all
     *   allowed fields
     *
     * @var string[]
     */
    const MOVEMENT_MASK = [
        '02' => '*                **************                               ********                                     ***                *************                                                                                                                                                                                                                                                               ******',
        '04' => '*                **************                               ********                                     ***                *************                                                                  *************                                                                                                                                                                                ******',
        '06' => '*                **************                               ********                                     ***          *******************                                                                                                                                                                                                                                                               ******',
        '07' => '*                **************      *********************************                                     ***                *************                                                                                                                                                                                                                                                               ******',
        '08' => '*                **************                               ********                                     *************      *************                                                                                                                                                                                                                                                               ******',
        '09' => '*                **************                               ********                                     ***                *************                                                                                                                                                                                                                                                            ** ******',
        '10' => '*                **************                               ********                                     ***                *************                                                                                                                                                                                                                                                            99 ******',
        '31' => '*                **************                               ********          *******************        ***                *************        *************             *******************                          *************************************************************************************************************************************                                           ******',
    ];

    /**
     * Generates Header registry
     *
     * @return string
     */
    protected function generateHeader()
    {
        $shipping_file = $this->shipping_file;
        $assignment = $shipping_file->assignment;
        $assignor_person = $assignment->assignor->person;
        $bank = $assignment->bank;

        $format = '%01.1s%01.1s%-7.7s%02.2s%-15.15s%04.4s%02.2s%07.7s%01.1s'
            . '%-6.6s%-30.30s%03.3s%-15.15s%06.6s%03.3s%-291.291s%06.6s';

        $data = [
            '0',
            '1',
            'REMESSA',
            '1',
            'COBRANCA',
            $assignment->agency,
            '0',
            $assignment->account,
            $assignment->account_cd,
            '',
            Utils::cleanSpaces($assignor_person->name),
            $bank->code,
            $bank->name,
            static::date('dmy', $shipping_file->stamp),
            $assignment->edi,
            '',
            $this->registry_count,
        ];

        return vsprintf($format, static::normalize($data));
    }

    /**
     * Generates Transaction registry
     *
     * @param Models\Title $title Contains data for the registry
     *
     * @return string
     */
    protected function generateTransaction(Models\Title $title)
    {
        $assignment = $title->assignment;
        $assignor_person = $assignment->assignor->person;
        $bank = $assignment->bank;
        $client = $title->client;
        $client_address = $client->address;
        $client_person = $client->person;
        $currency = $title->currency;
        $currency_code = $title->getCurrencyCode();
        $movement = $title->movement->code;

        $format = '%01.1s%-16.16s%04.4s%02.2s%07.7s%01.1s%02.2s%-4.4s%-25.25s'
            . '%07.7s%01.1s%010.10s%06.6s%013.13s%-8.8s%01.1s%02.2s%-10.10s'
            . '%06.6s%013.13s%03.3s%04.4s%-1.1s%02.2s%-1.1s%06.6s%04.4s%013.13s'
            . '%06.6s%013.13s%013.13s%013.13s%02.2s%014.14s%-40.40s%-40.40s'
            . '%-12.12s%08.8s%-15.15s%-2.2s%-40.40s%02.2s%-1.1s%06.6s';

        $client_address_piece = implode(' ', [
            static::filter($client_address->place),
            $client_address->number,
            static::filter($client_address->neighborhood)
        ]);

        $data = [
            '1',
            '',
            $assignment->agency,
            '0',
            $assignment->account,
            $assignment->account_cd,
            '0', // fine percent
            '',
            $title->doc_number,
            $title->our_number,
            $title->checkDigitOurNumber(),
            '0', // contract
            static::date('dmy', $title->discount2_date),
            $currency->format($title->discount2_value, 'nomask'),
            '',
            $assignment->wallet->code,
            $movement,
            $title->doc_number,
            static::date('dmy', $title->due),
            $currency->format($title->getActualValue(), 'nomask'),
            '0', // Charging bank
            '0', // Charging agency
            '',
            $title->kind->code,
            $title->accept,
            static::date('dmy', $title->emission),
            '5', // instruction code
            '0', // interest value
            static::date('dmy', $title->discount1_date),
            $currency->format($title->discount1_value, 'nomask'),
            $currency->format($title->ioc_iof, 'nomask'),
            $currency->format($title->rebate, 'nomask'),
            $client_person->getDocumentType(),
            $client_person->document,
            Utils::cleanSpaces($client_person->name),
            Utils::cleanSpaces($client_address_piece),
            Utils::cleanSpaces($client_address->detail),
            $client_address->zipcode,
            $client_address->county->name,
            $client_address->county->state->code,
            '', // message or guarantor name
            min($title->protest_days ?? 99, 99),
            $currency_code->cnab400,
            $this->registry_count,
        ];

        return static::mask(
            vsprintf($format, static::normalize($data)),
            static::MOVEMENT_MASK[$movement] ?? null
        );
    }

    /**
     * Generates Trailer registry
     *
     * @return string
     */
    protected function generateTrailer()
    {
        $format = '%01.1s%-393.393s%06.6s';

        $data = [
            '9',
            '',
            $this->registry_count,
        ];

        return vsprintf($format, static::normalize($data));
    }
}
