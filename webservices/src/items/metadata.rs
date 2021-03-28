
use serde::{Deserialize, Serialize};
use crate::db_postgres;

use crate::items::weapon_metadata;

pub fn create_metadata(character_id: i32, item_id:i32, storage_item_id: i32, client: &mut postgres::Client) {

    let weapon_type_id = 3;

    let row = client.query_one("SELECT ItemTypeId FROM Item.Items WHERE ItemId = $1", &[&item_id]).unwrap();
    let item_type_id: i32 = row.get("ItemTypeId");

    if item_type_id == weapon_type_id {

        weapon_metadata::create_weapon_metadata(character_id, storage_item_id, client);

    }

}