use serde::{Deserialize, Serialize};
use serde_json::{json};
use crate::db_postgres;

use rocket_contrib::json::Json;

#[derive(Serialize, Deserialize, Debug)]
pub struct CommandRequest {

    character_id: i32,
    command: String

}

#[derive(Serialize, Deserialize, Debug)]
pub struct CommandReponse {

    can_use: bool

}

fn can_use_as_player(command_request: &CommandRequest, client: &mut postgres::Client) -> bool {

    let row = client.query_one("SELECT PC.PlayerId FROM Player.Characters PC WHERE PC.CharacterId = $1;", &[&command_request.character_id]).unwrap();
    let player_id: i32 = row.get("PlayerId");

    let row = client.query_one(
    "
        SELECT * FROM Command.PlayerTypePermissions CPTP
        INNER JOIN Player.Players PP ON PP.PlayerTypeId >= CPTP.PlayerTypeId
        WHERE PP.PlayerId = $1 AND CPTP.Permission = $2
    ", &[&player_id, &command_request.command]);

    match row {
        Ok(row) => !row.is_empty(),
        Err(_err) => false
    };
    return false

}

fn can_use_as_group(command_request: &CommandRequest, client: &mut postgres::Client) -> bool {

    let row = client.query_one(
    "
        SELECT * FROM Command.GroupPermissions CGP
        INNER JOIN Groups.Groups GG ON GG.GroupId = CGP.GroupId
        INNER JOIN Groups.Rank GR ON GR.GroupId = GG.GroupId
        LEFT JOIN Character.Jobs CJ ON CJ.CharacterId = $1 AND CJ.GroupRankId = GR.GroupRankId AND CJ.ClockedOn = 't'
        LEFT JOIN Character.Groups CG ON CG.CharacterId = $2 AND CG.GroupRankId = GR.GroupRankId
        WHERE CGP.Permission = $3  and (CJ.CharacterId is not null  or CG.CharacterId is not null)
    ", &[&command_request.character_id, &command_request.character_id, &command_request.command]);

    match row {
        Ok(row) => !row.is_empty(),
        Err(_err) => false
    };
    return false

}

fn can_use_as_rank(command_request: &CommandRequest, client: &mut postgres::Client) -> bool {

    let row = client.query_one(
    "
        SELECT * FROM Command.GroupRankPermissions CGRP
        INNER JOIN Groups.Rank GR ON GR.GroupRankId = CGRP.GroupRankId
        LEFT JOIN Character.Jobs CJ ON CJ.CharacterId = $1 AND CJ.GroupRankId = GR.GroupRankId AND CJ.ClockedOn = 't'
        LEFT JOIN Character.Groups CG ON CG.CharacterId = $2 AND CG.GroupRankId = GR.GroupRankId
        WHERE CGRP.Permission = $3 and ( CJ.CharacterId is not null  or CG.CharacterId is not null)
    ", &[&command_request.character_id, &command_request.character_id, &command_request.command]);

    match row {
        Ok(row) => !row.is_empty(),
        Err(_err) => false
    };
    return false

}


#[post("/Command/CanUseCommand", format = "json", data = "<command_request>")]
pub fn can_use_command(command_request: Json<CommandRequest>) -> String {

    let command_request = command_request.into_inner();
    let mut response = CommandReponse {
        can_use: false
    };

    let mut client = db_postgres::get_connection().unwrap();

    if can_use_as_player(&command_request, &mut client) {

        response.can_use = true;
        return serde_json::to_string(&response).unwrap();

    } else if can_use_as_group(&command_request, &mut client) {

        response.can_use = true;
        return serde_json::to_string(&response).unwrap();

    } else if can_use_as_rank(&command_request, &mut client) {

        response.can_use = true;
        return serde_json::to_string(&response).unwrap();

    }

    serde_json::to_string(&response).unwrap()

}