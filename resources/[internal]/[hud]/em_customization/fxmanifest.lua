
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_clothing_store.lua',
    'client/c_customization.lua',
    'client/c_spawn.lua'

}

exports {

    'get_character_appearance',
    'refresh_character_appearance',
    'register_manual_customization_spots',
    'deregister_manual_customization_spots'

}

dependencies {

    'em_dal',
    'em_commands',
    'cd_drawtextui',
    'fivem-appearance'

}