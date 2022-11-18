CREATE TABLE `users` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
 `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `balances` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `asset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `amount` bigint  NOT NULL,
 `amountavailable` bigint  NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `markets` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `market` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `baseasset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `quoteasset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `amount` bigint  NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `orders` (
 `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `market` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `buysell` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `baseasset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `quoteasset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `amount` bigint  NOT NULL,
 `amountoutstanding` bigint  NOT NULL,
 `amountgained` bigint  NOT NULL,
 `minamount` bigint NOT NULL,
 `rate` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `status` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `orders-archive` (
 `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `market` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `buysell` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `baseasset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `quoteasset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `amount` bigint  NOT NULL,
 `amountoutstanding` bigint  NOT NULL,
 `amountgained` bigint  NOT NULL,
 `minamount` bigint NOT NULL,
 `rate` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `status` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `transactions` (
 `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `description` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
 `amountfrom` bigint,
 `amountto` bigint,
 `asset` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `messages` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `message` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pendingdeposits` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `message` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `depositaddresses` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `asset` varchar(4) COLLATE utf8_unicode_ci NOT NULL,
 `address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `withdrawalrequests` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT,
 `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `asset` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
 `amount` bigint NOT NULL,
 `address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
 `dt` DATETIME DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;