

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
    ('Armour'),
    ('Attachment');

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
    (3, 'Flashbang', 0.5, 1),
    (7, 'cash', 0.001, 500000),
    (7, '9mm ammo box', 0.8436, 5),
    (7, 'Class 1 License', 0, 1),
    (9, 'Suppressor', 2.0, 1),
    (9, 'Weapon Flashlight', 1.0, 1);

INSERT INTO
    Item.Attachments (ItemId, WeaponItemId, ItemAttachmentHash)
VALUES
    (12, 4, CAST(x'65EA7EBB' as INT)),
    (13, 4, CAST(x'359B7AAE' as INT));

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
    (3, 'WEAPON_BAT', CAST(x'958A4A8F' as INT), 'f', 'f', 0),
    (4, 'WEAPON_PISTOL', CAST(x'1B06D571' as INT), 't', 'f', 4),
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
    ('Bag', 30),
    ('Drop', 20),
    ('Weapon', 3);

INSERT INTO 
    Storage.StorableItemTypes (StorageTypeId, ItemTypeId)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (2, 7),
    (2, 8),
    (2, 9),
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4),
    (3, 5),
    (3, 6),
    (3, 7),
    (3, 8),
    (3, 9),
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5),
    (4, 6),
    (4, 7),
    (4, 8),
    (4, 9),
    (5, 1),
    (5, 2),
    (5, 3),
    (5, 4),
    (5, 5),
    (5, 6),
    (5, 7),
    (5, 8),
    (5, 9),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (6, 5),
    (6, 6),
    (6, 7),
    (6, 8),
    (6, 9),
    (7, 9);


INSERT INTO Customization.Types (CustomizationTypeName)
VALUES
    ('Clothing Store'),
    ('Barber Shop'),
    ('Surgery Shop');

INSERT INTO Customization.Points (CustomizationTypeId, CustomizationName, X, Y, Z)
VALUES
    (1, 'Clothing Store', 72.3, -1399.1, 28.4),
    (1, 'Clothing Store', -703.8, -152.3, 36.4),
    (1, 'Clothing Store', -167.9, -299.0, 38.7),
    (1, 'Clothing Store', 428.7, -800.1, 28.5),
    (1, 'Clothing Store', -829.4, -1073.7, 10.3),
    (1, 'Clothing Store', -1447.8, -242.5, 48.8),
    (1, 'Clothing Store', 11.6, 6514.2, 30.9),
    (1, 'Clothing Store', 123.6, -219.4, 53.6),
    (1, 'Clothing Store', 1696.3, 4829.3, 41.1),
    (1, 'Clothing Store', 618.1, 2759.6, 41.1),
    (1, 'Clothing Store', 1190.6, 2713.4, 37.2),
    (1, 'Clothing Store', -1193.4, -772.3, 16.3),
    (1, 'Clothing Store', -3172.5, 1048.1, 19.9),
    (1, 'Clothing Store', -1108.4, 2708.9, 18.1),
    (1, 'Clothing Picker', 300.246, -598.77, 43.27), -- pillbox
    (1, 'Clothing Picker', 455.41, -990.875, 30.689); --mrpd

INSERT INTO 
    Store.Types (StoreTypeName)
VALUES
    ('Convenience Store'),
    ('Black Market'),
    ('Pawn Shop'),
    ('Ammunation');

INSERT INTO
    store.stores (StoreTypeId, StoreName, X, Y, Z)
VALUES
    (1, 'Convenience Store', 26.16, -1347.36, 29.49),
    (4, 'Ammunation', 21.75, -1107.114, 29.79),
    (4, 'Ammunation', -662.458, -935.63, 21.829),
    (4, 'Ammunation', -330.25, 6083.488, 32.45),
    (4, 'Ammunation', 1693.82, 3759.56, 34.705),
    (4, 'Ammunation', -1305.838, -393.817, 36.69),
    (4, 'Ammunation', 810.158, -2157.616, 29.619);


INSERT INTO
    Store.SellItems (StoreTypeId, ItemId, ItemSellPrice)
VALUES
    (1, 1, 2),
    (1, 2, 2),
    (4, 3, 15),
    (4, 4, 250),
    (4, 7, 100),
    (4, 10, 20);

INSERT INTO Blip.Blips
    (BlipType, BlipColor, BlipName, X, Y, Z, Static)
