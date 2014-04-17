
DROP TABLE IF EXISTS `character_hg`;

CREATE TABLE `character_hg` (
  `guid` int(10) unsigned NOT NULL,
  `wins` int(10) unsigned NOT NULL DEFAULT '0',
  `losses` int(10) unsigned NOT NULL DEFAULT '0',
  `current_rank` int(10) unsigned NOT NULL DEFAULT '0',
  `highest_rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
