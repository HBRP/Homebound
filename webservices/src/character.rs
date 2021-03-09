
use serde::{Deserialize, Serialize};
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
    for row in client.query("SELECT CharacterId, FirstName, LastName, DOB, Gender FROM Player.Characters WHERE PlayerId = $1 AND Deleted = 'f'", &[&player.player_id]).unwrap() {

        all_characters.characters.push(Character {

            character_id : row.get("CharacterId"),
            first_name   : row.get("FirstName"),
            last_name    : row.get("LastName"),
            dob          : row.get("DOB"),
            gender       : row.get("Gender")

        });
    }
    serde_json::to_string(&all_characters).unwrap()

}

fn get_character_position_struct(character: CharacterId) -> Position {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT CharacterId, X, Y, Z, Heading FROM Character.Positions WHERE CharacterId = $1", &[&character.character_id]).unwrap();
    Position {
        x: row.get("X"),
        y: row.get("Y"),
        z: row.get("Z"),
        heading: row.get("Heading")
    }

}

pub fn get_character_position(character: CharacterId) -> String {

    let position = get_character_position_struct(character);
    serde_json::to_string(&position).unwrap()

}

pub fn get_character_info(character: CharacterId) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let position = get_character_position_struct(character);
    "".to_string()

}

pub fn get_character_health(character: CharacterId) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT * FROM Character.Health WHERE CharacterId = $1", &[&character.character_id]).unwrap();
    let health = Health {
        hunger: row.get("Hunger"),
        thirst: row.get("Thirst")
    };
    serde_json::to_string(&health).unwrap()

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