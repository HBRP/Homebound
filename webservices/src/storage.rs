use crate::items::metadata;
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
    amount: i32,
    item_metadata: String

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

    character_id: i32,
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
pub struct StorageLocation {

    storage_id: i32,
    x: f32,
    y: f32,
    z: f32

}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetStorageIdResponse {

    storage_id: i32

}

pub struct PartiallyEmptySlots {
    storage_item_id: i32,
    amount_left_to_give: i32
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
            SELECT 
                SI.ItemId, II.ItemTypeId, SI.StorageItemId, II.ItemName, SI.Slot, SI.Amount, 
                (CASE WHEN SIMD.StorageItemMetaData IS NULL THEN '{}' ELSE SIMD.StorageItemMetaData::TEXT END) as StorageItemMetaData
            FROM Storage.Items SI 
            INNER JOIN Item.Items II ON II.ItemId = SI.ItemId
            LEFT JOIN Storage.ItemMetaData SIMD ON SIMD.StorageItemId = SI.StorageItemId AND SIMD.Deleted = 'f'
            WHERE 
                    SI.StorageId = $1 
                AND SI.Empty = 'f'
        ", &[&storage_request.storage_id]).unwrap() {

        storage_response.storage_items.push(StorageItems {

            item_id: row.get("ItemId"),
            item_type_id: row.get("ItemTypeId"),
            storage_item_id: row.get("StorageItemId"),
            item_name: row.get("ItemName"),
            slot: row.get("Slot"),
            amount: row.get("Amount"),
            item_metadata: row.get("StorageItemMetaData")

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

    client.execute("UPDATE Storage.ItemMetaData SET StorageItemId = $1 WHERE StorageItemId = $2 AND Deleted = 'f'", &[&created_storage_item_id, &storage_item_id]).unwrap();

}

fn swap_metadata(other_storage_item_id: i32, storage_item_id: i32, client: &mut postgres::Client) {

    let row = client.query_one("SELECT StorageItemMetadataId FROM Storage.ItemMetaData WHERE StorageItemId = $1 AND Deleted = 'f'", &[&other_storage_item_id]);

    match row {
        Ok(row) => {

            if !row.is_empty() {
                let temp_storage_item_metadata_id: i32 = row.get("StorageItemMetadataId");
                client.execute("UPDATE Storage.ItemMetaData SET StorageItemId = $1 WHERE StorageItemId = $2 AND Deleted = 'f'", &[&other_storage_item_id, &storage_item_id]).unwrap();
                client.execute("UPDATE Storage.ItemMetaData SET StorageItemId = $1 WHERE StorageItemMetadataId = $2 AND Deleted = 'f'", &[&storage_item_id, &temp_storage_item_metadata_id]).unwrap();
            }

        },
        Err(_) => {
            client.execute("UPDATE Storage.ItemMetaData SET StorageItemId = $1 WHERE StorageItemId = $2 AND Deleted = 'f'", &[&other_storage_item_id, &storage_item_id]).unwrap();
        }
    }

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

fn disable_metadata(storage_item_id: i32, client: &mut postgres::Client) {

    client.execute("UPDATE Storage.ItemMetaData SET Deleted = 't' WHERE StorageItemId = $1", &[&storage_item_id]).unwrap();

}

pub fn is_item_id_in_storage(storage_id: i32, item_id: i32, client: &mut postgres::Client) -> bool {

    let row = client.query_one("SELECT * FROM Storage.Items WHERE StorageId = $1 AND ItemId = $2 AND Empty = 'f' LIMIT 1", &[&storage_id, &item_id]);
    match row {
        Ok(row) => return !row.is_empty(),
        Err(_) => return false
    }

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

fn get_available_space_for_item(storage_id: i32, item_id: i32, client: &mut postgres::Client) -> i32 {

    let row = client.query_one("select storage.get_available_space_for_item($1, $2) as AvailableSpace;", &[&storage_id, &item_id]);
    match row {

        Ok(row) => {
            if row.is_empty() {
                return -1;
            }
            return row.get("AvailableSpace");
        },
        Err(err) => {
            println!("{:?}", err);
            return -1;
        } 

    }

}

fn get_partially_empty_space_for_item(storage_id: i32, item_id: i32, client: &mut postgres::Client) -> Vec<PartiallyEmptySlots> {

    let mut slots: Vec<PartiallyEmptySlots> = Vec::new();

    for row in client.query(
        "
            SELECT 
                SI.StorageItemId, SI.Slot, (II.ItemMaxStack - SI.Amount) as AmountLeft
            FROM 
                Storage.Items SI
            INNER JOIN Item.Items II ON II.ItemId = SI.ItemId
            WHERE 
                    SI.StorageId = $1
                AND SI.ItemId    = $2
                AND SI.Empty     = 'f'
                AND SI.Amount < II.ItemMaxStack
        ", &[&storage_id, &item_id]).unwrap() 
    {

        slots.push(PartiallyEmptySlots {

            storage_item_id: row.get("StorageItemId"),
            amount_left_to_give: row.get("AmountLeft")

        });

    }
    return slots;

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

        swap_metadata(other_storage_item_id, storage_move_request.old_storage_item_id, client);
        //transfer_metadata(other_storage_item_id, storage_move_request.old_storage_item_id, client);
        //transfer_metadata(storage_move_request.old_storage_item_id, other_storage_item_id, client);

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
                transfer_metadata(other_storage_item_id, storage_move_request.old_storage_item_id, &mut client);
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

    let mut give_response = ItemGiveResponse {
        response: Response {
            success: false,
            message: "".to_string()
        },
        storage_item_id: -1
    };

    if get_available_space_for_item(item_give_request.storage_id, item_give_request.item_id, &mut client) < item_give_request.amount {

        give_response.response.message = "Not enough space for transfer".to_string();
        return serde_json::to_string(&give_response).unwrap();

    }

    let mut amount_left_to_give = item_give_request.amount;
    let partially_empty_slots = get_partially_empty_space_for_item(item_give_request.storage_id, item_give_request.item_id, &mut client);

    for partial_slot in partially_empty_slots {

        if amount_left_to_give == 0 {
            break;
        }

        if partial_slot.amount_left_to_give > amount_left_to_give {
            change_item_amount(partial_slot.storage_item_id, amount_left_to_give, &mut client);
            amount_left_to_give = 0;
        } else {
            change_item_amount(partial_slot.storage_item_id, partial_slot.amount_left_to_give, &mut client);
            amount_left_to_give -= partial_slot.amount_left_to_give;
        }

    }
    let max_stack = get_item_max_stack(item_give_request.item_id, &mut client);

    while amount_left_to_give > 0 {

        let slot = get_empty_slot(item_give_request.storage_id, &mut client);
        if !does_slot_exist(item_give_request.storage_id, slot, &mut client) {
            create_slot(item_give_request.storage_id, slot, &mut client);
        }
        let storage_item_id = get_existing_storage_item_id(item_give_request.storage_id, slot, &mut client);
        if amount_left_to_give > max_stack {

            set_storage_item(storage_item_id, item_give_request.item_id, max_stack,  &mut client);
            amount_left_to_give -= max_stack;

        } else {

            set_storage_item(storage_item_id, item_give_request.item_id, amount_left_to_give,  &mut client);
            amount_left_to_give = 0;

        }
        give_response.storage_item_id = storage_item_id;

    }

    if item_give_request.storage_item_id != -1 {

        change_item_amount(item_give_request.storage_item_id, -item_give_request.amount, &mut client);
        transfer_metadata(give_response.storage_item_id, item_give_request.storage_item_id, &mut client);

    } else {

        metadata::create_metadata(item_give_request.character_id, item_give_request.item_id, give_response.storage_item_id, &mut client);

    }

    give_response.response.success = true;
    return serde_json::to_string(&give_response).unwrap();

}

#[post("/Storage/Remove", format = "json", data = "<item_remove_request>")]
pub fn remove_storage_item(item_remove_request: Json<ItemRemoveRequest>) -> String {

    let item_remove_request = item_remove_request.into_inner();
    let mut client = db_postgres::get_connection().unwrap();
    change_item_amount(item_remove_request.storage_item_id, -item_remove_request.amount, &mut client);
    disable_metadata(item_remove_request.storage_item_id, &mut client);

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
    let mut stashes: Vec<StorageLocation> = Vec::new();

    for row in client.query("SELECT StorageId, X, Y, Z FROM Storage.Stashes WHERE SQRT(POWER(X - $1, 2) + POWER(Y - $2, 2) + POWER(Z - $3, 2)) < 250;", &[&x, &y, &z]).unwrap() {

        stashes.push(StorageLocation {

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

pub fn create_storage(storage_type_name: String, client: &mut postgres::Client) -> i32 {

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
    let mut vehicle_storage_id_response = GetStorageIdResponse {
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


#[put("/Storage/ResetTemp")]
pub fn reset_temporary_storage() {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute(
        "
            UPDATE Storage.Items SI Set Empty = 't' 
            FROM Storage.Drop as SD 
            where SD.StorageId = SI.StorageId;
        "
        , &[]).unwrap();

    client.execute(
        "
            UPDATE Storage.ItemMetaData SIMD Set Deleted = 't' 
            FROM 
                Storage.Drop as SD
            INNER JOIN Storage.Items SI ON SI.StorageId = SD.StorageId
            INNER JOIN Storage.ItemMetaData SIMD2 ON SIMD2.StorageItemId = SI.StorageItemId
            where 
                SIMD.StorageItemId = SIMD2.StorageItemId
        "
        , &[]).unwrap();

    client.execute("UPDATE Storage.Drop SET Active = 'f'", &[]).unwrap();

    client.execute(
        "
            UPDATE Storage.Items SI Set Empty = 't' 
            FROM Storage.Vehicle SV
            where SV.StorageId = SI.StorageId;
        ", &[]).unwrap();

    client.execute(
        "
            UPDATE Storage.ItemMetaData SIMD Set Deleted = 't' 
            FROM 
                Storage.Vehicle SV
            INNER JOIN Storage.Items SI ON SI.StorageId = SV.StorageId
            INNER JOIN Storage.ItemMetaData SIMD2 ON SIMD2.StorageItemId = SI.StorageItemId
            WHERE 
                SIMD.StorageItemId = SIMD2.StorageItemId;
        "
        , &[]).unwrap();

}

#[get("/Storage/Drops/<x>/<y>/<z>")]
pub fn get_nearby_drops(x: f32, y: f32, z: f32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut drops: Vec<StorageLocation> = Vec::new();
    for row in client.query("SELECT StorageId, X, Y, Z FROM Storage.Drop WHERE SQRT(POWER(X - $1, 2) + POWER(Y - $2, 2) + POWER(Z - $3, 2)) < 200 AND Active = 't';", &[&x, &y, &z]).unwrap() {

        drops.push(StorageLocation {

            storage_id: row.get("StorageId"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z")

        });

    }
    serde_json::to_string(&drops).unwrap()

}

fn create_drop(x: f32, y: f32, z: f32,  client: &mut postgres::Client) -> i32 {

    let storage_id = create_storage("Drop".to_string(), client);
    client.execute("INSERT INTO Storage.Drop (StorageId, X, Y, Z, Active) VALUES ($1, $2, $3, $4, 't')", &[&storage_id, &x, &y, &z]).unwrap();
    return storage_id;

}

#[get("/Storage/GetFreeDropZone/<x>/<y>/<z>")]
pub fn get_free_drop_zone(x: f32, y: f32, z: f32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let row = client.query_one("SELECT StorageId FROM Storage.Drop WHERE Active ='f' LIMIT 1", &[]);
    let mut storage = GetStorageIdResponse {
        storage_id: 0
    };

    match row {
        Ok(row) => {

            if row.is_empty() {

                storage.storage_id = create_drop(x, y, z, &mut client);

            } else {

                storage.storage_id = row.get("StorageId");
                client.execute("UPDATE Storage.Drop SET X = $1, Y = $2, Z = $3, Active = 't' WHERE StorageId = $4", &[&x, &y, &z, &storage.storage_id]).unwrap();

            }

        },
        Err(_) => {
            
            storage.storage_id = create_drop(x, y, z, &mut client);

        }
    }
    let thing = serde_json::to_string(&storage).unwrap();
    return thing;

}

#[put("/Storage/SetDropZoneInactive/<storage_id>")]
pub fn set_drop_zone_to_inactive(storage_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Storage.Drop SET Active = 'f' WHERE StorageId = $1", &[&storage_id]).unwrap();

    let response = StorageResponse{
        response: Response {
            success: true,
            message: "Successfully set to inactive".to_string()
        }
    };

    serde_json::to_string(&response).unwrap()

}