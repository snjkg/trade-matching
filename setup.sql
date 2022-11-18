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
