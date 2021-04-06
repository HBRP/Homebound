

fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_jobs.lua',
    'client/c_fast_draw.lua'

}

server_scripts {

    'server/s_jobs.lua',
    's_characters_online.lua'

}

exports {

    'can_fast_draw'

}

dependencies {

    'em_fw'

}