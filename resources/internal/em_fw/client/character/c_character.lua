
local player_characters = {}
local character = {}

local retrieved_characters = false

function get_character_id()

    return character["character_id"]

end

function create_character(player_id, firstname, lastname, dob)

    player_characters[#player_characters + 1] = {player_id = player_id, firstname = firstname, lastname = lastname, dob = dob}
    TriggerServerEvent("CreateCharacter", player_id, firstname, lastname, dob)

end

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


RegisterNetEvent("CreateCharacter:Response")
AddEventHandler("CreateCharacter:Response", function()



end)


function init_all_characters()

    retrieved_characters = false
    TriggerServerEvent("GetAllCharacters", get_player_id())

end

function characters_were_init()

    return retrieved_characters

end


RegisterNetEvent("GetAllCharacters:Response")
AddEventHandler("GetAllCharacters:Response", function(characters)

    retrieved_characters = true
    player_characters = json.decode(characters)

end)


function load_character(character_id)

    TriggerServerEvent("GetCharacterInfo", character_id)

end

RegisterNetEvent("GetCharacterInfo:Response")
AddEventHandler("GetCharacterInfo:Response", function(characters)

    assert(characters, "GetCharacterInfo:Response received nil characters")
    character = json.decode(characters)
    set_character_health(character["health"])
    set_character_position(character["position"])

end)