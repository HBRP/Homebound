fx_version 'bodacious'
games { 'gta5' }

client_scripts {
  'client/client.lua',
  'config.lua'
}

server_scripts {
  'server/server.lua',
  'config.lua'
}

ui_page('html/ui.html')

files {
    'html/ui.html',
    'html/js/script.js',
    'html/css/style.css',
    'html/img/cursor.png',
    'html/img/radio.png'
}

dependencies {

  'em_dal',
  'em_commands',
  'pma-voice',
  't-notify'

}