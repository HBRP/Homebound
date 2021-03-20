use serde::{Deserialize, Serialize};
use crate::db_postgres;


#[derive(Serialize, Deserialize, Debug)]
struct ItemModifier {

    item_modifier_type_id: i32,
    item_modifier: f32

}

#[derive(Serialize, Deserialize, Debug)]
struct Weapon {

    item_id: i32,
    item_weapon_model: String,
    item_weapon_hash: i32,
    ammo_item_id: i32,
    item_uses_ammo: bool,
    item_alerts_cops: bool

}

#[get("/Item/Modifiers/<item_id>")]
pub fn get_item_modifiers(item_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut modifiers: Vec<ItemModifier> = Vec::new();

    for row in client.query("SELECT IM.ItemModifierTypeId, IM.ItemModifier FROM Item.Modifiers IM WHERE IM.ItemId = $1", &[&item_id]).unwrap() {

        modifiers.push(ItemModifier {

            item_modifier_type_id: row.get("ItemModifierTypeId"),
            item_modifier: row.get("ItemModifier")

        });

    }

    serde_json::to_string(&modifiers).unwrap()

}

#[get("/Item/Weapons")]
pub fn get_weapons() -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut weapons: Vec<Weapon> = Vec::new();

    for row in client.query("SELECT ItemId, ItemWeaponModel, ItemWeaponHash, AmmoItemId, ItemUsesAmmo, ItemAlertsCops FROM Item.Weapons;", &[]).unwrap() {

        weapons.push(Weapon {

            item_id          : row.get("ItemId"),
            item_weapon_model: row.get("ItemWeaponModel"),
            item_weapon_hash : row.get("ItemWeaponHash"),
            ammo_item_id     : row.get("AmmoItemId"),
            item_uses_ammo   : row.get("ItemUsesAmmo"),
            item_alerts_cops : row.get("ItemAlertsCops")

        });

    }
    serde_json::to_string(&weapons).unwrap()

}