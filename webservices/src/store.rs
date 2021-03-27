
use serde::{Deserialize, Serialize};
use crate::db_postgres;

#[derive(Serialize, Deserialize, Debug)]
pub struct Store {

    store_id: i32,
    store_type_id: i32,
    store_name: String,
    x: f32,
    y: f32,
    z: f32,

}

#[derive(Serialize, Deserialize, Debug)]
pub struct StoreItem {

    selling: bool,
    item_id: i32,
    item_price: i32,
    item_name: String,
    item_type_id: i32

}

#[get("/Stores/All")]
pub fn get_all_stores() -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut stores: Vec<Store> = Vec::new();

    for row in client.query("SELECT StoreId, StoreTypeId, StoreName, X, Y, Z FROM Store.Stores", &[]).unwrap() {

        stores.push(Store {

            store_id: row.get("StoreId"),
            store_type_id: row.get("StoreTypeId"),
            store_name: row.get("StoreName"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z")

        });

    }

    serde_json::to_string(&stores).unwrap()

}

#[get("/Stores/Nearby/<x>/<y>/<z>")]
pub fn get_nearby_stores(x: f32, y: f32, z: f32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut stores: Vec<Store> = Vec::new();

    for row in client.query("SELECT StoreId, StoreTypeId, StoreName, X, Y, Z FROM Store.Stores WHERE SQRT(POW(X - $1, 2) + POW(Y - $2, 2) + POW(Z - $3, 2)) < 200", &[&x, &y, &z]).unwrap() {

        stores.push(Store {

            store_id: row.get("StoreId"),
            store_type_id: row.get("StoreTypeId"),
            store_name: row.get("StoreName"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z")

        });

    }

    serde_json::to_string(&stores).unwrap()

}

#[get("/Stores/Items/<store_type_id>")]
pub fn get_items_for_store_type(store_type_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut store_items: Vec<StoreItem> = Vec::new();

    for row in client.query("
        SELECT 
            SSI.ItemId, SSI.ItemSellPrice, II.ItemName, II.ItemTypeId 
        FROM Store.SellItems SSI
        INNER JOIN Item.Items II ON II.ItemId = SSI.ItemId
        WHERE 
            SSI.StoreTypeId = $1
        ", &[&store_type_id]).unwrap() {

        store_items.push(StoreItem {

            selling: true,
            item_id: row.get("ItemId"),
            item_price: row.get("ItemSellPrice"),
            item_name: row.get("ItemName"),
            item_type_id: row.get("ItemTypeId")

        });

    }

    serde_json::to_string(&store_items).unwrap()

}