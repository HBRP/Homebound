
use serde::{Deserialize, Serialize};
use crate::db_postgres;

#[derive(Serialize, Deserialize, Debug)]
pub struct Customization {

    customization_point_id: i32,
    customization_type_id: i32,
    customization_name: String,
    x: f32,
    y: f32,
    z: f32,

}

#[get("/Customization/All")]
pub fn get_all_customization_points() -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut customizations: Vec<Customization> = Vec::new();

    for row in client.query("SELECT CustomizationPointId, CustomizationTypeId, CustomizationName, X, Y, Z FROM Customization.Points", &[]).unwrap() {

        customizations.push(Customization {

            customization_point_id: row.get("CustomizationPointId"),
            customization_type_id: row.get("CustomizationTypeId"),
            customization_name: row.get("CustomizationName"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z")

        });

    }

    serde_json::to_string(&customizations).unwrap()

}

#[get("/Customization/Nearby/<x>/<y>/<z>")]
pub fn get_nearby_customization_points(x: f32, y: f32, z: f32) -> String {

    let mut client = db_postgres::get_connection().unwrap();
    let mut customizations: Vec<Customization> = Vec::new();

    for row in client.query("SELECT CustomizationPointId, CustomizationTypeId, CustomizationName, X, Y, Z FROM Customization.Points WHERE SQRT(POW(X - $1, 2) + POW(Y - $2, 2) + POW(Z - $3, 2)) < 200", &[&x, &y, &z]).unwrap() {

        customizations.push(Customization {

            customization_point_id: row.get("CustomizationPointId"),
            customization_type_id: row.get("CustomizationTypeId"),
            customization_name: row.get("CustomizationName"),
            x: row.get("X"),
            y: row.get("Y"),
            z: row.get("Z")

        });

    }

    serde_json::to_string(&customizations).unwrap()

}