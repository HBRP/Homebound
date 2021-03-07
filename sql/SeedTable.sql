

INSERT INTO Item.Types 
    (ItemType)
VALUES 
    ('Food'),
    ('Liquid'),
    ('Weapon'),
    ('Ammo'),
    ('Misc');

INSERT INTO
    Job.Field (JobFieldName)
VALUES
    ('Unemployed'),
    ('DOJ'),
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
