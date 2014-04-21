ALTER TABLE `item_template`
	ADD COLUMN `overrideMeleeRange` FLOAT(10) NOT NULL DEFAULT '0' AFTER `overrideMeleeTriggeredCast`;
