
local nearby_stashes = {}

local function stash_loop()

    local ped = PlayerPedId()
    while true do

        Citizen.Wait(5)
        
        local ped_coords = GetEntityCoords(ped)
        for i = 1, #nearby_stashes do

            

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

--get_nearby_stashes