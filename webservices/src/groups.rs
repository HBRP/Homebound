use serde::{Deserialize, Serialize};
use crate::db_postgres;

#[derive(Serialize, Deserialize, Debug)]
struct ClockInPoint {
    group_id: i32,
    x: f32,
    y: f32,
    z: f32,
    group_name: String
}

#[derive(Serialize, Deserialize, Debug)]
struct ClockedIn {

    clocked_in: bool,
    group_id: i32,
    group_rank_id: i32,
    group_rank: String,
    callsign: String,
    pay: i32

}

#[derive(Serialize, Deserialize, Debug)]
struct GroupAlert {

    group_alert_id: i32,
    group_alert_name: String

}

#[derive(Serialize, Deserialize, Debug)]
struct AlertSubscription {

    group_alert_id: i32,
    group_id: i32

}

#[get("/Groups/GetNeabyJobClockIn/<character_id>/<x>/<y>/<z>")]
pub fn get_nearby_job_clock_in(character_id: i32, x: f32, y: f32, z: f32) -> String {

    let mut client = db_postgres::get_connection().unwrap();

    let mut clock_in_points: Vec<ClockInPoint> = Vec::new();

    let query = 
    "
        SELECT
            GJC.GroupId, X, Y, Z, GG.GroupName
        FROM Groups.JobClockin GJC
        INNER JOIN Groups.Groups GG ON GG.GroupId = GJC.GroupId
        INNER JOIN Groups.Rank GR ON GR.GroupId = GG.GroupId
        INNER JOIN Character.Jobs CJ ON CJ.GroupRankId = GR.GroupRankId
        WHERE
                CJ.CharacterId = $1
            AND SQRT(POW(X - $2, 2) + POW(Y - $3, 2) + POW(Z - $4, 2)) < 200
    ";
    for row in client.query(query, &[&character_id, &x, &y, &z]).unwrap() {

        clock_in_points.push(ClockInPoint {

            group_id: row.get("GroupId"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z"),
            group_name: row.get("GroupName")

        });

    }
    return serde_json::to_string(&clock_in_points).unwrap();

}

#[get("/Groups/GetClockedOnJob/<character_id>")]
pub fn get_clocked_on_job(character_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut clocked_on =  ClockedIn {

        clocked_in: false,
        group_id: 0,
        group_rank_id: 0,
        group_rank: "".to_string(),
        callsign: "".to_string(),
        pay: 5

    };

    let row = client.query_one(
        "
            SELECT 
                CJ.GroupRankId,
                GR.Rank,
                GG.GroupId,
                GJP.Pay,
                (CASE WHEN CC.Callsign IS NULL THEN '' ELSE CC.CallSign END)
            FROM 
                Character.Jobs CJ
            INNER JOIN Groups.Rank GR ON GR.GroupRankId = CJ.GroupRankId
            INNER JOIN Groups.Groups GG ON GG.GroupId = GR.GroupId
            INNER JOIN Groups.JobPay GJP ON GJP.GroupRankId = GR.GroupRankId
            LEFT JOIN Character.Callsign CC ON CC.CharacterId = CJ.CharacterId
            WHERE 
                CJ.CharacterId = $1 AND CJ.ClockedOn = 't'
        ", &[&character_id]);

    match row {

        Ok(row) => {
            if !row.is_empty() {
                clocked_on.clocked_in = true;
                clocked_on.group_id = row.get("GroupId");
                clocked_on.group_rank_id = row.get("GroupRankId");
                clocked_on.group_rank = row.get("Rank");
                clocked_on.callsign = row.get("CallSign");
                clocked_on.pay = row.get("Pay")
            }
        },
        Err(_) => {

        }

    }

    return serde_json::to_string(&clocked_on).unwrap();

}


#[post("/Groups/ClockIn/<character_id>/<group_id>")]
pub fn clock_in(character_id: i32, group_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Character.Jobs SET ClockedOn = 'f' WHERE CharacterId = $1", &[&character_id]).unwrap();
    client.execute("UPDATE Character.Jobs CJ Set ClockedOn = 't' FROM Groups.Rank GJ WHERE CJ.CharacterId = $1 AND CJ.GroupRankId = GJ.GroupRankId AND GJ.GroupId = $2", &[&character_id, &group_id]).unwrap();

    return get_clocked_on_job(character_id);

}

#[post("/Groups/ClockOut/<character_id>")]
pub fn clock_out(character_id: i32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    client.execute("UPDATE Character.Jobs SET ClockedOn = 'f' WHERE CharacterId = $1", &[&character_id]).unwrap();
    return get_clocked_on_job(character_id);
    
}

#[get("/Groups/GroupAlerts")]
pub fn get_group_alerts() -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut group_alerts: Vec<GroupAlert> = Vec::new();

    for row in client.query("SELECT GroupAlertId, GroupAlertName FROM Groups.Alerts", &[]).unwrap() {

        group_alerts.push(GroupAlert {

            group_alert_id: row.get("GroupAlertId"),
            group_alert_name: row.get("GroupAlertName")

        });

    }

    serde_json::to_string(&group_alerts).unwrap()

}

#[get("/Groups/GroupAlertSubscriptions")]
pub fn get_group_alert_subscriptions() -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut alert_subscriptions: Vec<AlertSubscription> = Vec::new();
    for row in client.query("SELECT GroupAlertId, GroupId FROM Groups.AlertSubscriptions;", &[]).unwrap() {

        alert_subscriptions.push(AlertSubscription {

            group_alert_id: row.get("GroupAlertId"),
            group_id: row.get("GroupId")

        });

    }

    serde_json::to_string(&alert_subscriptions).unwrap()

}