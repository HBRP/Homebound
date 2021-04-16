
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
    'client/character/c_character_tattoos.lua',
    'client/commands/c_commands.lua',
    'client/blips/c_blips.lua',
    'client/storage/c_storage.lua',
    'client/storage/c_stashes.lua',
    'client/storage/c_vehicle_storage.lua',
    'client/storage/c_drop.lua',
    'client/items/c_items.lua',
    'client/utils/c_enumerator.lua',
    'client/utils/c_raycast.lua',
    'client/vehicle/c_vehicle.lua',
    'client/store/c_store.lua',
    'client/customization/c_customization.lua',
    'client/groups/c_groups.lua',
    'client/teleporter/c_teleporter.lua',
    'client/interaction/c_interaction.lua',
    'client/door/c_doors.lua',
    'client/events/c_trigger_events.lua',
    'client/character/c_character_emote_keybinds.lua',
    'client/vehicle/c_vehicle_store.lua',
    'client/vehicle/c_vehicle_garage.lua'
    
}

server_scripts {

    'server/http/http.lua',
    'server/http/http_sql.lua',
    'server/http/http_requests.lua',
    'server/server_callbacks/s_server_callbacks.lua',
    'server/player/s_player.lua',
    'server/character/s_character.lua',
    'server/character/s_character_outfit.lua',
    'server/character/s_character_tattoos.lua',
    'server/commands/s_commands.lua',
    'server/blips/s_blips.lua',
    'server/storage/s_storage.lua',
    'server/storage/s_stashes.lua',
    'server/storage/s_vehicle_storage.lua',
    'server/storage/s_drop.lua',
    'server/items/s_items.lua',
    'server/store/s_store.lua',
    'server/customization/s_customization.lua',
    'server/groups/s_groups.lua',
    'server/bank/s_bank.lua',
    'server/teleporter/s_teleporter.lua',
    'server/interaction/s_interaction.lua',
    'server/door/s_doors.lua',
    'server/events/s_trigger_events.lua',
    'server/character/s_character_emote_keybinds.lua',
    'server/vehicle/s_vehicle_store.lua',
    'server/vehicle/s_vehicle_garage.lua'

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
export 'get_nearby_character_ids'
export 'is_character_id_in_radius_async'

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

-- c_character_tattoos
export 'get_tattoos'
export 'get_tattoos_async'
export 'update_tattoos'

-- c_character_emote_keybinds.lua
export 'get_emote_keybinds'
export 'update_emote_keybinds'

export 'can_use_command'

--c_blips.lua
export 'get_blips'

-- c_player.lua
export 'get_player_id'

-- c_storage.lua
export 'give_item'
export 'get_storage'
export 'get_storage_async'
export 'remove_item'
export 'move_item'
export 'move_item_async'
export 'give_item_to_other_character'

-- c_stashes.lua
export 'get_nearby_stashes'

-- c_vehicle_storage.lua
export 'get_vehicle_storage'
export 'get_vehicle_storage_id'

-- c_drop.lua
export 'get_nearby_drops'
export 'get_nearby_drops_async'
export 'get_free_drop_zone'
export 'set_drop_zone_inactive'

-- c_items.lua
export 'get_item_modifiers'
export 'get_weapons'
export 'get_items'
export 'get_attachments'

-- c_vehicle.lua
export 'get_nearest_vehicle'

-- c_store.lua
export 'get_nearby_stores_async'
export 'get_store_items_async'

-- c_customization.lua
export 'get_nearby_customization_points_async'

--c_groups.lua
export 'get_nearby_job_clock_in_async'
export 'get_clocked_on_job_async'
export 'clock_in_async'
export 'clock_out_async'

--c_teleporter.lua
export 'get_nearby_teleporter_points_async'
export 'get_teleporter_options_async'

-- c_server_callback.lua
export 'trigger_server_callback'
export 'trigger_server_callback_async'

-- utils
export 'ray_cast_game_play_camera'
export 'enumerate_objects'
export 'enumerate_peds'
export 'enumerate_vehicles'
export 'enumerate_pickups'

-- c_interaction.lua
export 'get_nearby_interaction_points_async'
export 'get_all_interaction_props_async'
export 'get_nearby_interaction_peds_async'

-- c_doors.lua
export 'get_nearby_doors_async'
export 'toggle_door'

-- c_trigger_events.lua
export 'trigger_event_for_character'
export 'trigger_proximity_event'

-- c_vehicle_store.lua
export 'get_vehicle_store_stock_async'
export 'can_purchase_a_vehicle'
export 'insert_new_vehicle_async'

-- c_vehicle_garage.lua
export 'get_character_vehicles_async'
export 'takeout_vehicle_async'
export 'get_nearby_garage'

-- s_player.lua
server_export 'get_priority_if_whitelisted'

--s_items.lua
server_export 'get_items'

-- s_character.lua
server_export 'get_character_id_from_source'
server_export 'get_character_storage_id_from_character_id'
server_export 'get_character_from_source'

-- s_storage.lua
server_export 'give_item'

-- s_blips.lua
server_export 'get_blip_group_subscription'

-- s_server_callback.lua
server_export 'register_server_callback'

--s_groups.lua
server_export 'get_current_character_jobs'
server_export 'get_group_alerts'
server_export 'get_group_alert_subscriptions'

--s_bank.lua
server_export 'direct_deposit'