VALUES
    (73, 4, 'Clothing Store', 72.3, -1399.1, 28.4, 'f'),
    (73, 4, 'Clothing Store', -703.8, -152.3, 36.4, 'f'),
    (73, 4, 'Clothing Store', -167.9, -299.0, 38.7, 'f'),
    (73, 4, 'Clothing Store', 428.7, -800.1, 28.5, 'f'),
    (73, 4, 'Clothing Store', -829.4, -1073.7, 10.3, 'f'),
    (73, 4, 'Clothing Store', -1447.8, -242.5, 48.8, 'f'),
    (73, 4, 'Clothing Store', 11.6, 6514.2, 30.9, 'f'),
    (73, 4, 'Clothing Store', 123.6, -219.4, 53.6, 'f'),
    (73, 4, 'Clothing Store', 1696.3, 4829.3, 41.1, 'f'),
    (73, 4, 'Clothing Store', 618.1, 2759.6, 41.1, 'f'),
    (73, 4, 'Clothing Store', 1190.6, 2713.4, 37.2, 'f'),
    (73, 4, 'Clothing Store', -1193.4, -772.3, 16.3, 'f'),
    (73, 4, 'Clothing Store', -3172.5, 1048.1, 19.9, 'f'),
    (73, 4, 'Clothing Store', -1108.4, 2708.9, 18.1, 'f'),
    (71, 4, 'Barber Shop', -814.3, -183.8, 36.6, 'f'),
    (71, 4, 'Barber Shop', 136.8, -1708.4, 28.3, 'f'),
    (71, 4, 'Barber Shop', -1282.6, -1116.8, 6.0, 'f'),
    (71, 4, 'Barber Shop', 1931.5, 3729.7, 31.8, 'f'),
    (71, 4, 'Barber Shop', 1212.8, -472.9, 65.2, 'f'),
    (71, 4, 'Barber Shop', -32.9, -152.3, 56.1, 'f'),
    (71, 4, 'Barber Shop', -278.1, 6228.5, 30.7, 'f'),
    (102, 4, 'Plastic Surgery Unit', 338.8, -1394.5, 31.5, 'f'),      -- Central Los Santos Medical Center
    (102, 4, 'Plastic Surgery Unit', -874.7, -307.5, 38.5, 'f'),      -- Portola Trinity Medical Center
    (102, 4, 'Plastic Surgery Unit', -676.7, 311.5, 82.5, 'f'),       -- Eclipse Medical Tower
    (102, 4, 'Plastic Surgery Unit', -449.8, -341.0, 33.7, 'f'),      -- Mount Zonah Medical Center
    (102, 4, 'Plastic Surgery Unit', 298.7, -584.6, 42.2, 'f'),       -- Pillbox Hill Medical Center
    (361, 4, 'Gas Station', 49.4187, 2778.793, 58.043, 'f'),
    (361, 4, 'Gas Station', 263.894, 2606.463, 44.983, 'f'),
    (361, 4, 'Gas Station', 1039.958, 2671.134, 39.550, 'f'),
    (361, 4, 'Gas Station', 1207.260, 2660.175, 37.899, 'f'),
    (361, 4, 'Gas Station', 2539.685, 2594.192, 37.944, 'f'),
    (361, 4, 'Gas Station', 2679.858, 3263.946, 55.240, 'f'),
    (361, 4, 'Gas Station', 2005.055, 3773.887, 32.403, 'f'),
    (361, 4, 'Gas Station', 1687.156, 4929.392, 42.078, 'f'),
    (361, 4, 'Gas Station', 1701.314, 6416.028, 32.763, 'f'),
    (361, 4, 'Gas Station', 179.857, 6602.839, 31.868, 'f'),
    (361, 4, 'Gas Station', -94.4619, 6419.594, 31.489, 'f'),
    (361, 4, 'Gas Station', -2554.996, 2334.40, 33.078, 'f'),
    (361, 4, 'Gas Station', -1800.375, 803.661, 138.651, 'f'),
    (361, 4, 'Gas Station', -1437.622, -276.747, 46.207, 'f'),
    (361, 4, 'Gas Station', -2096.243, -320.286, 13.168, 'f'),
    (361, 4, 'Gas Station', -724.619, -935.1631, 19.213, 'f'),
    (361, 4, 'Gas Station', -526.019, -1211.003, 18.184, 'f'),
    (361, 4, 'Gas Station', -70.2148, -1761.792, 29.534, 'f'),
    (361, 4, 'Gas Station', 265.648, -1261.309, 29.292, 'f'),
    (361, 4, 'Gas Station', 819.653, -1028.846, 26.403, 'f'),
    (361, 4, 'Gas Station', 1208.951, -1402.567,35.224, 'f'),
    (361, 4, 'Gas Station', 1181.381, -330.847, 69.316, 'f'),
    (361, 4, 'Gas Station', 620.843, 269.100, 103.089, 'f'),
    (361, 4, 'Gas Station', 2581.321, 362.039, 108.468, 'f'),
    (361, 4, 'Gas Station', 176.631, -1562.025, 29.263, 'f'),
    (361, 4, 'Gas Station', 176.631, -1562.025, 29.263, 'f'),
    (361, 4, 'Gas Station', -319.292, -1471.715, 30.549, 'f'),
    (361, 4, 'Gas Station', 1784.324, 3330.55, 41.253, 'f');


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


INSERT INTO 
    Licensing.LicenseTypes (LicenseTypeName)
VALUES
    ('Class 1 License'),
    ('Class 2 License');

INSERT INTO
    Blip.Groups (BlipGroupName)
VALUES
    ('Emergency Services'),
    ('USMS');

INSERT INTO
    Groups.BlipSubscription (GroupId, BlipColor, BlipGroupId)
VALUES
    (3, 38, 1),
    (3, 28, 1);