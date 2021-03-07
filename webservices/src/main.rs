#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

use rocket_contrib::json::Json;

mod player;
mod db_postgres;
mod service_hashing;
mod character;
mod storage;

#[post("/Player/Create", format = "json", data = "<user>")]
fn player_create(user: Json<player::UserCredentials>) -> String {

    println!("{:?}", user);

    let user = user.into_inner();

    if !player::user::exists(&user) {

        player::user::create(user)

    } else {

        let response = player::ErrorResponse {

            result_code : player::ResultCodes::UserAlreadyExists

        };
        serde_json::to_string(&response).unwrap()

    }
}

#[get("/Player/Login", format = "json", data = "<user>")]
fn player_login(user: Json<player::UserCredentials>) -> String {

    println!("{:?}", user);

    let user = user.into_inner();
    if player::user::exists(&user) {

        player::login_user::login(user)

    } else {

        let response = player::ErrorResponse {

            result_code : player::ResultCodes::UserDoesNotExist

        };
        serde_json::to_string(&response).unwrap()

    }

}

#[get("/Player/PlayerId", format = "json", data = "<session>")]
fn player_id(session: Json<player::Session>) -> String {

    println!("{:?}", session);

    let session = session.into_inner();
    player::login_user::get_player_id_by_session_id(session)

}

#[post("/Character/Create", format = "json", data = "<character>")]
fn character_create(character: Json<character::CreateCharacter>) -> String {

    character::create(character.into_inner())

}

#[get("/Character/GetAll", format = "json", data = "<player>")]
fn get_characters(player: Json<player::Player>) -> String {

    character::get_characters(player.into_inner())

}

#[get("/Character/GetPosition", format = "json", data = "<character>")]
fn get_character_position(character: Json<character::CharacterId>) -> String {

    character::get_character_position(character.into_inner())

}

#[get("/Character/GetHealth", format = "json", data = "<character>")]
fn get_character_health(character: Json<character::CharacterId>) -> String {

    character::get_character_health(character.into_inner())

}

#[get("/Character/GetInfo", format = "json", data = "<character>")]
fn get_character_info(character: Json<character::CharacterId>) -> String {

    "".to_string()
    //character::get_character_health(character.into_inner())

}

#[put("/Character/UpdateHealth", format = "json", data = "<character_health>")]
fn update_character_heatlh(character_health: Json<character::CharacterHealth>) {

    character::set_character_health(character_health.into_inner());

}

#[put("/Character/UpdatePosition", format = "json", data = "<character_position>")]
fn update_character_position(character_position: Json<character::CharacterPosition>) {

    character::set_character_position(character_position.into_inner());

}

#[put("/Character/Disable", format = "json", data = "<character>")]
fn disable_character(character: Json<character::CharacterId>) {

    character::disable_character(character.into_inner());

}

#[put("/Character/Enable", format = "json", data = "<character>")]
fn enable_character(character: Json<character::CharacterId>) {

    character::enable_character(character.into_inner());

}


fn main() {

    rocket::ignite().mount("/", routes![player_create, player_login, character_create, get_characters, get_character_position, get_character_health, player_id]).launch();

}
