use serde::{Deserialize, Serialize};
use serde_json::{json};
use crate::db_postgres;


#[derive(Serialize, Deserialize, Debug)]
struct ItemModifier {

    item_modifier_type_id: i32,
    item_modifier: f32

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
