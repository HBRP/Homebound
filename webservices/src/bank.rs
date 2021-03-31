
use serde::{Deserialize, Serialize};
use crate::db_postgres;

#[put("/Bank/DirectDeposit/<character_id>/<transaction_amount>")]
pub fn direct_deposit(character_id: i32, transaction_amount: i32) {

    let mut client = db_postgres::get_connection().unwrap();
    let bank_account_id_query = 
    "
        UPDATE 
            Bank.Account BA SET Funds = Funds + $1 
        FROM 
            Bank.AccountOwner BAO
        WHERE 
                BAO.CharacterId = $2
            AND BAO.DirectDeposit = 't'
            AND BAO.BankAccountId = BA.BankAccountId
    ";
    client.execute(bank_account_id_query, &[&transaction_amount, &character_id]).unwrap();
}