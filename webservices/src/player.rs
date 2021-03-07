
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
pub struct UserCredentials {

    pub username: String,
    pub password_hash: String,

}
#[derive(Serialize, Deserialize, Debug)]
struct UserSession {

    session_id: String,
    result_code: ResultCodes

}

#[derive(Serialize, Deserialize, Debug)]
pub struct Session {

    pub session_id: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct ErrorResponse {

    pub result_code: ResultCodes

}

#[derive(Serialize, Deserialize, Debug)]
pub struct Player {

    pub player_id: i32

}

pub mod user {

    use crate::db_postgres;
    use crate::player::{UserCredentials, UserSession, ErrorResponse, ResultCodes};
    use crate::service_hashing;

    pub fn create(user: UserCredentials) -> String {

        let client = db_postgres::get_connection();
        match client {

            Ok(mut conn) => {

                let session_id     = create_player_records(&mut conn, &user);
                let user_session   = UserSession {

                    session_id: session_id,
                    result_code: ResultCodes::Successful

                };
                serde_json::to_string(&user_session).unwrap()

            }
            Err(err) => {

                println!("{:?}", err);
                let error = ErrorResponse {

                    result_code: ResultCodes::GeneralError

                };
                serde_json::to_string(&error).unwrap()
            }

        }

    }

    pub fn exists(user: &UserCredentials) -> bool {

        let client = db_postgres::get_connection();

        match client {

            Ok(mut client) => {

                let row = client.query_one("SELECT * FROM Player.Players WHERE UserName = $1", &[&user.username]);
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

    fn create_player_records(mut client: &mut postgres::Client, user: &UserCredentials) -> String {

        let argon2_hash = service_hashing::get_argon2_hash(&user.password_hash);

        let row            = client.query_one("INSERT INTO Player.Players (UserName, PasswordHash, PasswordSalt) VALUES ($1, $2, $3) RETURNING PlayerId", &[&user.username, &argon2_hash.hash, &argon2_hash.salt]).unwrap();
        let player_id: i32 = row.get("PlayerId");
        let argon2_hash    = service_hashing::get_argon2_hash(&user.password_hash);
        let session_id     = service_hashing::get_sha512_hash(&argon2_hash.hash);

        client.execute("INSERT INTO Player.Sessions (PlayerId, SessionId) VALUES ($1, $2)", &[&player_id, &session_id]).unwrap();
        create_player_queue_permissions(&mut client, player_id);
        session_id

    }

    fn create_player_queue_permissions(client: &mut postgres::Client, player_id: i32) {

        client.execute("INSERT INTO Queue.Permissions (PlayerId) VALUES ($1)", &[&player_id]).unwrap();

    }
}

pub mod login_user {

    use crate::db_postgres;
    use crate::player::{UserCredentials, UserSession, ErrorResponse, ResultCodes, Player, Session};
    use crate::service_hashing;

    struct PersonUser {

        player_id     : i32,
        password_hash : String,
        password_salt : String

    }

    pub fn login(user: UserCredentials) -> String {

        let client = db_postgres::get_connection();
        match client {

            Ok(mut client) => {

                let person_user = get_person_user(&mut client, &user);
                let argon2_hash = service_hashing::get_argon2_hash_salt(&user.password_hash, &person_user.password_salt);
                if person_user.password_hash.eq(&argon2_hash.hash) {

                    let session_id = create_session(&mut client, &person_user);
                    return serde_json::to_string(&UserSession {

                        result_code : ResultCodes::Successful,
                        session_id  : session_id

                    }).unwrap()

                }
                serde_json::to_string(&ErrorResponse {
                    result_code : ResultCodes::GeneralError
                }).unwrap()
            }
            Err(_err) => {
                serde_json::to_string(&ErrorResponse {
                    result_code : ResultCodes::GeneralError
                }).unwrap()
            }
        }
    }

    pub fn get_player_id_by_session_id(session: Session) -> String {

        let client = db_postgres::get_connection();
        match client {

            Ok(mut client) => {

                let row = client.query_one("SELECT PlayerId FROM Player.Sessions WHERE SessionId = $1", &[&session.session_id]).unwrap();
                serde_json::to_string(&Player {
                    player_id : row.get("PlayerId")
                }).unwrap()

            }
            Err(_err) => {
                serde_json::to_string(&ErrorResponse {
                    result_code : ResultCodes::GeneralError
                }).unwrap()
            }
        }
    }

    fn get_person_user(client: &mut postgres::Client, user: &UserCredentials) -> PersonUser {

        let row = client.query_one("SELECT * FROM Player.Players WHERE UserName = $1", &[&user.username]).unwrap();
        PersonUser {
            player_id     : row.get("PlayerId"),
            password_hash : row.get("PasswordHash"),
            password_salt : row.get("PasswordSalt")
        }
    }

    fn create_session(client: &mut postgres::Client, person_user: &PersonUser) -> String {

        let argon2_hash = service_hashing::get_argon2_hash(&person_user.password_hash);
        let session_id  = service_hashing::get_sha512_hash(&argon2_hash.hash);
        client.execute("INSERT INTO Player.Sessions (PlayerId, SessionId) VALUES ($1, $2)", &[&person_user.player_id, &session_id]).unwrap();
        session_id

    }
}