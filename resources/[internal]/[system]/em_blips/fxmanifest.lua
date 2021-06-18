fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_blips.lua',
    'client/c_blip_group.lua',
    'client/c_temp_blips.lua'

}

server_scripts {

    'server/s_blip_group.lua'

}

exports {

    'create_temp_blip'
    
}

dependencies {

    'em_dal'

}