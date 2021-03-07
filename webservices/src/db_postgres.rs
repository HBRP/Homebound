

use postgres::{Client, NoTls};

pub fn get_connection() -> Result<postgres::Client, postgres::Error> {

    Client::connect("host=192.168.254.36 user=devtest password=devtest dbname=fivem", NoTls)
    
}

#[allow(unused)]
fn try_text_query() -> String {

    let mut client = Client::connect("host=192.168.254.36 user=devtest password=devtest dbname=fivem", NoTls).unwrap();
    let row = client.query_one("SELECT persontype FROM Person.Type WHERE persontypeid=1", &[]).unwrap();

    let foo: String = row.get("persontype");
    println!("foo: {}", foo);
    foo
}