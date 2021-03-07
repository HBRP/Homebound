local character_position = {}

function get_character_position()

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

    character_position = position

    local player_ped_id = PlayerPedId()
    SetEntityCoords(player_ped_id, position.x, position.y, position.z)
    SetEntityHeading(player_ped_id, position.heading)

end

local function save_character_position()

    TriggerServerEvent("UpdateCharacterPosition", get_character_id(), position)

end