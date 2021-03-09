
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

-- Specific commands a Player.Type can run. Might be useless.
CREATE TABLE IF NOT EXISTS Player.TypePermissions
(
    PlayerTypePermissionId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    PlayerTypeId INTEGER NOT NULL,
    Permission VARCHAR(128)
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

-- TODO
CREATE TABLE IF NOT EXISTS Character.Outfits
(
    CharacterOutfitId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    OutfitName VARCHAR(64) NOT NULL,
    Outfit JSONB
);

CREATE TABLE IF NOT EXISTS Character.Jobs
(
    CharacterJobId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    CharacterId INTEGER NOT NULL,
    JobId INTEGER NOT NULL,
    ClockedOn BIT NOT NULL DEFAULT(0)
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

CREATE SCHEMA Job;

/* Look into */
CREATE TABLE IF NOT EXISTS Job.Type
(
    JobId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    JobFieldId INTEGER NOT NULL,
    Rank VARCHAR(64) NOT NULL,
    Pay INTEGER NOT NULL,
    Paygrade INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Job.Field
(
    JobFieldId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    JobFieldName VARCHAR(64) NOT NULL
);
/* Look into */

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
    Deleted BIT NOT NULL
);

CREATE TABLE IF NOT EXISTS Storage.ItemMetaData
(
    StorageItemMetaDataId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StorageItemId INTEGER NOT NULL,
    StorageItemMetaData JSONB
);

CREATE SCHEMA Item;

CREATE TABLE IF NOT EXISTS Item.Items
(
    ItemId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemTypeId INTEGER NOT NULL,
    ItemName VARCHAR(32) NOT NULL,
    ItemPng VARCHAR(64) NOT NULL,
    ItemWeight REAL NOT NULL
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
    ItemModifier INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Item.Weapons
(
    ItemWeaponId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    ItemId INTEGER NOT NULL,
    ItemWeaponModel VARCHAR(32) NOT NULL,
    ItemWeaponHash INTEGER NOT NULL,
    ItemUsesAmmo BIT NOT NULL,
    ItemAlertsCops BIT NOT NULL
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
    Static BOOLEAN NOT NULL DEFAULT('1')
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
    ItemId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Store.BuyItems
(
    StoreBuyItemId INTEGER GENERATED BY DEFAULT AS IDENTITY,
    StoreTypeId INTEGER NOT NULL,
    ItemId INTEGER NOT NULL
);