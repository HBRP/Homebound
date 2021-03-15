use serde::{Deserialize, Serialize};
use crate::db_postgres;

use rocket_contrib::json::Json;

#[derive(Serialize, Deserialize, Debug)]
pub struct Response {

    success: bool,
    message: String

}


#[derive(Serialize, Deserialize, Debug)]
pub struct StorageItems {

    item_id: i32,
    item_name: String,
    slot: i32,
    amount: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetStorageRequest {

    storage_id: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetStorageResponse {

    response: Response,
    storage_id: i32,
    storage_items: Vec<StorageItems>

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ItemMoveRequest {

    storage_id: i32,
    storage_item_id: i32,
    new_storage_id: i32,
    new_slot_id: i32,
    item_id: i32,
    amount: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ItemGiveRequest {

    storage_id: i32,
    item_id: i32,
    slot: i32,
    amount: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ItemGiveResponse {

    response: Response,
    storage_item_id: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ItemRemoveRequest {

    storage_item_id: i32,
    amount: i32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StorageResponse {

    response: Response

}


#[post("/Storage/Get", format = "json", data = "<storage_request>")]
pub fn get_storage(storage_request: Json<GetStorageRequest>) -> String {

    let storage_request = storage_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();

    let mut storage_response = GetStorageResponse {
        response: Response {
            success: false,
            message: "".to_string()
        },
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
    storage_response.response.success = true;
    serde_json::to_string(&storage_response).unwrap()

}

fn remove_item(storage_item_id: i32, amount: i32, client: &mut postgres::Client) {

    client.execute("UPDATE Storage.Items SET amount = amount - $1 WHERE StorageItemId = $2", &[&amount, &storage_item_id]).unwrap();
    client.execute("UPDATE Storage.Items SET Deleted = 't' WHERE StorageItemId = $1 AND Amount = 0", &[&storage_item_id]).unwrap();

}

fn get_item_max_stack(item_id: i32, client: &mut postgres::Client) -> i32 {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT ItemMaxStack FROM Item.Items WHERE ItemId = $1", &[&item_id]).unwrap();
    let item_stack_row: i32 = row.get("ItemMaxStack");

    item_stack_row
}

fn switch_storage_spots(storage_move_request: &ItemMoveRequest, other_item_id: i32, other_storage_item_id: i32, other_storage_amount: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();

    let mut response = StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    };

    if other_item_id == storage_move_request.item_id {

        let item_stack_row = get_item_max_stack(other_item_id, &mut client);
        if other_storage_amount + storage_move_request.amount <= item_stack_row {

            client.execute("UPDATE Storage.Items SET Amount = Amount + $1 WHERE StorageItemId = $2", &[&storage_move_request.amount, &other_storage_item_id]).unwrap();
            remove_item(storage_move_request.storage_item_id, storage_move_request.amount, &mut client);

        } else {

            response.response.message = "Unable to move into full stack".to_string();

        }


    } else {

        let row = client.query_one("SELECT Amount FROM Storage.Items WHERE StorageItemId = $1", &[&storage_move_request.storage_item_id]).unwrap();
        let amount_in_original_spot: i32 = row.get("Amount");

        if amount_in_original_spot == storage_move_request.amount {

            client.execute("UPDATE Storage.Items SET Deleted = 't' WHERE StorageItemId = $1 or StorageItemId = $2", &[&other_storage_item_id, &storage_move_request.storage_item_id]).unwrap();
            client.execute("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) SELECT SI.StorageItem, SI.ItemId, SI.Slot, SI.Amount FROM Storage.Items SI WHERE SI.StorageItemId = $1", &[&other_storage_item_id]).unwrap();
            client.execute("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) SELECT SI.StorageItem, SI.ItemId, SI.Slot, SI.Amount FROM Storage.Items SI WHERE SI.StorageItemId = $1", &[&storage_move_request.storage_item_id]).unwrap();

        } else {

            response.response.message = "Unable to move partial stack into other, non similar stack".to_string();

        }

    }
    return serde_json::to_string(&response).unwrap();
}

#[post("/Storage/Move", format = "json", data = "<storage_move_request>")]
pub fn move_storage_item(storage_move_request: Json<ItemMoveRequest>) -> String {

    let storage_move_request = storage_move_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();

    let row = client.query_one("SELECT StorageItemId, ItemId, Amount FROM Storage.Items WHERE StorageId = $1 AND Slot = $2 AND Deleted = '0'", &[&storage_move_request.new_storage_id, &storage_move_request.new_slot_id]).unwrap();
    if row.is_empty() {

        client.execute("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) VALUES ($1, $2, $3, $4)", &[&storage_move_request.new_storage_id, &storage_move_request.item_id, &storage_move_request.new_slot_id, &storage_move_request.amount]).unwrap();
        remove_item(storage_move_request.storage_item_id, storage_move_request.amount, &mut client);

    } else {

        // existing stack in new slow
        let other_item_id: i32 = row.get("ItemId");
        let other_storage_item_id: i32 = row.get("StorageItemId");
        let other_storage_amount: i32 = row.get("Amount");
        return switch_storage_spots(&storage_move_request, other_item_id, other_storage_item_id, other_storage_amount);

    }

    let mut response = StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    };
    return serde_json::to_string(&response).unwrap();

}

fn get_empty_slot(storage_id: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one(
        "
            DO $$ 
            DECLARE 
                    check_slot INTEGER;
                    max_slots  INTEGER;
                    slot_temp  INTEGER;
                    storage_id INTEGER;
            BEGIN
                check_slot := 1;
                storage_id := $1;
                CREATE TEMP TABLE slot_ids(
                    Slot INTEGER NOT NULL
                );

                INSERT INTO slot_ids 
                SELECT SI.Slot FROM Storage.Items SI
                WHERE SI.StorageId = storage_id and SI.deleted ='f';

                SELECT 
                    ST.StorageTypeSlots INTO max_slots 
                    FROM Storage.Containers SC 
                    INNER JOIN Storage.Types ST ON ST.StorageTypeId = SC.StorageTypeId 
                    WHERE SC.StorageId = storage_id
                    LIMIT 1;
                
                LOOP
                    SELECT Slot INTO slot_temp FROM slot_ids WHERE Slot = check_slot LIMIT 1;
                    IF slot_temp IS NULL THEN
                        CREATE TABLE slot AS SELECT check_slot AS Slot;
                        EXIT;
                    END IF;
                
                    check_slot := check_slot + 1;
                    
                    IF check_slot > max_slots THEN
                        CREATE TABLE slot (Slot INTEGER NOT NULL);
                        EXIT;
                    END IF;
                END LOOP;
            END $$;
            
            SELECT * FROM slot;
            DROP TABLE slot_ids;
            DROP TABLE slot;
        ", &[&storage_id]);

    match row {
        Ok(row) => {
            if row.is_empty() {
                return -1;
            }
            return row.get("Slot");
        },
        Err(_) => return -1
    };

}

fn can_give_item_in_slot(item_give_request: &ItemGiveRequest, client: &mut postgres::Client) -> bool {

    let row = client.query_one("SELECT Amount, ItemId FROM Storage.Items WHERE StorageId = $1 AND Slot = $2 AND Deleted = 'f'", &[&item_give_request.storage_id, &item_give_request.slot]).unwrap();
    if row.is_empty() {

        return true;

    } else {

        let max_stack = get_item_max_stack(item_give_request.item_id, client);
        let slot_item_id: i32 = row.get("ItemId");
        let slot_amount: i32  = row.get("Amount");
        if slot_amount + item_give_request.amount > max_stack {
            return false;
        }
        if slot_item_id != item_give_request.item_id {
            return false;
        }

    }

    return true;

}

#[post("/Storage/Give", format = "json", data = "<item_give_request>")]
pub fn give_storage_item(item_give_request: Json<ItemGiveRequest>) -> String {

    let item_give_request = item_give_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();

    let slot;
    let mut give_response = ItemGiveResponse {
        response: Response {
            success: false,
            message: "".to_string()
        },
        storage_item_id: -1
    };

    if item_give_request.slot == -1 || !can_give_item_in_slot(&item_give_request, &mut client) {

        slot = get_empty_slot(item_give_request.storage_id, &mut client);
        if slot == -1 {
            give_response.response.message = "Could not find empty slot".to_string();
            return serde_json::to_string(&give_response).unwrap();
        }

    } else {

        slot = item_give_request.slot;

    }

    let row = client.query_one("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) VALUES ($1, $2, $3, $4) RETURNING StorageItemId;", &[&item_give_request.storage_id, &item_give_request.item_id, &slot, &item_give_request.amount]).unwrap();

    give_response.storage_item_id  = row.get("StorageItemId");
    give_response.response.success = true;
    return serde_json::to_string(&give_response).unwrap();

}

#[post("/Storage/Remove", format = "json", data = "<item_remove_request>")]
pub fn remove_storage_item(item_remove_request: Json<ItemRemoveRequest>) -> String {

    let item_remove_request = item_remove_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();
    remove_item(item_remove_request.storage_item_id, item_remove_request.amount, &mut client);

    return serde_json::to_string(&StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    }).unwrap();

}