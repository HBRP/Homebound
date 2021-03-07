
INSERT INTO jobs (`name`, `label`, `whitelisted`) VALUES ('usmarshal', 'US. Marshal', 1);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('usmarshal', 1600, 'dusmarshal', 'Director', 1000, '{}', '{}'),
	('offusmarshal', 1605, 'offdusmarshal', 'Off-Duty Director', 600, '{}', '{}'),
	('usmarshal', 1610, 'ddusmarshal', 'Deputy Director', 900, '{}', '{}'),
	('offusmarshal', 1615, 'offddusmarshal', 'Off-Duty Deputy Director', 500, '{}', '{}'),
	('usmarshal', 1620, 'usmarshal', 'U.S Marshal', 600, '{}', '{}'),
	('offusmarshal', 1625, 'offusmarshal', 'Off-Duty U.S Marshal', 300, '{}', '{}'),
	('usmarshal', 1630, 'usdepmarshal', 'Deputy U.S Marshal', 500, '{}', '{}'),
	('offusmarshal', 1635, 'offdepusmarshal', 'Off-Duty Deputy U.S Marshal', 300, '{}', '{}');

INSERT addon_inventory (`name`, `label`, `shared`) VALUES ('USMS Supply Locker', 'USMS Supply Locker', 1)