
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/server_callbacks/c_server_callbacks.lua',
    'client/startup/startup.lua',
    'client/player/c_player.lua',
    'client/character/c_character.lua',
    'client/character/c_character_health.lua',
    'client/character/c_character_position.lua',
    'client/character/c_character_outfit.lua',
    'client/commands/c_commands.lua',
    'client/blips/c_blips.lua',
    'client/storage/c_storage.lua',
    'client/items/c_items.lua'
    
}

server_scripts {

    'server/http/http.lua',
    'server/http/http_sql.lua',
    'server/http/http_requests.lua',
    'server/server_callbacks/s_server_callbacks.lua',
    'server/player/s_player.lua',
    'server/character/s_character.lua',
    'server/character/s_character_outfit.lua',
    'server/commands/s_commands.lua',
    'server/blips/s_blips.lua',
    'server/storage/s_storage.lua',
    'server/items/s_items.lua'

}

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
export 'get_character_storage'
export 'get_character_storage_id'
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


-- c_storage.lua
export 'give_item'
export 'get_storage'
export 'remove_item'
export 'move_item'

-- c_items.lua
export 'get_item_modifiers'
export 'get_weapons'

-- c_server_callback.lua
export 'trigger_server_callback'
-- s_server_callback.lua
server_export 'register_server_callback'