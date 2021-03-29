
local nearby_stashes = {}
local running_stash_loop = false

local function stash_loop()

    if running_stash_loop then
        return
    end
    running_stash_loop = true

    local ui_id = -1
    while true do

        Citizen.Wait(5)
        local ped_coords = GetEntityCoords(PlayerPedId())
        local nearby_a_stash = false
        for i = 1, #nearby_stashes do
            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_stashes[i].x, nearby_stashes[i].y, nearby_stashes[i].z, true) < 2 then

                if not exports["cd_drawtextui"]:is_in_queue(ui_id) then
                    ui_id = exports["cd_drawtextui"]:show_text("Press [E] to access stash")
                end
                nearby_a_stash = true
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("esx_inventoryhud:open_secondary_inventory", nearby_stashes[i].storage_id, "Stash")
                    exports["cd_drawtextui"]:hide_text(ui_id)
                end
            end
        end
        if not nearby_a_stash then
            if exports["cd_drawtextui"]:is_in_queue(ui_id) then
                exports["cd_drawtextui"]:hide_text(ui_id)
            end
            Citizen.Wait(1000)
        end
    end

end

local function stash_refresh_loop()

    while true do

        nearby_stashes = exports["em_fw"]:get_nearby_stashes()
        if nearby_stashes == nil then
            nearby_stashes = {}
        end
        Citizen.Wait(10000)

    end

end

Citizen.CreateThread(stash_loop)
Citizen.CreateThread(stash_refresh_loop)