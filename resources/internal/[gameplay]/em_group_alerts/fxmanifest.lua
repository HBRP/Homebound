
fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'client/c_test.lua',
    'client/c_group_alerts.lua'
}

server_script 'server/s_group_alerts.lua'

dependencies {

    'em_fw',
    'em_items',
    'em_commands'

}