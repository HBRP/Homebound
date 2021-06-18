
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_police_commands.lua',
    'client/c_police_gsr.lua',
    'client/c_police_sentencing.lua',
    'client/c_911.lua'

}

server_scripts {

    'server/s_911.lua'

}

dependencies {

    'em_dal',
    'em_items',
    'em_commands',
    'em_blips',
    't-notify',
    'em_form'

}