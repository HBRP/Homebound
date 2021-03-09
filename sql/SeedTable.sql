

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
    ('Department of Justice'),
    ('Los Santos Police Department'),
    ('Blaine County Sheriffs Department'),
    ('U.S. Marshals Service');

INSERT INTO 
    Job.Type (JobFieldId, Rank, Pay, Paygrade) 
VALUES
    (1, 'Unemployed', 0, 0),
    (2, 'Chief Justice', 100, 100),
    (2, 'Justice', 90, 90),
    (2, 'Judge', 80, 80),
    (2, 'Chief Public Defender', 70, 70),
    (2, 'Asst. Chief Public Defender', 60, 60),
    (2, 'Public Defender', 50, 50),
    (2, 'District Attorney', 70, 70),
    (2, 'Asst. District Attorney', 60, 60),
    (2, 'Prosecutor', 50, 50),
    (2, 'Paralegal', 40, 40),
    (5, 'US Marshal', 80, 100),
    (5, 'Chief Deputy US Marshal', 70, 90),
    (5, 'Supervisory US Marshal', 60, 80),
    (5, 'Deputy US Marshal', 50, 70);

INSERT INTO
    Player.Types (PlayerType)
VALUES
    ('Player'),
    ('Support'),
    ('Dev'),
    ('Admin'),
    ('Owner');

INSERT INTO
    Player.TypePermissions (PersonTypeId, Permission)
VALUES
    (1, 'SomeCommand'),
    (1, 'SomeCommand'),
    (1, 'SomeOtherCommand');

INSERT INTO
    Storage.Types (StorageTypeName, StorageTypeSlots)
VALUES
    ('Player Inventory', 40),
    ('Stash', 120),
    ('Trunk', 120),
    ('Glovebox', 40),
    ('Bag', 30);

INSERT INTO 
    Store.Types (StoreTypeName)
VALUES
    ('Convenience Store'),
    ('Black Market'),
    ('Pawn Shop');
