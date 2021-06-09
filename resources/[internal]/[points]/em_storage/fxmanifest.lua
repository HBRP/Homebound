
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_storage.lua',
    'client/c_vehicle.lua',
    'client/c_drop.lua'

}

exports {

    'get_nearby_drop_storage_id',
    'register_manual_stashes',
    'deregister_manual_stashes'

}

dependencies {

    'em_dal',
    'em_points',
    'em_commands',
    'cd_drawtextui',
    't-notify'

}