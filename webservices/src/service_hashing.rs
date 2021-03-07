
use argon2::{self, Config};
use rand::{thread_rng, Rng};
use rand::distributions::Alphanumeric;
use sha2::{Sha512, Digest};

use std::iter::Iterator;

pub struct Argon2HashWithSalt {

    pub hash: String,
    pub salt: String

}

pub fn get_argon2_hash(data_to_hash: &String) -> Argon2HashWithSalt {

    let config = Config::default();

    let rng = thread_rng();
    let random_salt: String = rng.sample_iter(Alphanumeric).take(64).collect();
    let hash = argon2::hash_encoded(data_to_hash.as_bytes(), &random_salt.as_bytes(), &config).unwrap();

    Argon2HashWithSalt {

        hash : hash,
        salt : random_salt    

    }

}

pub fn get_argon2_hash_salt(data_to_hash: &String, salt: &String) -> Argon2HashWithSalt {

    let config = Config::default();

    let rng = thread_rng();
    let random_salt: String = rng.sample_iter(Alphanumeric).take(64).collect();
    let hash = argon2::hash_encoded(data_to_hash.as_bytes(), &salt.as_bytes(), &config).unwrap();

    Argon2HashWithSalt {

        hash : hash,
        salt : random_salt    

    }

}

pub fn get_sha512_hash(data_to_hash: &String) -> String {

    let mut sha_hasher = Sha512::new();
    sha_hasher.update(data_to_hash.as_bytes());
    hex::encode(sha_hasher.finalize())

}