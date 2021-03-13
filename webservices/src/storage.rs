use serde::{Deserialize, Serialize};
use crate::db_postgres;

use rocket_contrib::json::Json;

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageRequest {

    storage_id: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageItems {

    item_id: i32,
    item_name: String,
    slot: i32,
    amount: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageResponse {

    storage_id: i32,
    storage_items: Vec<StorageItems>

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageMoveRequest {

    storage_id: i32,
    storage_item_id: i32,
    new_storage_id: i32,
    new_slot_id: i32,
    item_id: i32,
    amount: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageGiveRequest {

    storage_id: i32,

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageRemoveRequest {

    storage_id: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageFailureResponse {

    success: bool,
    response: String

}


#[post("/Storage/Get", format = "json", data = "<storage_request>")]
pub fn get_storage(storage_request: Json<StorageRequest>) -> String {

    let storage_request = storage_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();

    let mut storage_response = StorageResponse {
        storage_id: storage_request.storage_id,
        storage_items: Vec::new()

    };
    for row in client.query(
        "
            SELECT ItemId, II.ItemName Slot, Amount 
            FROM Storage.Items SI 
            INNER JOIN Item.Items II ON II.ItemId = SI.ItemId
            WHERE 
                SI.StorageId = $1 AND SI.Deleted = 0
        ", &[&storage_request.storage_id]).unwrap() {

        storage_response.storage_items.push(StorageItems {

            item_id: row.get("ItemId"),
            item_name: row.get("ItemName"),
            slot: row.get("Slot"),
            amount: row.get("Amount")

        });

    }
    serde_json::to_string(&storage_response).unwrap()

}

fn update_original_storage(storage_move_request: &StorageMoveRequest) {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Storage.Items SET amount = amount - $1 WHERE StorageItemId = $2", &[&storage_move_request.amount, &storage_move_request.storage_item_id]).unwrap();
    client.execute("UPDATE Storage.Items SET Deleted = 't' WHERE StorageItemId = $1 AND Amount = 0", &[&storage_move_request.storage_item_id]).unwrap();

}

fn switch_storage_spots(storage_move_request: &StorageMoveRequest, other_item_id: i32, other_storage_item_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();

    let mut response = StorageFailureResponse {
        success: true,
        response: "".to_string()
    };

    if other_item_id == storage_move_request.item_id {

        client.execute("UPDATE Storage.Items SET Amount = Amount + $1 WHERE StorageItemId = $2", &[&storage_move_request.amount, &other_storage_item_id]).unwrap();
        update_original_storage(&storage_move_request);

    } else {

        let row = client.query_one("SELECT Amount FROM Storage.Items WHERE StorageItemId = $1", &[&storage_move_request.storage_item_id]).unwrap();
        let amount_in_original_spot: i32 = row.get("Amount");

        if amount_in_original_spot == storage_move_request.amount {

            client.execute("UPDATE Storage.Items SET Deleted = 't' WHERE StorageItemId = $1 or StorageItemId = $2", &[&other_storage_item_id, &storage_move_request.storage_item_id]).unwrap();
            client.execute("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) SELECT SI.StorageItem, SI.ItemId, SI.Slot, SI.Amount FROM Storage.Items SI WHERE SI.StorageItemId = $1", &[&other_storage_item_id]).unwrap();
            client.execute("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) SELECT SI.StorageItem, SI.ItemId, SI.Slot, SI.Amount FROM Storage.Items SI WHERE SI.StorageItemId = $1", &[&storage_move_request.storage_item_id]).unwrap();

        } else {

            response.response = "Unable to move partial stack into other, non similar stack".to_string();

        }

    }
    return serde_json::to_string(&response).unwrap();
}

#[post("/Storage/Move", format = "json", data = "<storage_move_request>")]
pub fn move_storage_item(storage_move_request: Json<StorageMoveRequest>) -> String {

    let storage_move_request = storage_move_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();

    let row = client.query_one("SELECT StorageItemId, ItemId FROM Storage.Items WHERE StorageId = $1 AND Slot = $2 AND Deleted = '0'", &[&storage_move_request.new_storage_id, &storage_move_request.new_slot_id]).unwrap();
    if row.is_empty() {

        client.execute("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) VALUES ($1, $2, $3, $4)", &[&storage_move_request.new_storage_id, &storage_move_request.item_id, &storage_move_request.new_slot_id, &storage_move_request.amount]).unwrap();
        update_original_storage(&storage_move_request);

    } else {

        let other_item_id: i32 = row.get("ItemId");
        let other_storage_item_id: i32 = row.get("StorageItemId");
        return switch_storage_spots(&storage_move_request, other_item_id, other_storage_item_id);

    }


    let response = StorageFailureResponse {
        success: true,
        response: "".to_string()
    };
    return serde_json::to_string(&response).unwrap();

}