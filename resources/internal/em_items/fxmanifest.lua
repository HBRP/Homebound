
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/c_consumable_animations.lua',
    'client/c_items.lua'

}

exports {

    'use_item',
    'get_item_weapon_model',
    'is_item_type_a_weapon'

}

dependencies {

    'em_fw',
    'em_medical'

}