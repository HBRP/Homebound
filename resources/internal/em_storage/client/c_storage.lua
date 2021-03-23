
local nearby_stashes = {}
local running_stash_loop = false

local function stash_loop()

    if running_stash_loop then
        return
    end
    running_stash_loop = true

    local triggered_ui = false
    while true do

        Citizen.Wait(5)
        local ped_coords = GetEntityCoords(PlayerPedId())
        local nearby_a_stash = false
        for i = 1, #nearby_stashes do
            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_stashes[i].x, nearby_stashes[i].y, nearby_stashes[i].z, true) < 2 then
                TriggerEvent('cd_drawtextui:ShowUI', 'show', "Press [E] to access stash")
                triggered_ui   = true
                nearby_a_stash = true
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("esx_inventoryhud:open_secondary_inventory", nearby_stashes[i].storage_id, "Stash")
                    TriggerEvent('cd_drawtextui:HideUI')
                    running_stash_loop = false
                    return
                end
            end
        end
        if not nearby_a_stash then
            if triggered_ui then
                TriggerEvent('cd_drawtextui:HideUI')
            end
            Citizen.Wait(500)
        end
    end

end

local function stash_refresh_loop()

    while true do

        nearby_stashes = exports["em_fw"]:get_nearby_stashes()
        Citizen.Wait(10000)

    end

end

AddEventHandler("closed_inventory", function() 

    Citizen.CreateThread(stash_loop)

end)

Citizen.CreateThread(stash_loop)
Citizen.CreateThread(stash_refresh_loop)