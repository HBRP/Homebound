
fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'client/c_vehicle_context.lua',
    'client/c_context.lua',
    'client/emergency_repair/c_emergency_repair.lua'
}

exports {
    'register_context',
    'register_always_checked_context',
    'register_always_checked_multi_context'
}

dependencies {
    'em_dal',
    'em_dialog',
    'em_vehicles'
}