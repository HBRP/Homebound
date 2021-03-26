use serde::{Deserialize, Serialize};
use crate::db_postgres;

#[derive(Serialize, Deserialize, Debug)]
struct Blip {

    blip_type: i32,
    blip_color: i32,
    blip_name: String,
    x: f32,
    y: f32,
    z: f32,
    is_static: bool

}

#[get("/Blip/Get")]
pub fn get_blips() -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut blips: Vec<Blip> = Vec::new();

    for row in client.query("SELECT * FROM Blip.Blips WHERE Deleted = 'f'", &[]).unwrap() {

        blips.push(Blip {
            blip_type: row.get("BlipType"),
            blip_color: row.get("BlipColor"),
            blip_name: row.get("BlipName"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z"),
            is_static: row.get("Static")
        })

    }

    serde_json::to_string(&blips).unwrap()

}