
local loaded_character  = nil
local character_storage = nil

function get_character_storage_id()

    return loaded_character["character"]["storage_id"]

end

function get_character_storage()

    if character_storage == nil then
        character_storage = get_storage(get_character_storage_id())
    end

    return character_storage

end

function get_character_id()

    return loaded_character["character"]["character_id"]

end

function get_target_character_id(target)

    local target_character_id
    trigger_server_callback("em_fw:get_player_character_id", function(character_id)

        target_character_id = character_id

    end, target)

    return target_character_id

end

function get_target_character_id_batch(targets)

    local target_character_ids
    trigger_server_callback("em_fw:get_player_character_id_batch", function(character_ids)

        target_character_ids = character_ids

    end, targets)

    return target_character_ids

end

function get_server_id_from_character_id(character_id)

    local temp_server_id = nil
    trigger_server_callback("em_fw:get_server_id_from_character_id", function(server_id)

        temp_server_id = server_id

    end, character_id)

    return temp_server_id

end

function get_nearby_character_ids(radius_around_player)

    local ped = PlayerPedId()
    local player_coords = GetEntityCoords(ped)

    local server_ids = {}
    for _, id in ipairs(GetActivePlayers()) do

        local target_ped = GetPlayerPed(id)
        local distance = #(player_coords - GetEntityCoords(target_ped))
        if distance <= radius_around_player and target_ped ~= ped then
            local server_id = GetPlayerServerId(id)
            table.insert(server_ids, server_id)
        end

    end

    return get_target_character_id_batch(server_ids)

end

function get_character_name()

    return loaded_character["character"]["first_name"] .. " " .. loaded_character["character"]["last_name"]

end

function create_character(character)

    local created_character = nil
    character.player_id = get_player_id()

    trigger_server_callback("em_fw:create_character", 
    function(temp_character)

        created_character = temp_character

    end, character)

    return created_character["character_id"]

end

function delete_character(character_id)
    
    trigger_server_callback("em_fw:delete_character", function() end, character_id)

end

function get_all_characters()

    local player_characters = nil
    trigger_server_callback("em_fw:get_all_characters", function(all_characters)

        player_characters = all_characters["characters"]

    end, get_player_id())

    return player_characters

end

function load_character(character_id)

    trigger_server_callback("em_fw:get_character_info", function(retreived_character)

        loaded_character = retreived_character
        TriggerEvent("em_fw:character_loaded")

    end, character_id)
    character_storage = nil

    return loaded_character

end

function get_character_gender()

    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then

        return "male"

    elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then

        return "female"

    end
    
    return "male"

end


RegisterNetEvent("em_fw:inventory_change")
AddEventHandler('em_fw:inventory_change', function()

    character_storage = nil

end)