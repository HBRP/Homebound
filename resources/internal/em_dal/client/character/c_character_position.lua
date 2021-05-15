

function get_character_position()

    local character_position = {}
    local player_ped_id = PlayerPedId()
    local coords  = GetEntityCoords(player_ped_id)
    local heading = GetEntityHeading(player_ped_id)

    character_position.x = coords[1]
    character_position.y = coords[2]
    character_position.z = coords[3]
    character_position.heading = heading

    return character_position

end

function set_character_position(position)

    local player_ped_id = PlayerPedId()
    SetEntityCoords(player_ped_id, position.x, position.y, position.z)
    SetEntityHeading(player_ped_id, position.heading)

end

local function save_character_position()

    local character_id =  get_character_id()
    local character_position = get_character_position()
    TriggerServerEvent("em_dal:update_character_position", get_character_id(), get_character_position())

end


RegisterNetEvent("em_dal:character_loaded")
AddEventHandler("em_dal:character_loaded", function()

    Citizen.CreateThread(function() 

        while true do

            Citizen.Wait(10000)
            save_character_position()

        end

    end)

end)