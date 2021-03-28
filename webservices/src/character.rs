
use serde::{Deserialize, Serialize};
use serde_json::{json};
use crate::db_postgres;
use crate::player;

#[derive(Serialize, Deserialize, Debug)]
pub struct CreateCharacter {

    player_id: i32,
    first_name: String,
    last_name: String,
    dob: String,
    gender: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct Character {

    character_id: i32,
    storage_id: i32,
    first_name: String,
    last_name: String,
    dob: String,
    gender: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct Characters {

    pub characters: Vec<Character>

}

#[derive(Serialize, Deserialize, Debug)]
struct Position {

    x: f32,
    y: f32,
    z: f32,
    heading: f32

}

#[derive(Serialize, Deserialize, Debug)]
struct Health {

    hunger: i32,
    thirst: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterPosition {

    character_id: i32,
    position: Position

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterHealth {

    character_id: i32,
    health: Health

}

#[derive(Serialize, Deserialize, Debug)]
struct CharacterInfo {

    character: Character,
    position: Position,
    health: String,

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterId {

    character_id: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CreateCharacterOutfit {

    character_id: i32,
    outfit_name: String,
    outfit: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterOutfit {

    character_outfit_id: i32,
    character_id: i32,
    outfit_name: String,
    outfit: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterOutfitId {

    character_outfit_id: i32,

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterOutfitUpdate {

    character_outfit_id: i32,
    outfit_name: String,
    outfit: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct OutfitMetaData {

    character_outfit_id: i32,
    outfit_name: String,
    active_outfit: bool

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterSkin {

    character_skin: String,

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterCreateSkin {

    character_id: i32,
    character_skin: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CharacterUpdateSkin {

    character_id: i32,
    character_skin: String

}


pub fn create(character: CreateCharacter) -> String {

    let mut client   = db_postgres::get_connection().unwrap();
    let character_id = create_character_entry(&mut client, &character);
    create_default_entries(&mut client, &character_id);
    serde_json::to_string(&CharacterId { character_id }).unwrap()

}

fn create_character_entry(client: &mut postgres::Client, character: &CreateCharacter) -> i32 {

    let row = client.query_one("INSERT INTO Player.Characters (PlayerId, FirstName, LastName, DOB, Gender) VALUES ($1, $2, $3, $4, $5) RETURNING CharacterId", &[&character.player_id, &character.first_name, &character.last_name, &character.dob, &character.gender]).unwrap();
    let character_id = row.get("CharacterId");
    character_id

}

fn create_default_entries(client: &mut postgres::Client, character_id: &i32) {

    client.execute("INSERT INTO Character.Positions (CharacterId) VALUES ($1)", &[&character_id]).unwrap();
    client.execute("INSERT INTO Character.Health (CharacterId) VALUES ($1)", &[&character_id]).unwrap();

    let row = client.query_one("INSERT INTO Bank.Account (AccountName, Funds) VALUES ('Bank', 1000) RETURNING BankAccountId", &[]).unwrap();
    let bank_account_id: i32 = row.get("BankAccountId");

    client.execute("INSERT INTO Bank.AccountOwner (BankAccountId, CharacterId) VALUES ($1, $2)", &[&bank_account_id, &character_id]).unwrap();
    client.execute("INSERT INTO Character.BankAccount (CharacterId, BankAccountId) VALUES ($1, $2)", &[&character_id, &bank_account_id]).unwrap();

    let row = client.query_one(
        "INSERT INTO 
            Storage.Containers (StorageTypeId)
        SELECT  
            ST.StorageTypeId
        FROM Storage.Types ST
        WHERE 
            ST.StorageTypeName = 'Player Inventory'
        RETURNING StorageId;", 
    &[]).unwrap();

    let storage_id: i32 = row.get("StorageId");

    client.execute("INSERT INTO Character.Inventory (CharacterId, StorageId) VALUES ($1, $2)", &[&character_id, &storage_id]).unwrap();

}


pub fn get_characters(player: player::Player) -> String  {

    let mut client = db_postgres::get_connection().unwrap();
    let mut all_characters = Characters {
        characters: Vec::new()
    };
    for row in client.query(
            "
                SELECT PC.CharacterId, CI.StorageId, PC.FirstName, PC.LastName, PC.DOB, PC.Gender
                FROM 
                    Player.Characters PC
                INNER JOIN Character.Inventory CI ON CI.CharacterId = PC.CharacterId
                WHERE PC.PlayerId = $1 AND PC.Deleted = 'f'
            ", &[&player.player_id]).unwrap() {

        all_characters.characters.push(Character {

            character_id : row.get("CharacterId"),
            storage_id   : row.get("StorageId"),
            first_name   : row.get("FirstName"),
            last_name    : row.get("LastName"),
            dob          : row.get("DOB"),
            gender       : row.get("Gender")

        });
    }
    serde_json::to_string(&all_characters).unwrap()

}

fn get_character_position_struct(character: &CharacterId) -> Position {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT CharacterId, X, Y, Z, Heading FROM Character.Positions WHERE CharacterId = $1", &[&character.character_id]).unwrap();
    Position {
        x: row.get("X"),
        y: row.get("Y"),
        z: row.get("Z"),
        heading: row.get("Heading")
    }

}

fn get_character(character: &CharacterId) -> Character {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one(
            "
                SELECT PC.CharacterId, CI.StorageId, PC.FirstName, PC.LastName, PC.DOB, PC.Gender 
                FROM Player.Characters PC
                INNER JOIN Character.Inventory CI ON CI.CharacterId = PC.CharacterId
                WHERE PC.CharacterId = $1
            ", &[&character.character_id]).unwrap();
    Character {        
        character_id : row.get("CharacterId"),
        storage_id   : row.get("StorageId"),
        first_name   : row.get("FirstName"),
        last_name    : row.get("LastName"),
        dob          : row.get("DOB"),
        gender       : row.get("Gender")
    }
}

pub fn get_character_info(character: CharacterId) -> String {
    
    let position       = get_character_position_struct(&character);
    let temp_character = get_character(&character);
    let character_info = CharacterInfo {
        character: temp_character,
        position: position,
        health: "".to_string()
    };
    serde_json::to_string(&character_info).unwrap()

}

pub fn set_character_position(position: CharacterPosition) {

    let mut client   = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Character.Positions SET X = $1, Y = $2, Z = $3, Heading = $4 WHERE CharacterId = $5", &[&position.position.x, &position.position.y, &position.position.z, &position.position.heading, &position.character_id]).unwrap();

}

pub fn set_character_health(health: CharacterHealth) {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Character.Health SET Hunger = $1, Thirst = $2 WHERE CharacterId = $3", &[&health.health.hunger, &health.health.thirst, &health.character_id]).unwrap();

}

pub fn delete_character(character: CharacterId) {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Character.Health SET Deleted = 't' WHERE CharacterId = $1", &[&character.character_id]).unwrap();

}

pub fn enable_character(character: CharacterId) {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Character.Health SET Deleted = 'f' WHERE CharacterId = $1", &[&character.character_id]).unwrap();

}

pub fn create_outfit(outfit: CreateCharacterOutfit) {

    let mut client = db_postgres::get_connection().unwrap();
    let temp_json_blob = json!(outfit.outfit);
    client.execute("UPDATE Character.Outfits SET ActiveOutfit = 'f' WHERE CharacterId = $1", &[&outfit.character_id]).unwrap();
    client.execute("INSERT INTO Character.Outfits (CharacterId, OutfitName, Outfit) VALUES ($1, $2, $3)", &[&outfit.character_id, &outfit.outfit_name, &temp_json_blob]).unwrap();

}

pub fn update_outfit(outfit_update: CharacterOutfitUpdate) {

    let mut client = db_postgres::get_connection().unwrap();
    let temp_json_blob = json!(outfit_update.outfit);
    client.execute("UPDATE Character.Outfits SET OutfitName = $1, Outfit = $2 WHERE CharacterOutfitId = $3", &[&outfit_update.outfit_name, &temp_json_blob, &outfit_update.character_outfit_id]).unwrap();

}

pub fn delete_outfit(outfit_id: CharacterOutfitId) {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("DELETE FROM Character.Outfits WHERE CharacterOutfitId = $1", &[&outfit_id.character_outfit_id]).unwrap();

}

pub fn create_skin(character_skin: CharacterCreateSkin) {

    let mut client = db_postgres::get_connection().unwrap();
    let temp_json_blob = json!(character_skin.character_skin);
    client.execute("INSERT INTO Character.Skin (CharacterId, Skin) VALUES ($1, $2)", &[&character_skin.character_id, &temp_json_blob]).unwrap();

}

pub fn update_skin(character_skin: CharacterUpdateSkin) {

    let mut client = db_postgres::get_connection().unwrap();
    let temp_json_blob = json!(character_skin.character_skin);
    client.execute("UPDATE Character.Skin SET Skin = $1 WHERE CharacterId = $2", &[&temp_json_blob, &character_skin.character_id]).unwrap();

}

pub fn get_skin(character: CharacterId) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("
        SELECT 
            CAST(CS.Skin AS Text) as Skin
        FROM 
            Character.Skin CS
        WHERE
            CS.CharacterId = $1 
        ", &[&character.character_id]).unwrap();
    let character_skin = CharacterSkin {
        character_skin : row.get("Skin")
    };
    serde_json::to_string(&character_skin).unwrap()

}

pub fn get_active_outfit(character: CharacterId) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT CharacterId, CharacterOutfitId, OutfitName, CAST(Outfit AS TEXT) as Outfit FROM Character.Outfits WHERE CharacterId = $1 AND ActiveOutfit = 't'", &[&character.character_id]).unwrap();
    let character_outfit = CharacterOutfit {
        character_id: row.get("CharacterId"),
        character_outfit_id: row.get("CharacterOutfitId"),
        outfit_name: row.get("OutfitName"),
        outfit: row.get("Outfit")
    };
    serde_json::to_string(&character_outfit).unwrap()
    
}

pub fn get_outfit(outfit_id: CharacterOutfitId) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT CharacterId FROM Character.Outfits WHERE CharacterOutfitId = $1", &[&outfit_id.character_outfit_id]).unwrap();
    let character_id = row.get("CharacterId");

    client.execute("UPDATE Character.Outfits SET ActiveOutfit = 'f' WHERE CharacterId = $1", &[&character_id]).unwrap();
    client.execute("UPDATE Character.Outfits SET ActiveOutfit = 't' WHERE CharacterOutfitId = $1", &[&outfit_id.character_outfit_id]).unwrap();
    let row = client.query_one("SELECT CharacterOutfitId, OutfitName, CAST(Outfit AS TEXT) as Outfit FROM Character.Outfits WHERE CharacterOutfitId = $1", &[&outfit_id.character_outfit_id]).unwrap();

    let character_outfit = CharacterOutfit {
        character_id: character_id,
        character_outfit_id: row.get("CharacterOutfitId"),
        outfit_name: row.get("OutfitName"),
        outfit: row.get("Outfit")
    };
    serde_json::to_string(&character_outfit).unwrap()

}

pub fn get_all_outfit_meta_data(character: CharacterId) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut all_outfits = Vec::<OutfitMetaData>::new();

    for row in client.query("SELECT CharacterOutfitId, OutfitName, ActiveOutfit FROM Character.Outfits WHERE CharacterId = $1 ORDER BY CharacterOutfitId", &[&character.character_id]).unwrap() {

        all_outfits.push(OutfitMetaData {
            character_outfit_id: row.get("CharacterOutfitId"),
            outfit_name: row.get("OutfitName"),
            active_outfit: row.get("ActiveOutfit") 
        });

    }
    serde_json::to_string(&all_outfits).unwrap()

}

pub fn get_character_storage_id(character_id: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("SELECT StorageId FROM Character.Inventory WHERE CharacterId = $1", &[&character_id]).unwrap();
    return row.get("StorageId");

}