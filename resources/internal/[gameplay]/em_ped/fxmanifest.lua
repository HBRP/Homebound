
fx_version 'bodacious'
games { 'gta5' }

client_scripts {

    'client/disable_controls/c_ped_disable_controls.lua',
    'client/disable_controls/c_first_person_vehicle_shooting.lua',
    'client/c_ped_utils.lua',
    'client/ped_interaction/c_ped_interaction.lua',
    'client/ped_alerts/c_gunfire_alert.lua'

}

exports {
    'does_any_ped_see_ped'
}

dependencies {
    'em_fw',
    'em_items',
    'em_dialog',
    'em_medical',
    'em_interactions',
    'em_animations',
    't-notify'
}