
use serde::{Deserialize, Serialize};
use crate::db_postgres;

use serde_json::{json};

use crate::storage;

fn get_next_weapon_serial(item_id: i32, character_id: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("INSERT INTO Weapon.Serials (ItemId, CharacterIdRegistration) VALUES ($1, $2) RETURNING WeaponSerialId", &[&item_id, &character_id]).unwrap();
    return row.get("WeaponSerialId");

}

pub fn create_weapon_metadata(character_id: i32, item_id: i32, storage_item_id: i32, client: &mut postgres::Client) {

    let row = client.query_one("SELECT GenerateMetaData FROM Item.Weapons WHERE ItemId = $1", &[&item_id]).unwrap();
    let should_generate_metadata: bool = row.get("GenerateMetaData");

    if !should_generate_metadata {
        return;
    }

    let storage_id = storage::create_storage("Weapon".to_string(), client);
    let serial_number = get_next_weapon_serial(item_id, character_id, client);

    let metadata = json!({
        "visible": {
            "serial_number": format!("GKU7G{}", serial_number),
        },
        "hidden": {
            "storage_id": storage_id,
            "character_id_registration": character_id
        }
    });
    client.execute("INSERT INTO Storage.ItemMetaData (StorageItemId, StorageItemMetaData) VALUES ($1, $2)", &[&storage_item_id, &metadata]).unwrap();

}