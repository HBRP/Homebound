fx_version 'bodacious'

game 'gta5'

client_scripts {
    'client/prototype.lua',
    'client/config.lua',
    'client/wounds/wounds_core.lua',
    'client/wounds/wounds.lua',
    'client/effects/effects_core.lua',
    'client/effects/effects.lua',
    'client/player/player.lua',
    'client/player/player_stat.lua',
    'client/player/player_stat_events.lua',
    'client/misc/unconscious_manager.lua',
    'client/libs.lua',
    'client/blood.lua',
    'client/reactions/reactions_core.lua',
    'client/reactions/bone_reactions.lua',
    'client/reactions/weapon_reactions.lua'
}

exports {
    'get_stat',
    "mod_stat",
    "get_stat_max",
    "set_stat_max",
    "reset_stat_maxes",
    "reset_stat",
    "add_stat",
    "is_player_unconscious"
}