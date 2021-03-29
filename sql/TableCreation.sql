
CREATE SCHEMA Player;

CREATE TABLE IF NOT EXISTS Player.Players
(
    PlayerId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    SteamId VARCHAR(32) NOT NULL,
    PlayerTypeId INTEGER NOT NULL DEFAULT(1),
    CreateDate TIMESTAMP NOT NULL DEFAULT(CURRENT_TIMESTAMP)
);

CREATE TABLE IF NOT EXISTS Player.Types
(
    PlayerTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    PlayerType VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS Player.Characters
(
    CharacterId INTEGER GENERATED BY DEFAULT AS IDENTITY, 
    PlayerId INTEGER NOT NULL,
    FirstName VARCHAR(64) NOT NULL,
    LastName VARCHAR(64) NOT NULL,
    DOB VARCHAR(32) NOT NULL,
    Gender VARCHAR(32) NOT NULL,
    Deleted BOOLEAN NOT NULL DEFAULT('0'),
    CreateDate TIMESTAMP NOT NULL DEFAULT(CURRENT_TIMESTAMP)
);

CREATE SCHEMA Queue;

CREATE TABLE IF NOT EXISTS Queue.Permissions
(
    QueuePermissionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    PlayerId INTEGER NOT NULL,
    Whitelisted BOOLEAN NOT NULL DEFAULT('0'),
    Priority INTEGER NOT NULL DEFAULT(0)
);

-- If you exist in this table, you are banned.
CREATE TABLE IF NOT EXISTS Queue.Banned
(
    QueueBannedId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    PlayerId INTEGER NOT NULL,
    BannedUntil TIMESTAMP NOT NULL
);

CREATE SCHEMA Character;

CREATE TABLE IF NOT EXISTS Character.Positions
(
    CharacterPositionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    X REAL NOT NULL DEFAULT(0),
    Y REAL NOT NULL DEFAULT(0),
    Z REAL NOT NULL DEFAULT(0),
    Heading REAL NOT NULL DEFAULT(0)
);

CREATE TABLE IF NOT EXISTS Character.Health
(
    CharacterHealthId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    CharacterHealth JSONB
);

CREATE TABLE IF NOT EXISTS Character.Attributes
(
    CharacterAttributeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    Attribute VARCHAR(32) NOT NULL,
    AttributeValue INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Character.Skin
(
    CharacterSkinId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    Skin JSONB NOT NULL
);

-- TODO
CREATE TABLE IF NOT EXISTS Character.Outfits
(
    CharacterOutfitId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    ActiveOutfit BOOLEAN NOT NULL DEFAULT('1'),
    OutfitName VARCHAR(64) NOT NULL,
    Outfit JSONB NOT NULL
);

CREATE TABLE IF NOT EXISTS Character.Jobs
(
    CharacterJobId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    GroupRankId INTEGER NOT NULL,
    ClockedOn BOOLEAN NOT NULL DEFAULT('0')
);

CREATE TABLE IF NOT EXISTS Character.Groups
(
    CharacterJobId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    GroupRankId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Character.BankAccount
(
    CharacterBankAccountId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    BankAccountId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Character.Inventory
(
    CharacterStorageId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    StorageId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Character.InstanceStashes
(
    CharacterInstanceStash INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    StorageInstanceLocationId INTEGER NOT NULL,
    StorageId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Character.Licenses
(
    CharacterLicenseId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    LicenseTypeId INTEGER NOT NULL,
    Active BOOLEAN NOT NULL DEFAULT('t')
);

CREATE SCHEMA Groups;

CREATE TABLE IF NOT EXISTS Groups.Rank
(
    GroupRankId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupId INTEGER NOT NULL,
    Rank VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS Groups.JobPay
(
    GroupJobPayId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupRankId INTEGER NOT NULL,
    Pay INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Groups.JobClockin
(
    GroupJobClockinId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupId INTEGER NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS Groups.Groups
(
    GroupId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupName VARCHAR(64) NOT NULL,
    GroupTypeId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Groups.Types
(
    GroupTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupTypeName VARCHAR(64) NOT NULL
);


CREATE SCHEMA Bank;

CREATE TABLE IF NOT EXISTS Bank.Account
(
    BankAccountId INTEGER GENERATED BY DEFAULT AS IDENTITY, 
    AccountName VARCHAR(64) NOT NULL,
    Funds INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Bank.AccountOwner
(
    BankAccountOwnerId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    BankAccountId INTEGER NOT NULL,
    CharacterId INTEGER NOT NULL,
    DirectDeposit BOOLEAN NOT NULL DEFAULT('1'),
    Deleted BOOLEAN NOT NULL DEFAULT('0')
);

CREATE TABLE IF NOT EXISTS Bank.Transaction
(
    BankTransactionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    BankTransactionTypeId INTEGER NOT NULL,
    BankAccountId INTEGER NOT NULL,
    CharacterId INTEGER NOT NULL,
    AmountTransfered REAL NOT NULL,
    BankTransactionReason VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS Bank.Transfer
(
    BankTransferId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    BankTransactionTypeId INTEGER NOT NULL,
    BankAccountId INTEGER NOT NULL,
    AmountTransfered REAL NOT NULL,
    BankTransferReason VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS Bank.TransactionTypes
(
    BankTransactionTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    BankTransactionTypeName VARCHAR(32)
);

CREATE SCHEMA Storage;

CREATE TABLE IF NOT EXISTS Storage.Containers
(
    StorageId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageTypeId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Storage.Types
(
    StorageTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageTypeName VARCHAR(64),
    StorageTypeSlots INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Storage.Stashes
(
    StorageStashId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageId INTEGER NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS Storage.InstanceLocation
(
    StorageInstanceLocationId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    InstanceLocationName VARCHAR(32) NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS Storage.Items 
(
    StorageItemId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageId INTEGER NOT NULL,
    ItemId INTEGER NOT NULL,
    Slot INTEGER NOT NULL,
    Amount INTEGER NOT NULL,
    Empty BOOLEAN NOT NULL DEFAULT('1')
);

CREATE TABLE IF NOT EXISTS Storage.ItemMetaData
(
    StorageItemMetaDataId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageItemId INTEGER NOT NULL,
    StorageItemMetaData JSONB,
    Deleted BOOLEAN NOT NULL DEFAULT('f')
);

CREATE TABLE IF NOT EXISTS Storage.Drop
(
    StorageDropId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageId INTEGER NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL,
    Active BOOLEAN NOT NULL DEFAULT('0')
);

CREATE TABLE IF NOT EXISTS Storage.Vehicle
(
    StorageVehicleId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageId INTEGER NOT NULL,
    Plate VARCHAR(10) NOT NULL
);

CREATE SCHEMA Item;

CREATE TABLE IF NOT EXISTS Item.Items
(
    ItemId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemTypeId INTEGER NOT NULL,
    ItemName VARCHAR(32) NOT NULL,
    ItemWeight REAL NOT NULL,
    ItemMaxStack INTEGER NOT NULL DEFAULT(1)
);

CREATE TABLE IF NOT EXISTS Item.Types
(
    ItemTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemType VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS Item.ModifierTypes
(
    ItemModifierTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemModifierTypeName VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS Item.Modifiers
(
    ItemModifierId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemModifierTypeId INTEGER NOT NULL,
    ItemId INTEGER NOT NULL,
    ItemModifier REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS Item.Weapons
(
    ItemWeaponId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemId INTEGER NOT NULL,
    ItemWeaponModel VARCHAR(32) NOT NULL,
    ItemWeaponHash INTEGER NOT NULL,
    AmmoItemId INTEGER NOT NULL DEFAULT(0),
    ItemUsesAmmo BOOLEAN NOT NULL DEFAULT('f'),
    ItemAlertsCops BOOLEAN NOT NULL DEFAULT('f'),
    GenerateMetaData BOOLEAN NOT NULL DEFAULT('f')
);

CREATE SCHEMA Licensing;

CREATE TABLE IF NOT EXISTS Licensing.LicenseTypes
(
    LicenseTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    LicenseTypeName VARCHAR(32) NOT NULL
);

CREATE SCHEMA Weapon;

CREATE TABLE IF NOT EXISTS Weapon.Serials
(
    WeaponSerialId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemId INTEGER NOT NULL,
    CharacterIdRegistration INTEGER NOT NULL,
);

CREATE SCHEMA Blip;

CREATE TABLE IF NOT EXISTS Blip.Blips
(
    BlipId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    BlipType INTEGER NOT NULL,
    BlipColor INTEGER NOT NULL,
    BlipName VARCHAR(32) NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL,
    Static BOOLEAN NOT NULL DEFAULT('1'),
    Deleted BOOLEAN NOT NULL DEFAULT('0')
);

CREATE SCHEMA Customization;

CREATE TABLE IF NOT EXISTS Customization.Points
(
    CustomizationPointId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CustomizationTypeId INTEGER NOT NULL,
    CustomizationName VARCHAR(128) NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS Customization.Types
(
    CustomizationTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CustomizationTypeName VARCHAR(128) NOT NULL
);

CREATE SCHEMA Store;

CREATE TABLE IF NOT EXISTS Store.Stores
(
    StoreId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StoreTypeId INTEGER NOT NULL,
    StoreName VARCHAR(128) NOT NULL,
    X REAL NOT NULL,
    Y REAL NOT NULL,
    Z REAL NOT NULL,
    OpenTime TIME NOT NULL DEFAULT('00:00:00'),
    CloseTime TIME NOT NULL DEFAULT('00:00:00')
);

CREATE TABLE IF NOT EXISTS Store.Types
(
    StoreTypeId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StoreTypeName VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS Store.SellItems
(
    StoreSellItemId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StoreTypeId INTEGER NOT NULL,
    ItemId INTEGER NOT NULL,
    ItemSellPrice INTEGER NOT NULL,
    RequiredItemId INTEGER NOT NULL DEFAULT(0)
);

CREATE TABLE IF NOT EXISTS Store.BuyItems
(
    StoreBuyItemId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StoreTypeId INTEGER NOT NULL,
    ItemId INTEGER NOT NULL,
    ItemBuyPrice INTEGER NOT NULL
);

CREATE SCHEMA Command;

CREATE TABLE IF NOT EXISTS Command.PlayerTypePermissions
(
    PlayerTypePermissionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    PlayerTypeId INTEGER NOT NULL,
    Permission VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS Command.GroupPermissions
(
    GroupPermissionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupId INTEGER NOT NULL,
    Permission VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS Command.GroupRankPermissions
(
    GroupRankPermissionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    GroupRankId INTEGER NOT NULL,
    Permission VARCHAR(128)
);
