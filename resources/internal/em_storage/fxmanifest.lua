
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_storage.lua',
    'client/c_vehicle.lua',
    'client/c_drop.lua'

}

exports {

    'get_nearby_drop_storage_id'

}

dependencies {

    'em_fw',
    'em_commands',
    'cd_drawtextui',
    'swt_notifications'

}