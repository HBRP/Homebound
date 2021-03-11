

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

INSERT INTO Blip.Blips
    (BlipType, BlipColor, BlipName, X, Y, Z)
VALUES
    (73, 84, 'Clothing Store', 72.3, -1399.1, 28.4),
    (73, 84, 'Clothing Store', -703.8, -152.3, 36.4),
    (73, 84, 'Clothing Store', -167.9, -299.0, 38.7),
    (73, 84, 'Clothing Store', 428.7, -800.1, 28.5),
    (73, 84, 'Clothing Store', -829.4, -1073.7, 10.3),
    (73, 84, 'Clothing Store', -1447.8, -242.5, 48.8),
    (73, 84, 'Clothing Store', 11.6, 6514.2, 30.9),
    (73, 84, 'Clothing Store', 123.6, -219.4, 53.6),
    (73, 84, 'Clothing Store', 1696.3, 4829.3, 41.1),
    (73, 84, 'Clothing Store', 618.1, 2759.6, 41.1),
    (73, 84, 'Clothing Store', 1190.6, 2713.4, 37.2),
    (73, 84, 'Clothing Store', -1193.4, -772.3, 16.3),
    (73, 84, 'Clothing Store', -3172.5, 1048.1, 19.9),
    (73, 84, 'Clothing Store', -1108.4, 2708.9, 18.1),
    (71, 84, 'Barber Shop', -814.3, -183.8, 36.6),
    (71, 84, 'Barber Shop', 136.8, -1708.4, 28.3),
    (71, 84, 'Barber Shop', -1282.6, -1116.8, 6.0),
    (71, 84, 'Barber Shop', 1931.5, 3729.7, 31.8),
    (71, 84, 'Barber Shop', 1212.8, -472.9, 65.2),
    (71, 84, 'Barber Shop', -32.9, -152.3, 56.1),
    (71, 84, 'Barber Shop', -278.1, 6228.5, 30.7),
    (102, 84, 'Platic Surgery Unit', 338.8, -1394.5, 31.5),      -- Central Los Santos Medical Center
    (102, 84, 'Platic Surgery Unit', -874.7, -307.5, 38.5),      -- Portola Trinity Medical Center
    (102, 84, 'Platic Surgery Unit', -676.7, 311.5, 82.5),       -- Eclipse Medical Tower
    (102, 84, 'Platic Surgery Unit', -449.8, -341.0, 33.7),      -- Mount Zonah Medical Center
    (102, 84, 'Platic Surgery Unit', 298.7, -584.6, 42.2);       -- Pillbox Hill Medical Center