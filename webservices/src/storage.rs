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
    item_type_id: i32,
    storage_item_id: i32,
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
    storage_max_slots: i32,
    storage_items: Vec<StorageItems>

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ItemMoveRequest {

    old_storage_id: i32,
    old_storage_item_id: i32,
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
    storage_item_id: i32,
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

#[derive(Serialize, Deserialize, Debug)]
pub struct NearbyStashRequest {

    x: f32,
    y: f32,
    z: f32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct Stash {

    storage_id: i32,
    x: f32,
    y: f32,
    z: f32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetVehicleStorageIdResponse {

    storage_id: i32

}

fn get_storage(storage_request: GetStorageRequest) -> String {

      let mut client = db_postgres::get_connection().unwrap();

    let mut storage_response = GetStorageResponse {
        response: Response {
            success: false,
            message: "".to_string()
        },
        storage_id: storage_request.storage_id,
        storage_max_slots: get_storage_max_slots(storage_request.storage_id, &mut client),
        storage_items: Vec::new()

    };
    for row in client.query(
        "
            SELECT SI.ItemId, II.ItemTypeId, SI.StorageItemId, II.ItemName, SI.Slot, SI.Amount 
            FROM Storage.Items SI 
            INNER JOIN Item.Items II ON II.ItemId = SI.ItemId
            WHERE 
                SI.StorageId = $1 AND SI.Empty = 'f'
        ", &[&storage_request.storage_id]).unwrap() {

        storage_response.storage_items.push(StorageItems {

            item_id: row.get("ItemId"),
            item_type_id: row.get("ItemTypeId"),
            storage_item_id: row.get("StorageItemId"),
            item_name: row.get("ItemName"),
            slot: row.get("Slot"),
            amount: row.get("Amount")

        });

    }
    storage_response.response.success = true;
    serde_json::to_string(&storage_response).unwrap()  
}

#[post("/Storage/Get", format = "json", data = "<storage_request>")]
pub fn get_storage_request(storage_request: Json<GetStorageRequest>) -> String {

    get_storage(storage_request.into_inner())

}

fn transfer_metadata(created_storage_item_id: i32, storage_item_id: i32, client: &mut postgres::Client) {

    client.execute("UPDATE Storage.ItemMetaData SET StorageItemId = $1 WHERE StorageItemId = $2", &[&created_storage_item_id, &storage_item_id]).unwrap();

}

fn get_item_max_stack(item_id: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("SELECT ItemMaxStack FROM Item.Items WHERE ItemId = $1", &[&item_id]).unwrap();
    return row.get("ItemMaxStack");

}

fn does_slot_exist(storage_id: i32, slot: i32, client: &mut postgres::Client) -> bool {

    let row = client.query_one("SELECT StorageItemId FROM Storage.Items WHERE StorageId = $1 AND Slot = $2;", &[&storage_id, &slot]);
    match row {
        Ok(_) => return true,
        Err(_) => return false
    }

}

fn create_slot(storage_id: i32, slot: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("INSERT INTO Storage.Items (StorageId, ItemId, Slot, Amount) VALUES ($1, 0, $2, 0) RETURNING StorageItemId;", &[&storage_id, &slot]).unwrap();
    return row.get("StorageItemId");

}

fn get_existing_storage_item_id(storage_id: i32, slot: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("SELECT StorageItemId FROM Storage.Items WHERE StorageId = $1 AND Slot = $2;", &[&storage_id, &slot]).unwrap();
    return row.get("StorageItemId");

}

fn set_storage_item(storage_item_id: i32, item_id: i32, amount: i32, client: &mut postgres::Client) {

    client.execute("UPDATE Storage.Items SET Amount = $1, ItemId = $2, Empty = 'f' WHERE StorageItemId = $3", &[&amount, &item_id, &storage_item_id]).unwrap();
    client.execute("UPDATE Storage.Items SET Empty = 't' WHERE StorageItemId = $1 AND Amount = 0", &[&storage_item_id]).unwrap();

}

fn change_item_amount(storage_item_id: i32, amount: i32, client: &mut postgres::Client) {

    client.execute("UPDATE Storage.Items SET amount = amount + $1 WHERE StorageItemId = $2", &[&amount, &storage_item_id]).unwrap();
    client.execute("UPDATE Storage.Items SET Empty = 't' WHERE StorageItemId = $1 AND Amount = 0", &[&storage_item_id]).unwrap();

}

fn get_storage_max_slots(storage_id: i32,  client: &mut postgres::Client) -> i32 {

    let row = client.query_one(
        "
            SELECT 
                 StorageTypeSlots
            FROM 
                Storage.Containers SC
            INNER JOIN Storage.Types ST ON ST.StorageTypeId = SC.StorageTypeId
            WHERE 
                SC.StorageId = $1
        ", &[&storage_id]).unwrap();

    return row.get("StorageTypeSlots");

}

fn switch_storage_spots(storage_move_request: &ItemMoveRequest, other_storage_item_id: i32, client: &mut postgres::Client) -> String {

    let mut response = StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    };

    let row = client.query_one("SELECT Amount FROM Storage.Items WHERE StorageItemId = $1", &[&storage_move_request.old_storage_item_id]).unwrap();
    let amount_in_original_spot: i32 = row.get("Amount");

    if amount_in_original_spot == storage_move_request.amount {

        let row = client.query_one("SELECT ItemId, Amount FROM Storage.Items WHERE StorageItemId = $1", &[&other_storage_item_id]).unwrap();
        let other_item_id: i32 = row.get("ItemId");
        let other_amount: i32  = row.get("Amount");

        set_storage_item(other_storage_item_id, storage_move_request.item_id, storage_move_request.amount, client);
        set_storage_item(storage_move_request.old_storage_item_id, other_item_id, other_amount, client);

        transfer_metadata(other_storage_item_id, storage_move_request.old_storage_item_id, client);
        transfer_metadata(storage_move_request.old_storage_item_id, other_storage_item_id, client);

    } else {

        response.response.success = false;
        response.response.message = "Unable to move partial stack into other, non similar stack".to_string();

    }

    return serde_json::to_string(&response).unwrap();
}

fn update_storage_slot(storage_move_request: &ItemMoveRequest, other_item_id: i32, other_storage_amount: i32, other_storage_item_id: i32, client: &mut postgres::Client) -> String {

    let mut response = StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    };

    let item_max_stack = get_item_max_stack(other_item_id, client);
    if other_storage_amount + storage_move_request.amount <= item_max_stack {

        change_item_amount(other_storage_item_id, storage_move_request.amount, client);
        change_item_amount(storage_move_request.old_storage_item_id, -storage_move_request.amount, client);

    } else {

        response.response.success = false;
        response.response.message = "Unable to move into full stack".to_string();

    }
    return serde_json::to_string(&response).unwrap();

}

fn get_amount_in_storage_item_id(storage_item_id: i32, client: &mut postgres::Client) -> i32 {


    let row = client.query_one("SELECT Amount FROM Storage.Items WHERE StorageItemId = $1", &[&storage_item_id]).unwrap();
    return row.get("Amount")

}

#[post("/Storage/Move", format = "json", data = "<storage_move_request>")]
pub fn move_storage_item(storage_move_request: Json<ItemMoveRequest>) -> String {

    let storage_move_request = storage_move_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();

    let real_amount_in_slot = get_amount_in_storage_item_id(storage_move_request.old_storage_item_id, &mut client);
    if real_amount_in_slot < storage_move_request.amount {

        let response = StorageResponse {
            response: Response {
                success: false,
                message: "Not enough items in slot".to_string()
            }
        };
        return serde_json::to_string(&response).unwrap();

    }

    let row = client.query_one("SELECT StorageItemId, ItemId, Amount, Empty FROM Storage.Items WHERE StorageId = $1 AND Slot = $2", &[&storage_move_request.new_storage_id, &storage_move_request.new_slot_id]);
    match row {
        Ok(row) => {

            let other_item_id: i32 = row.get("ItemId");
            let other_storage_item_id: i32 = row.get("StorageItemId");
            let other_storage_amount: i32 = row.get("Amount");
            let empty: bool = row.get("Empty");

            if empty {

                set_storage_item(other_storage_item_id, storage_move_request.item_id, storage_move_request.amount, &mut client);
                change_item_amount(storage_move_request.old_storage_item_id, -storage_move_request.amount, &mut client);

            } else if other_item_id == storage_move_request.item_id {

                return update_storage_slot(&storage_move_request, other_item_id, other_storage_amount, other_storage_item_id, &mut client);

            } else {

                return switch_storage_spots(&storage_move_request, other_storage_item_id, &mut client);

            }

        },
        Err(_err) => {

            let created_storage_item_id = create_slot(storage_move_request.new_storage_id, storage_move_request.new_slot_id, &mut client);

            set_storage_item(created_storage_item_id, storage_move_request.item_id, storage_move_request.amount, &mut client);
            transfer_metadata(created_storage_item_id, storage_move_request.old_storage_item_id, &mut client);
            change_item_amount(storage_move_request.old_storage_item_id, -storage_move_request.amount, &mut client);

        }

    }

    let response = StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    };
    return serde_json::to_string(&response).unwrap();

}

fn get_empty_slot(storage_id: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("select storage.get_empty_slot($1) as Slot;", &[&storage_id]);

    match row {
        Ok(row) => {
            if row.is_empty() {
                return -1;
            }
            return row.get("Slot");
        },
        Err(err) => { println!("{:?}", err); return -1; }
    };

}

fn can_give_item_in_slot(item_give_request: &ItemGiveRequest, client: &mut postgres::Client) -> bool {

    let row = client.query_one("SELECT Amount, ItemId, Empty FROM Storage.Items WHERE StorageId = $1 AND Slot = $2", &[&item_give_request.storage_id, &item_give_request.slot]);

    match row {

        Ok(row) => {

            let slot_empty: bool = row.get("Empty");
            if slot_empty {
                return true;
            }

            let max_stack = get_item_max_stack(item_give_request.item_id, client);
            let slot_item_id: i32 = row.get("ItemId");
            let slot_amount: i32  = row.get("Amount");

            if slot_amount + item_give_request.amount > max_stack {
                return false;
            }
            if slot_item_id !=  item_give_request.item_id {
                return false;
            }

        },
        Err(_) => {
            return true;
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

    if !does_slot_exist(item_give_request.storage_id, slot, &mut client) {
        create_slot(item_give_request.storage_id, slot, &mut client);
    }

    let storage_item_id = get_existing_storage_item_id(item_give_request.storage_id, slot, &mut client);
    set_storage_item(storage_item_id, item_give_request.item_id, item_give_request.amount,  &mut client);
    give_response.storage_item_id = storage_item_id;

    if item_give_request.storage_item_id != -1 {
        transfer_metadata(give_response.storage_item_id, item_give_request.storage_item_id, &mut client);
    }

    give_response.response.success = true;
    return serde_json::to_string(&give_response).unwrap();

}

#[post("/Storage/Remove", format = "json", data = "<item_remove_request>")]
pub fn remove_storage_item(item_remove_request: Json<ItemRemoveRequest>) -> String {

    let item_remove_request = item_remove_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();
    change_item_amount(item_remove_request.storage_item_id, -item_remove_request.amount, &mut client);

    return serde_json::to_string(&StorageResponse {
        response: Response {
            success: true,
            message: "".to_string()
        }
    }).unwrap();

}

#[get("/Storage/NearbyStashes/<x>/<y>/<z>")]
pub fn get_nearby_stashes(x: f32, y: f32, z: f32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut stashes: Vec<Stash> = Vec::new();

    for row in client.query("SELECT StorageId, X, Y, Z FROM Storage.Stashes WHERE SQRT(POWER(X - $1, 2) + POWER(Y - $2, 2) + POWER(Z - $3, 2)) < 250;", &[&x, &y, &z]).unwrap() {

        stashes.push(Stash {

            storage_id: row.get("StorageId"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z")

        });

    }
    serde_json::to_string(&stashes).unwrap()

}

fn create_vehicle_storage(plate: String, storage_id: i32, client: &mut postgres::Client) {

    client.execute("INSERT INTO Storage.Vehicle (StorageId, Plate) VALUES ($1, $2)", &[&storage_id, &plate]).unwrap();

}

pub fn create_storage(storage_type_name: String,  client: &mut postgres::Client) -> i32 {

    let row = client.query_one(
        "INSERT INTO 
            Storage.Containers (StorageTypeId)
        SELECT  
            ST.StorageTypeId
        FROM Storage.Types ST
        WHERE 
            ST.StorageTypeName = $1
        RETURNING StorageId;", 
    &[&storage_type_name]).unwrap();
    return row.get("StorageId");

}


#[get("/Storage/VehicleStorage/<plate>/<location>")]
pub fn get_vehicle_storage(plate: String, location: String) -> String {

    let mut client = db_postgres::get_connection().unwrap();

    let row = client.query_one(
        "
            SELECT SV.StorageId 
            FROM Storage.Vehicle SV
            INNER JOIN Storage.Containers SC ON SC.StorageId = SV.StorageId
            INNER JOIN Storage.Types ST ON ST.StorageTypeId = SC.StorageTypeId
            WHERE 
                SV.Plate = $1 AND ST.StorageTypeName = $2
            LIMIT 1;"
        , &[&plate, &location]);

    match row {
        Ok(row) => {
            return get_storage(GetStorageRequest {
                storage_id: row.get("StorageId")
            })
        },
        Err(_) => {
            let storage_id = create_storage(location, &mut client);
            create_vehicle_storage(plate, storage_id, &mut client);
            return get_storage(GetStorageRequest {
                storage_id: storage_id
            });
        }
    }
}

#[get("/Storage/VehicleStorageId/<plate>/<location>")]
pub fn get_vehicle_storage_id(plate: String, location: String) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut vehicle_storage_id_response = GetVehicleStorageIdResponse {
        storage_id: 0
    };

    let row = client.query_one(
        "
            SELECT SV.StorageId 
            FROM Storage.Vehicle SV
            INNER JOIN Storage.Containers SC ON SC.StorageId = SV.StorageId
            INNER JOIN Storage.Types ST ON ST.StorageTypeId = SC.StorageTypeId
            WHERE 
                SV.Plate = $1 AND ST.StorageTypeName = $2
            LIMIT 1;"
        , &[&plate, &location]);

    match row {
        Ok(row) => {

            vehicle_storage_id_response.storage_id = row.get("StorageId")

        },
        Err(_) => {

            let storage_id = create_storage(location, &mut client);
            create_vehicle_storage(plate, storage_id, &mut client);
            vehicle_storage_id_response.storage_id = storage_id

        }
    }
    serde_json::to_string(&vehicle_storage_id_response).unwrap()
    
}