
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_vehicle_mod.lua',
    'client/c_vehicle_registration.lua'

}

server_scripts {

    'server/s_vehicle_registration.lua'

}

exports {

    'spawn_vehicle',
    'despawn_vehicle',
    'get_vehicle_mods',
    'set_vehicle_mods',
    'get_vehicle_state',
    'set_vehicle_state'
    
}

dependencies {
    'em_fw'
}