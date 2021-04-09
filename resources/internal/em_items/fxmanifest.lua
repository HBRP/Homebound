
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'config.lua',
    'client/c_consumable_animations.lua',
    'client/c_hotbar.lua',
    'client/c_weapons.lua',
    'client/c_items.lua',
    'client/item_registers/c_ammo_boxes.lua'

}

exports {

    'use_item',
    'get_item_id_from_name',
    'get_item_name_from_item_id',
    'get_item_weapon_model',
    'is_item_type_a_weapon',
    'is_item_type_ammo',
    'get_item_in_slot',
    'register_item_use',
    'does_character_have_knife',
    'does_weapon_hash_alert_cops'

}

dependencies {

    'em_fw',
    'em_medical',
    'rprogress',
    't-notify'

}