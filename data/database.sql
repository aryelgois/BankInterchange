CREATE DATABASE bank_interchange CHARSET = UTF8 COLLATE = utf8_general_ci;
USE bank_interchange;

CREATE TABLE `fulladdress` (
    `id`            int(10)         UNSIGNED NOT NULL AUTO_INCREMENT,
    `county`        int(10)         UNSIGNED NOT NULL, -- Foreign to database Address: `counties` (`id`)
    `neighborhood`  varchar(15)     NOT NULL,
    `place`         varchar(40)     NOT NULL,
    `number`        varchar(40)     NOT NULL,
    `zipcode`       varchar(8)      NOT NULL,
    `detail`        varchar(40)     NOT NULL DEFAULT '',
    `stamp`         timestamp       NOT NULL, -- to check changes
    PRIMARY KEY (`id`)
);

CREATE TABLE `species` (
    `id`            tinyint(3)      UNSIGNED NOT NULL AUTO_INCREMENT,
    `symbol`        varchar(5)      NOT NULL,
    `cnab240`       char(2)         NOT NULL,
    `cnab400`       char(2)         NOT NULL,
    `thousand`      char(1)         NOT NULL,
    `decimal`       char(1)         NOT NULL,
    `name`          varchar(30)     NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `wallets` (
    `id`            tinyint(3)      UNSIGNED NOT NULL AUTO_INCREMENT,
    `symbol`        varchar(5)      NOT NULL,
    `cnab240`       char(1)         NOT NULL,
    `cnab400`       char(1)         NOT NULL,
    `operation`     tinyint(2)      NOT NULL,
    `name`          varchar(60)     NOT NULL,
    `notes`         varchar(60)     NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `banks` (
    `id`            int(10)         UNSIGNED NOT NULL AUTO_INCREMENT,
    `code`          char(3)         NOT NULL,
    `name`          varchar(60)     NOT NULL,
    `view`          varchar(30)     NOT NULL,
    `logo`          varchar(30),
    `tax`           decimal(6,4)    NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `assignors` (
    `id`            int(10)         UNSIGNED NOT NULL AUTO_INCREMENT,
    `bank`          int(10)         UNSIGNED NOT NULL,
    `address`       int(10)         UNSIGNED NOT NULL,
    `document`      varchar(14)     NOT NULL,
    `name`          varchar(60)     NOT NULL,
    `covenant`      char(20)        NOT NULL,
    `agency`        char(5)         NOT NULL,
    `agency_cd`     char(1)         NOT NULL,
    `account`       char(12)        NOT NULL,
    `account_cd`    char(1)         NOT NULL,
    `edi`           char(6)         NOT NULL,
    `logo`          varchar(30),
    `url`           varchar(30),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`bank`) REFERENCES `banks` (`id`),
    FOREIGN KEY (`address`) REFERENCES `fulladdress` (`id`)
);

CREATE TABLE `payers` (
    `id`            int(10)         UNSIGNED NOT NULL AUTO_INCREMENT,
    `address`       int(10)         UNSIGNED NOT NULL,
    `document`      varchar(14)     NOT NULL,
    `name`          varchar(60)     NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`address`) REFERENCES `fulladdress` (`id`)
);

CREATE TABLE `titles` (
    `id`            int(10)         UNSIGNED NOT NULL AUTO_INCREMENT,
    `assignor`      int(10)         UNSIGNED NOT NULL,
    `payer`         int(10)         UNSIGNED NOT NULL,
    `guarantor`     int(10)         UNSIGNED,
    `wallet`        tinyint(3)      UNSIGNED NOT NULL,
    `specie`        tinyint(3)      UNSIGNED NOT NULL,
    `onum`          int(10)         UNSIGNED NOT NULL,
    `status`        tinyint(1)      UNSIGNED NOT NULL DEFAULT 0,
    `doc_type`      char(1)         NOT NULL DEFAULT 1,
    `kind`          tinyint(2)      UNSIGNED NOT NULL,
    `value`         decimal(17,4)   NOT NULL,
    `iof`           decimal(17,4)   NOT NULL,
    `rebate`        decimal(17,4)   NOT NULL,
    `fine_type`     tinyint(1)      NOT NULL DEFAULT 3,
    `fine_date`     date,
    `fine_value`    decimal(17,4),
    `discount_type` tinyint(1)      NOT NULL DEFAULT 3,
    `discount_date` date,
    `discount_value` decimal(17,4),
    `description`   varchar(25)     NOT NULL,
    `due`           date            NOT NULL,
    `stamp`         timestamp       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update`        datetime,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`assignor`) REFERENCES `assignors` (`id`),
    FOREIGN KEY (`payer`) REFERENCES `payers` (`id`),
    FOREIGN KEY (`guarantor`) REFERENCES `payers` (`id`),
    FOREIGN KEY (`specie`) REFERENCES `species` (`id`),
    FOREIGN KEY (`wallet`) REFERENCES `wallets` (`id`),
    UNIQUE KEY `assignor_AND_onum`(`assignor`, `onum`)
);

CREATE TABLE `shipping_files` (
    `id`            int(10)         UNSIGNED NOT NULL AUTO_INCREMENT,
    `status`        tinyint(1)      UNSIGNED NOT NULL DEFAULT 0,
    `filename`      char(39),
    `stamp`         timestamp       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update`        datetime,
    PRIMARY KEY (`id`)
);
