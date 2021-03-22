

INSERT INTO Item.Types 
    (ItemType)
VALUES 
    ('Food'),
    ('Liquid'),
    ('Weapon'),
    ('Ammo'),
    ('Attachment'),
    ('Bag'),
    ('Misc'),
    ('Armour');

INSERT INTO 
    Item.Items (ItemTypeId, ItemName, ItemWeight, ItemMaxStack)
VALUES
    (1, 'Sandwich', 0.200, 1),
    (2, 'Water', 0.500, 1),
    (3, 'Baseball Bat', 1.0, 1),
    (3, 'Pistol', 0.600, 1),
    (4, '9mm round', 0.01406, 120),
    (6, 'Backpack', 0.250, 1),
    (8, 'Bulletproof vest', 1.0, 1),
    (3, 'Flashbang', 0.5, 1);

INSERT INTO
    Item.ModifierTypes (ItemModifierTypeName)
VALUES
    ('Food'),
    ('Liquid'),
    ('Armour');

INSERT INTO
    Item.Modifiers (ItemModifierTypeId, ItemId, ItemModifier)
VALUES
    (1, 1, 50),
    (2, 2, 50),
    (3, 7, 75);

INSERT INTO
    Item.Weapons (ItemId, ItemWeaponModel, ItemWeaponHash, ItemUsesAmmo, ItemAlertsCops, AmmoItemId)
VALUES
    (3, 'WEAPON_BAT', CAST(x'958A4A8F' as INT), '0', '0', 0),
    (4, 'WEAPON_PISTOL', CAST(x'1B06D571' as INT), '1', '1', 4),
    (8, 'WEAPON_FLASHBANG', CAST(x'FBA1FB98' as INT), 't', 'f', 8);

INSERT INTO
    Groups.Types (GroupTypeName)
VALUES
    ('Job'),
    ('Group'),
    ('Misc');

INSERT INTO
    Groups.Groups (GroupName, GroupTypeId)
VALUES
    ('Unemployed', 3),
    ('Department of Justice', 1),
    ('Los Santos Police Department', 1),
    ('Blaine County Sheriffs Department', 1),
    ('U.S. Marshals Service', 1);

INSERT INTO 
    Groups.Rank (GroupId, Rank) 
VALUES
    (1, 'Unemployed'),
    (2, 'Chief Justice'),
    (2, 'Justice'),
    (2, 'Judge'),
    (2, 'Chief Public Defender'),
    (2, 'Asst. Chief Public Defender'),
    (2, 'Public Defender'),
    (2, 'District Attorney'),
    (2, 'Asst. District Attorney'),
    (2, 'Prosecutor'),
    (2, 'Paralegal'),
    (5, 'US Marshal'),
    (5, 'Chief Deputy US Marshal'),
    (5, 'Supervisory US Marshal'),
    (5, 'Deputy US Marshal');

INSERT INTO
    Groups.JobPay (GroupRankId, Pay)
VALUES 
    (2, 100),
    (3, 90),
    (4, 80),
    (5, 70),
    (6, 60),
    (7, 50),
    (8, 70),
    (9, 60),
    (10, 50),
    (11, 15),
    (12, 80),
    (13, 70),
    (14, 60),
    (15, 50);

INSERT INTO
    Player.Types (PlayerType)
VALUES
    ('Player'),
    ('Support'),
    ('Dev'),
    ('Admin'),
    ('Owner');

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
    (102, 84, 'Plastic Surgery Unit', 338.8, -1394.5, 31.5),      -- Central Los Santos Medical Center
    (102, 84, 'Plastic Surgery Unit', -874.7, -307.5, 38.5),      -- Portola Trinity Medical Center
    (102, 84, 'Plastic Surgery Unit', -676.7, 311.5, 82.5),       -- Eclipse Medical Tower
    (102, 84, 'Plastic Surgery Unit', -449.8, -341.0, 33.7),      -- Mount Zonah Medical Center
    (102, 84, 'Plastic Surgery Unit', 298.7, -584.6, 42.2);       -- Pillbox Hill Medical Center


INSERT INTO 
    Command.PlayerTypePermissions (PlayerTypeId, Permission)
VALUES
    (1, 'me'),
    (1, 'looc'),
    (1, 'ad'),
    (1, 'pos'),
    (3, 'dv'),
    (3, 'tpm'),
    (3, 'character'),
    (3, 'features'),
    (3, 'style'),
    (3, 'apparel'),
    (3, 'wardrobe'),
    (5, 'give_item');