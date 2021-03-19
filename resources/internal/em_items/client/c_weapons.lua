
local ped = nil
local function update_weapons_on_character()

    RemoveAllPedWeapons(ped, true)
    

end

AddEventHandler('em_fw:character_inventory_change', function()

    Citizen.Trace("Updating character weapons\n")

    ped = PlayerPedId()
    update_weapons_on_character()

end)