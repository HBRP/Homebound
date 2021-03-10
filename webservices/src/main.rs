#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

use rocket_contrib::json::Json;

mod player;
mod db_postgres;
mod service_hashing;
mod character;
mod storage;

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


fn main() {

    rocket::ignite().mount("/", routes![player_create, character_create,get_character_info, update_character_position, get_characters, get_player_id, delete_character]).launch();

}
