CREATE TABLE `voting`
(

	`VotingId` BIGINT PRIMARY KEY AUTO_INCREMENT,
	`VotingName` VARCHAR(64) NOT NULL,
	`StartTime` DATETIME NOT NULL,
	`EndTime` DATETIME NOT NULL

);

CREATE TABLE `voting_options`
(

	`VotingOptionId` BIGINT PRIMARY KEY AUTO_INCREMENT,
	`VotingId` BIGINT NOT NULL,
	`VotingOption` VARCHAR(64) NOT NULL

);

CREATE TABLE `voting_ballots`
(

	`VotingBallotId` BIGINT PRIMARY KEY AUTO_INCREMENT,
	`CharacterId` BIGINT NOT NULL,
	`SteamId` VARCHAR(32) NOT NULL,
	`VotingOptionId` BIGINT NOT NULL
	
);

INSERT INTO voting (VotingName, StartTime, EndTime)
VALUES
('Nov. 2020 - Mayor Election', '2020-11-16', '2020-11-19')

INSERT INTO voting_options (VotingId, VotingOption)
VALUES
(1, 'Matthew Gentry'),
(1, 'Ray "Jesus" Raymond'),
(1, 'Louis Gray');