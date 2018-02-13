-- Banks
-- TODO verify `billet_tax`

INSERT INTO `banks` (`id`, `code`, `name`, `logo`, `billet_tax`) VALUES
(1, '104', 'Caixa Econômica Federal', 'caixa.jpg', '2.0000'),
(2, '047', 'Banese', 'banese.jpg', '2.0000'),
(3, '004', 'Banco do Nordeste', 'banco_do_nordeste.jpg', '2.0000');

-- Currencies
-- TODO verify `currency_codes`

INSERT INTO `currencies` (`id`, `symbol`, `name`, `name_plural`, `decimals`, `thousand`, `decimal`) VALUES
(1, 'R$', 'Real', 'Reais', 2, '', ',');

INSERT INTO `currency_codes` (`currency`, `bank`, `billet`, `cnab240`, `cnab400`) VALUES
(1, 1, '9', '09', '?'),
(1, 2, '9', '09', '1'),
(1, 3, '9', '??', '0');

-- Wallets
-- TODO verify data

INSERT INTO `wallets` (`id`, `bank`, `cnab`, `code`, `operation`, `symbol`, `name`) VALUES
(1, 1, '240', '1', '?', 'CR', 'Cobrança Registrada'),
(2, 2, '240', '1', '?', 'CS', 'Cobrança Simples'),
(3, 2, '400', '2', '?', 'CS', 'Cobrança Simples'),
(4, 2, '400', '7', '?', 'CE', 'Cobrança Expressa'),
(5, 3, '400', '1', '21', 'CS', 'Cobrança Simples Escritural - Boleto Emitido Pelo Banco'),
(6, 3, '400', '2', '41', 'CV', 'Cobrança Vinculada – Boleto Emitido Pelo Banco'),
(7, 3, '400', '4', '21', 'CS', 'Cobrança Simples - Boleto Emitido Pelo Cliente'),
(8, 3, '400', '5', '41', 'CV', 'Cobrança Vinculada - Boleto Emitido Pelo Cliente'),
(9, 3, '400', 'I', '51', 'SR', 'Cobrança Simplificada (Sem Registro)');
