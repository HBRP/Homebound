
fx_version 'bodacious'
games { 'gta5' }


client_script 'client/startup/startup.lua'
client_script 'client/player/c_player.lua'
client_script 'client/character/c_character.lua'
client_script 'client/character/c_character_health.lua'
client_script 'client/character/c_character_position.lua'

server_script 'server/http/http.lua'
server_script 'server/http/http_sql.lua'
server_script 'server/http/http_requests.lua'

server_script 'server/player/s_player.lua'
server_script 'server/player/s_character.lua'

ui_page 'ui/index.html'

files {

    'ui/index.html',
    'ui/libs/jquery.js'

}

-- c_character.lua
export 'create_character'
export 'delete_character'
export 'load_character'
export 'get_all_characters'
export 'characters_were_init'


-- c_player.lua
export 'get_player_id'