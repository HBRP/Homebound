
fx_version 'bodacious'
games { 'gta5' }

server_script 'server/main.lua'

client_script 'client/main.lua'

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/listener.js'
}

dependencies {
	'em_dal'
}