
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_vehicle_registration.lua',
    'client/c_vehicle_commands.lua',
    'client/c_vehicle_mod.lua',
    'client/c_vehicle_spawn.lua',
    'client/c_vehicle_repair.lua',
    'client/c_vehicle_utils.lua'

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
    'set_vehicle_state',
    'register_vehicle_as_group_owned',
    'is_vehicle_owned_by_group',
    'is_vehicle_owned_by_group_id',
    'register_vehicle_as_player_owned',
    'is_vehicle_player_owned',
    'is_vehicle_owned_by_character',
    'has_keys',
    'transfer_keys',
    'repair_vehicle',
    'get_closest_vehicle'
    
}

dependencies {

    'em_dal',
    't-notify',
    'em_commands'

}