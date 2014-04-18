ALTER TABLE `item_template`
	ADD COLUMN `overrideMeleeSpellId` INT(10) UNSIGNED NOT NULL DEFAULT '0' AFTER `flagsCustom`,
	ADD COLUMN `overrideMeleeEnergyCost` INT(10) UNSIGNED NOT NULL DEFAULT '0' AFTER `overrideMeleeSpellId`,
	ADD COLUMN `overrideMeleeTriggeredCast` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' AFTER `overrideMeleeEnergyCost`;
