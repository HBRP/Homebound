fx_version 'adamant'

game 'gta5'

client_scripts {
	'NativeUI.lua',
	'Config.lua',
	'Client/*.lua'
}

server_scripts {
	'Config.lua',
	'Server/*.lua'
}


dependencies {
    'em_commands',
    't-notify'
}