#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

use rocket_contrib::json::Json;

mod player;
mod db_postgres;
mod service_hashing;
mod character;
mod storage;
mod blips;
mod commands;
mod items;
mod store;
mod customization;

#[post("/Player/Create", format = "json", data = "<player_credentials>")]
fn player_create(player_credentials: Json<player::PlayerCredentials>) -> String {

    player::create_player(player_credentials.into_inner())

}

#[get("/Player/GetPlayerId", format = "json", data = "<player_credentials>")]
fn get_player_id(player_credentials: Json<player::PlayerCredentials>) -> String {

    player::get_player_id(player_credentials.into_inner())

}

#[post("/Character/Create", format = "json", data = "<character>")]
fn character_create(character: Json<character::CreateCharacter>) -> String {

    character::create(character.into_inner())

}

#[get("/Character/GetAll", format = "json", data = "<player>")]
fn get_characters(player: Json<player::Player>) -> String {

    character::get_characters(player.into_inner())

}

#[get("/Character/GetInfo", format = "json", data = "<character>")]
fn get_character_info(character: Json<character::CharacterId>) -> String {

    character::get_character_info(character.into_inner())

}

#[put("/Character/UpdateHealth", format = "json", data = "<character_health>")]
fn update_character_heatlh(character_health: Json<character::CharacterHealth>) {

    character::set_character_health(character_health.into_inner());

}

#[put("/Character/UpdatePosition", format = "json", data = "<character_position>")]
fn update_character_position(character_position: Json<character::CharacterPosition>) {

    character::set_character_position(character_position.into_inner());

}

#[put("/Character/Delete", format = "json", data = "<character>")]
fn delete_character(character: Json<character::CharacterId>) {

    character::delete_character(character.into_inner());

}

#[put("/Character/Enable", format = "json", data = "<character>")]
fn enable_character(character: Json<character::CharacterId>) {

    character::enable_character(character.into_inner());

}

#[post("/CharacterOutfit/Create", format = "json", data = "<outfit>")]
fn create_outfit(outfit: Json<character::CreateCharacterOutfit>) {

    character::create_outfit(outfit.into_inner());

}

#[put("/CharacterOutfit/Update", format = "json", data = "<outfit_update>")]
fn update_outfit(outfit_update: Json<character::CharacterOutfitUpdate>) {

    character::update_outfit(outfit_update.into_inner());

}

#[put("/CharacterOutfit/Delete", format = "json", data = "<outfit_id>")]
fn delete_outfit(outfit_id:  Json<character::CharacterOutfitId>) {

    character::delete_outfit(outfit_id.into_inner());

}

#[put("/Character/CreateSkin", format = "json", data = "<character_skin>")]
fn create_skin(character_skin: Json<character::CharacterCreateSkin>) {

    character::create_skin(character_skin.into_inner());

}

#[put("/Character/UpdateSkin", format = "json", data = "<character_skin>")]
fn update_skin(character_skin: Json<character::CharacterUpdateSkin>) {

    character::update_skin(character_skin.into_inner());

}

#[post("/Character/GetSkin", format = "json", data = "<character>")]
fn get_skin(character: Json<character::CharacterId>) -> String {

    character::get_skin(character.into_inner())

}

#[post("/CharacterOutfit/GetActive", format = "json", data = "<character>")]
fn get_active_outfit(character: Json<character::CharacterId>) -> String {

    character::get_active_outfit(character.into_inner())

}

#[post("/CharacterOutfit/Get", format = "json", data = "<outfit_id>")]
pub fn get_outfit(outfit_id: Json<character::CharacterOutfitId>) -> String {

    character::get_outfit(outfit_id.into_inner())

}

#[post("/CharacterOutfit/GetMetaData", format = "json", data = "<character>")]
fn get_all_outfit_meta_data(character: Json<character::CharacterId>) -> String {

    character::get_all_outfit_meta_data(character.into_inner())

}


fn main() {

    rocket::ignite().mount("/", routes![player_create, character_create,get_character_info, update_character_position, get_characters, get_player_id, 
        delete_character, get_skin, create_skin, update_skin, create_outfit, 
        update_outfit, delete_outfit, get_active_outfit, get_outfit, get_all_outfit_meta_data, blips::get_blips, commands::can_use_command,
        storage::move_storage_item, storage::give_storage_item, storage::remove_storage_item, storage::get_storage_request, storage::get_nearby_stashes, storage::get_vehicle_storage, storage::get_vehicle_storage_id, storage::reset_temporary_storage,
        storage::get_nearby_drops, storage::get_free_drop_zone, storage::set_drop_zone_to_inactive,
        items::get_item_modifiers, items::get_weapons, items::get_items,
        store::get_all_stores, store::get_nearby_stores,
        customization::get_all_customization_points, customization::get_nearby_customization_points]).launch();

}
