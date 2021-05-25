

fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_jobs.lua',
    'client/c_fast_draw.lua',
    'client/c_characters_online.lua'

}

server_scripts {

    'server/s_jobs.lua',
    's_characters_online.lua'

}

exports {

    'can_fast_draw',
    'get_num_law_enforcement_clocked_in'
    'get_number_of_group_type_clocked_in'

}

dependencies {

    'em_dal'

}