fx_version 'adamant'

game 'gta5'

description 'ESX Sit'

version '1.0.3'

server_scripts {
	'config.lua',
	'lists/seat.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'lists/seat.lua',
	'client.lua'
}

dependencies {

    'em_fw',
    'em_commands',
    'swt_notifications'

}