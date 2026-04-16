-- SQL para ESX (player_groups referencia users.identifier)

CREATE TABLE IF NOT EXISTS `player_groups` (
  `citizenid` VARCHAR(50) NOT NULL,
  `group` VARCHAR(50) NOT NULL,
  `type` VARCHAR(50) NOT NULL,
  `grade` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`citizenid`, `type`, `group`),
  CONSTRAINT `fk_identifier` FOREIGN KEY (`citizenid`) REFERENCES `users` (`identifier`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
