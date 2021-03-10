
local loaded_character = nil

function get_character_id()

    return loaded_character["character"]["character_id"]

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
    
    deleted_character = false
    TriggerServerEvent("em_fw:delete_character", character_id)
    while not deleted_character do
        Citizen.Wait(100)
    end

end

RegisterNetEvent("em_fw:delete_character:response")
AddEventHandler("em_fw:delete_character:response", function()

    deleted_character = true

end)

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

    return loaded_character

end

RegisterCommand("pos", function(source, args, rawCommand)
    print(json.encode(GetEntityCoords(PlayerPedId())))
end, false)