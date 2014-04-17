
DROP TABLE IF EXISTS `character_hg`;

CREATE TABLE `character_hg` (
  `entry` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL,
  `wins` int(10) unsigned NOT NULL DEFAULT '0',
  `losses` int(10) unsigned NOT NULL DEFAULT '0',
  `current_rank` int(10) unsigned NOT NULL DEFAULT '0',
  `highest_rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
