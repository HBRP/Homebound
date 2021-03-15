
fx_version 'bodacious'
games { 'gta5' }


client_script 'client/server_callbacks/c_server_callbacks.lua'

client_script 'client/startup/startup.lua'
client_script 'client/player/c_player.lua'
client_script 'client/character/c_character.lua'
client_script 'client/character/c_character_health.lua'
client_script 'client/character/c_character_position.lua'
client_script 'client/character/c_character_outfit.lua'

client_script 'client/commands/c_commands.lua'
client_script 'client/blips/c_blips.lua'

server_script 'server/http/http.lua'
server_script 'server/http/http_sql.lua'
server_script 'server/http/http_requests.lua'

server_script 'server/server_callbacks/s_server_callbacks.lua'

server_script 'server/player/s_player.lua'
server_script 'server/character/s_character.lua'
server_script 'server/character/s_character_outfit.lua'

server_script 'server/commands/s_commands.lua'
server_script 'server/blips/s_blips.lua'

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
export 'get_character_gender'
export 'get_character_name'
export 'get_character_id'
export 'get_target_character_id'
export 'get_target_character_id_batch'
export 'get_server_id_from_character_id'

-- c_character_outfit.lua
export 'create_outfit'
export 'update_outfit'
export 'get_outfit'
export 'get_active_outfit'
export 'delete_outfit'
export 'get_all_outfit_meta_data'

export 'create_skin'
export 'get_skin'
export 'update_skin'

export 'can_use_command'

--c_blips.lua
export 'get_blips'

-- c_player.lua
export 'get_player_id'

export 'trigger_server_callback'
server_export 'register_server_callback'