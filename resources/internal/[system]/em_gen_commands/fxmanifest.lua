

fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'client/c_cuff_command.lua',
    'client/c_shackle_command.lua'
}

exports {
    'is_handcuffed'
}

dependencies {

    'em_dal',
    'em_items',
    'em_commands',
    'em_animations',
    't-notify'

}
