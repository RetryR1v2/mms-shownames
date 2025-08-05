CREATE TABLE `mms_shownames` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'armscii8_general_ci',
	`charidentifier` INT(11) NULL DEFAULT NULL,
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'armscii8_general_ci',
	`alias` VARCHAR(50) NULL DEFAULT NULL COLLATE 'armscii8_general_ci',
	`aliasactive` INT(11) NOT NULL DEFAULT '0',
	`approved` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='armscii8_general_ci'
ENGINE=InnoDB
;
