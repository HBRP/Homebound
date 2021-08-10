
fx_version 'bodacious'
games { 'gta5' }

ui_page 'ui/index.html'

files {

    'ui/index.html',
    'ui/js/photo-uploader.js',
    'ui/libs/jquery.js'

}

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
    'client/vehicle/c_vehicle_garage.lua',
    'client/cad/c_cad.lua',
    'client/housing/c_housing.lua',
    'client/context/c_context.lua',
    'client/bank/c_bank.lua',
    'client/actions/c_actions.lua',
    'client/phone/c_phone.lua',
    'client/phone/c_twitter.lua',
    'client/phone/c_appchat.lua',
    'client/phone/c_racing.lua',  
    'client/photos/c_photos.lua',
    'client/crafting/c_crafting.lua',
    'client/placeable/c_placeable.lua'
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
    'server/vehicle/s_vehicle.lua',
    'server/vehicle/s_vehicle_store.lua',
    'server/vehicle/s_vehicle_garage.lua',
    'server/cad/s_cad.lua',
    'server/housing/s_housing.lua',
    'server/context/s_context.lua',
    'server/actions/s_actions.lua',
    'server/phone/s_phone.lua',
    'server/phone/s_twitter.lua',
    'server/phone/s_appchat.lua',
    'server/phone/s_racing.lua',
    'server/photos/s_photos.lua',
    'server/crafting/s_crafting.lua',
    'server/log/s_log.lua',
    'server/placeable/s_placeable.lua',
    'server/character/s_character_health.lua'

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
export 'ban_player_async'
export 'ban_character_async'
export 'whitelist_player_async'

-- c_storage.lua
export 'give_item'
export 'get_storage'
export 'get_storage_async'
export 'remove_item'
export 'remove_any_item'
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
export 'get_all_vehicle_models_async'

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
export 'trigger_targeted_phone_event'

-- c_vehicle_store.lua
export 'get_vehicle_store_stock_async'
export 'can_purchase_a_vehicle'
export 'insert_new_vehicle_async'
export 'order_vehicle_async'

-- c_vehicle_garage.lua
export 'get_character_vehicles_async'
export 'takeout_vehicle_async'
export 'get_nearby_garage'
export 'store_vehicle'
export 'get_group_vehicles_async'

-- c_cad.lua
export 'cad_get_charges_async'
export 'cad_get_latest_cad_reports_async'
export 'cad_get_character_details_async'
export 'cad_new_report_async'
export 'cad_get_report_async'
export 'cad_delete_report_async'
export 'cad_search_for_character_async'
export 'cad_get_all_warrants_async'
export 'cad_search_reports_async'
export 'cad_search_vehicle_async'
export 'cad_get_vehicle_details_async'
export 'cad_update_vehicle'
export 'cad_update_character_details_async'
export 'cad_update_report_async'
export 'cad_new_warrant_async'
export 'cad_delete_warrant_async'

-- c_housing.lua
export 'get_nearby_houses_async'
export 'get_house_async'
export 'toggle_housing_door_lock_async'

-- c_context.lua
export 'get_context_async'

-- c_bank.lua
export 'bank_withdraw_amount'
export 'bank_deposit_money'
export 'bank_post_payment'
export 'bank_get_pending_transactions'
export 'bank_get_bank_accounts'
export 'bank_transfer_amount'
export 'bank_get_transactions'
export 'bank_get_default_bank_account_async'

-- c_actions.lua
export 'can_do_action_async'
export 'can_do_action'

-- c_phone.lua
export 'phone_get_phone_data_async'
export 'phone_delete_messages_async'
export 'phone_delete_all_messages_async'
export 'phone_new_message_async'
export 'phone_get_messages_async'
export 'phone_mark_messages_read_async'
export 'phone_get_contacts_async'
export 'phone_new_contact_async'
export 'phone_delete_contact_async'
export 'phone_update_contact_async'

-- c_twitter.lua
export 'twitter_login_async'
export 'twitter_create_account_async'
export 'twitter_get_tweets_async'
export 'twitter_change_avatar_async'
export 'twitter_change_password_async'
export 'twitter_get_logged_in_account_async'
export 'twitter_post_tweet_async'
export 'twitter_toggle_like_async'
export 'twitter_get_favourite_tweets_async'

-- c_appchat.lua
export 'appchat_get_messages_async'
export 'appchat_send_message_async'

-- c_photos.lua
export 'upload_photo_async'

-- c_racing.lua
export 'phone_get_races_async'

-- c_crafting.lua
export 'get_recipes_async'
export 'get_context_recipes_async'

-- c_placeable.lua
export 'placeable_get_placed_props_async'
export 'placeable_insert_prop_async'

-- c_character_health
export 'get_character_health'
export 'set_character_health'

-- s_player.lua
server_export 'get_priority_if_whitelisted'
server_export 'get_steam_id'

--s_items.lua
server_export 'get_items'

-- s_character.lua
server_export 'get_character_id_from_source'
server_export 'get_server_id_from_character_id'
server_export 'get_character_storage_id_from_character_id'
server_export 'get_character_from_source'
server_export 'get_current_character_ids'
server_export 'get_phone_number_from_source'
server_export 'get_source_from_phone_number'

-- s_storage.lua
server_export 'give_item'
server_export 'get_storage'
server_export 'remove_item'
server_export 'remove_any_item'

-- s_blips.lua
server_export 'get_blip_group_subscription'

-- s_server_callback.lua
server_export 'register_server_callback'

--s_groups.lua
server_export 'get_current_character_jobs'
server_export 'get_group_alerts'
server_export 'get_group_alert_subscriptions'
server_export 'get_all_characters_with_group_name'

--s_bank.lua
server_export 'direct_deposit'

-- s_phone.lua
server_export 'submit_phone_call'

-- s_racing.lua
server_export 'phone_get_races'

-- s_housing.lua
server_export 'get_all_house_ids_of_type_async'
server_export 'get_housing_storage_async'
server_export 'lock_doors_for_house_id'

-- s_log.lua
server_export 'log_generic'