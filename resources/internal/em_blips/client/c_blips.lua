

local non_static_blips = {}

local function set_non_static_blips(blips)

    local player_coords = GetEntityCoords(PlayerPedId())

    for i = 1, #non_static_blips do
        RemoveBlip(non_static_blips[i])
    end
    non_static_blips = {}

    for i = 1, #blips do

        if not blips[i].is_static then

            local blip_coords = vector3(blips[i].x, blips[i].y, blips[i].z)
            if #(player_coords - blip_coords) <= 500 then
                local blip = AddBlipForCoord(blips[i].x, blips[i].y, blips[i].z)
                SetBlipSprite(blip, blips[i].blip_type)
                SetBlipColour(blip, blips[i].blip_color)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(blips[i].blip_name)
                EndTextCommandSetBlipName(blip)
                table.insert(non_static_blips, blip)
            end

        end

    end

end

local function non_static_blip_loop(blips)

    Citizen.CreateThread(function() 

        while true do

            Citizen.Wait(2500)
            set_non_static_blips(blips)

        end

    end)

end

local function set_static_blips(blips)

    for i = 1, #blips do

        if blips[i].is_static then
            local blip = AddBlipForCoord(blips[i].x, blips[i].y, blips[i].z)
            SetBlipSprite(blip, blips[i].blip_type)
            SetBlipColour(blip, blips[i].blip_color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blips[i].blip_name)
            EndTextCommandSetBlipName(blip)
        end

    end

end

local function set_active_blips()

    local blips = exports["em_fw"]:get_blips()
    set_static_blips(blips)
    non_static_blip_loop(blips)

end

RegisterNetEvent("em_fw:character_loaded")
AddEventHandler("em_fw:character_loaded", set_active_blips)