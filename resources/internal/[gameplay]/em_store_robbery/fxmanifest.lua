
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_safe_robbery.lua',
    'client/c_store_robbery.lua'

}

server_scripts {

    'server/s_safe_robbery.lua',
    'server/s_store_robbery.lua'

}

dependencies {

    'em_fw',
    'em_items',
    'em_dialog',
    't-notify',
    'pd-safe'

}