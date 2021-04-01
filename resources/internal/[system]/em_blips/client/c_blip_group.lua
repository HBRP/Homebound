
local running_blip_groups = false
local blips = {}

local function delete_local_blips()

    for i = 1, #blips do
        RemoveBlip(blips[i])
    end
    blips = {}

end

local function setup_blips(new_blips)

    for i = 1, #new_blips do

        local blip = AddBlipForCoord(new_blips[i].x, new_blips[i].y, new_blips[i].z)
        SetBlipSprite(blip, 57)
        SetBlipColour(blip, new_blips[i].blip_color)
        SetBlipAsShortRange(blip, false)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blips[i].callsign)
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)

    end

end

RegisterNetEvent("em_blips:set_blips")
AddEventHandler("em_blips:set_blips", function(new_blips)

    print("setting blips")
    delete_local_blips()
    setup_blips(new_blips)

end)

AddEventHandler("em_jobs:clocked_out", function()

    Citizen.Wait(1000)
    delete_local_blips()

end)