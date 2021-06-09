ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local weapons = {
    [1600] = {
        {item = "WEAPON_SMG", amount = 1},
        {item = "WEAPON_COMBATPDW", amount = 1},
        {item = "WEAPON_PISTOL_MK2", amount = 1},
        {item = "WEAPON_PUMPSHOTGUN", amount = 1},
        {item = "ammobox_12", amount = 1},
        {item = "ammobox_9", amount = 2},
        {item = "ammobox_45", amount = 2}
    },
    [1610] = {
        {item = "WEAPON_SMG", amount = 1},
        {item = "WEAPON_COMBATPDW", amount = 1},
        {item = "WEAPON_PISTOL_MK2", amount = 1},
        {item = "WEAPON_PUMPSHOTGUN", amount = 1},
        {item = "ammobox_12", amount = 1},
        {item = "ammobox_9", amount = 2},
        {item = "ammobox_45", amount = 2}
    },
    [1620] = {
        {item = "WEAPON_SMG", amount = 1},
        {item = "WEAPON_COMBATPDW", amount = 1},
        {item = "WEAPON_PISTOL_MK2", amount = 1},
        {item = "WEAPON_PUMPSHOTGUN", amount = 1},
        {item = "ammobox_12", amount = 1},
        {item = "ammobox_9", amount = 2},
        {item = "ammobox_45", amount = 2}
    },
    [1630] = {
        {item = "WEAPON_PISTOL_MK2", amount = 1},
        {item = "WEAPON_PUMPSHOTGUN", amount = 1},
        {item = "ammobox_12", amount = 1},
        {item = "ammobox_9", amount = 2}
    }
}

RegisterNetEvent("usmarshal_get_loadout")
AddEventHandler("usmarshal_get_loadout", function()

    Citizen.Trace("usmarshal_get_loadout")
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source) 
    local job = xPlayer.getJob()

    local grade_weapons = weapons[job.grade]
    for i = 1, #grade_weapons do

        local amount_to_give = grade_weapons[i].amount - xPlayer.getInventoryItem(grade_weapons[i].item).count
        if amount_to_give > 0 then
            xPlayer.addInventoryItem(grade_weapons[i].item, amount_to_give)
        end

    end

end)

RegisterNetEvent("usmarshal_remove_loadout")
AddEventHandler("usmarshal_remove_loadout", function()

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source) 
    local job = xPlayer.getJob()

    local grade_weapons = weapons[job.grade-5]
    for i = 1, #grade_weapons do
        xPlayer.removeInventoryItem(grade_weapons[i].item, grade_weapons[i].amount)
    end

end)