
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub enum ResultCodes {

    Successful,
    UserAlreadyExists,
    UserDoesNotExist,
    GeneralError,
    PasswordDidNotMatch

}

#[derive(Serialize, Deserialize, Debug)]
pub struct PlayerCredentials {

    pub steamid: String,

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ErrorResponse {

    pub result_code: ResultCodes

}

#[derive(Serialize, Deserialize, Debug)]
pub struct Player {

    pub player_id: i32

}

use crate::db_postgres;

pub fn get_player_id(player: PlayerCredentials) -> String {

    if !exists(&player) {

        return create_player(player);

    }
    let client = db_postgres::get_connection();
    match client {

        Ok(mut client) => {

            let row = client.query_one("SELECT * FROM Player.Players WHERE SteamId = $1", &[&player.steamid]).unwrap();
            let player = Player {

                player_id: row.get("PlayerId")

            };
            return serde_json::to_string(&player).unwrap()

        }
        Err(_err) => return_generic_error()
    }

}

pub fn create_player(player: PlayerCredentials) -> String {

    let client = db_postgres::get_connection();
    match client {

        Ok(mut conn) => {

            let player_id = create_player_records(&mut conn, &player);
            let player = Player {

                player_id: player_id

            };
            serde_json::to_string(&player).unwrap()

        }
        Err(err) => {

            println!("{:?}", err);
            return_generic_error()
        }

    }

}

pub fn exists(player: &PlayerCredentials) -> bool {

    let client = db_postgres::get_connection();

    match client {

        Ok(mut client) => {

            let row = client.query_one("SELECT * FROM Player.Players WHERE SteamId = $1", &[&player.steamid]);
            match row {
                Ok(_) => true,
                Err(err) => {

                    println!("{:?}", err);
                    false

                }
            }
        }
        Err(err) => {

            println!("{:?}", err);
            true

        }
    }
}

fn return_generic_error() -> String {

    let error = ErrorResponse {

        result_code: ResultCodes::GeneralError

    };
    serde_json::to_string(&error).unwrap()

}

fn create_player_records(mut client: &mut postgres::Client, player: &PlayerCredentials) -> i32 {

    let row = client.query_one("INSERT INTO Player.Players (Steamid) VALUES ($1) RETURNING PlayerId", &[&player.steamid]).unwrap();
    let player_id: i32 = row.get("PlayerId");

    create_player_queue_permissions(&mut client, player_id);
    player_id

}

fn create_player_queue_permissions(client: &mut postgres::Client, player_id: i32) {

    client.execute("INSERT INTO Queue.Permissions (PlayerId) VALUES ($1)", &[&player_id]).unwrap();

}
