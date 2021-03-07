
/*

CREATE TABLE IF NOT EXISTS Job.Type
(
    JobId SERIAL PRIMARY KEY,
    JobFieldId INTEGER NOT NULL,
    Rank VARCHAR(64) NOT NULL,
    Pay INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Job.Field
(
    JobFieldId SERIAL PRIMARY KEY,
    JobFieldName VARCHAR(64) NOT NULL
);

*/


INSERT INTO
    Job.Field (JobFieldName)
VALUES
    ('Unemployed'),
    ('Department of Justice'),
    ('LSPD'),
    ('LSFD');

INSERT INTO 
    Job.Type (JobFieldId, Rank, Pay, Paygrade) 
VALUES
    (1, 'Unemployed', 0, 0),
    (2, 'Chief Justice', 100, 100),
    (2, 'Judge', 100, 90),
    (3, 'Cadet', 0, 0),
    (3, 'Cop', 100, 10),
    (4, 'Paramedic', 100, 10);


INSERT INTO
    Player.Types (PlayerType)
VALUES
    ('Player'),
    ('Support'),
    ('Dev'),
    ('Admin'),
    ('Executive');

INSERT INTO
    Player.TypePermissions (PersonTypeId, Permission)
VALUES
    (2, 'SomeCommand'),
    (3, 'SomeCommand'),
    (4, 'SomeOtherCommand');
