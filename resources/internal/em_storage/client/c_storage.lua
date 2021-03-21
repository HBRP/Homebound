
local nearby_stashes = {}

local function stash_loop()

    local ped = PlayerPedId()
    local triggered_ui = false
    while true do

        Citizen.Wait(5)
        local ped_coords = GetEntityCoords(ped)
        local nearby_a_stash = false
        for i = 1, #nearby_stashes do
            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_stashes[i].x, nearby_stashes[i].y, nearby_stashes[i].z, true) < 5 then
                TriggerEvent('cd_drawtextui:ShowUI', 'show', "Press [E] to access stash")
                triggered_ui   = true
                nearby_a_stash = true
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("esx_inventoryhud:open_secondary_inventory", nearby_stashes[i].storage_id)
                    TriggerEvent('cd_drawtextui:HideUI')
                end
            end
        end
        if not nearby_a_stash then
            if triggered_ui then
                TriggerEvent('cd_drawtextui:HideUI')
            end
            Citizen.Wait(200)
        end
    end

end

local function stash_refresh_loop()

    while true do

        nearby_stashes = exports["em_fw"]:get_nearby_stashes()
        Citizen.Wait(10000)

    end

end

AddEventHandler("em_fw:character_loaded", function()

    Citizen.CreateThread(stash_loop)
    Citizen.CreateThread(stash_refresh_loop)

end)