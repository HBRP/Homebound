
local player_characters = {}


local retrieved_characters = false
local finished_creating_character = false

function get_character_id()

    return character["character_id"]

end

local current_character = {}
function create_character(character)

    finished_creating_character = false
    character.player_id = get_player_id()
    TriggerServerEvent("em_fw:create_character", character)

    while not finished_creating_character do
        Citizen.Wait(5)
    end

    return current_character

end

RegisterNetEvent("em_fw:create_character:response")
AddEventHandler("em_fw:create_character:response", function(character)

    finished_creating_character = true
    current_character = character

end)

function delete_character(character_id)

    for i = 1, #player_characters do
        if player_characters[i].character_id == character_id then
            table.remove(player_characters, i)
            break
        end
    end
    
    TriggerServerEvent("DeleteCharacter", character_id)

end

function get_all_characters()

    return player_characters

end





function get_all_characters()

    retrieved_characters = false
    TriggerServerEvent("em_fw:get_all_characters", get_player_id())
    while not retrieved_characters do
        Citizen.Wait(100)
    end

    return player_characters

end


RegisterNetEvent("em_fw:get_all_characters:response")
AddEventHandler("em_fw:get_all_characters:response", function(characters)

    retrieved_characters = true
    player_characters = characters["characters"]

end)

local loaded_character = nil
function load_character(character_id)

    loaded_character = nil
    TriggerServerEvent("em_fw:get_character_info", character_id)
    while not loaded_character do
        Citizen.Wait(100)
    end
    return loaded_character

end

RegisterNetEvent("em_fw:get_character_info:response")
AddEventHandler("em_fw:get_character_info:response", function(character)

    assert(character, "em_fw:get_character_info:response received nil character")
    loaded_character = character

end)

RegisterCommand("pos", function(source, args, rawCommand)
    print(json.encode(GetEntityCoords(PlayerPedId())))
end, false)