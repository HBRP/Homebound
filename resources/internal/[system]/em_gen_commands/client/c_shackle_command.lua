
local shackled = false
local other_player_shackled = nil

local function is_other_character_shackled(character_id)

    other_player_shackled = nil
    exports["em_fw"]:trigger_event_for_character("em_gen_commands:is_shackled_request", character_id, exports["em_fw"]:get_character_id())

    while other_player_shackled == nil do
        Citizen.Wait(50)
    end

    local temp = other_player_shackled
    other_player_shackled = nil

    return temp

end

exports["em_commands"]:register_command_no_perms("shackle", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then

            if is_other_character_shackled(character_id) then
                exports['t-notify']:Alert({style = "error", message = "Character already shackled"})
                return
            end

            local item_id = exports["em_items"]:get_item_id_from_name("shackles")
            local storage_item_id = exports["em_items"]:get_character_storage_item_id(item_id)

            if storage_item_id == 0 then
                exports["t-notify"]:Alert({style="error", message = "You don't have shackles"})
                return
            end

            exports["em_animations"]:play_animation_sync("mp_arrest_paired", "cop_p2_back_right", 2000, 16)
            exports["em_fw"]:trigger_event_for_character("em_gen_commands:shackle_request", character_id)
            exports["em_fw"]:remove_item(storage_item_id, 1)

        else

            exports["t-notify"]:Alert({style="error", message = "character isn't even around you"})

        end

    end, character_id, 5.0)

end, "Shakle someone's feet", {{name = "character_id", help = "try /ids to find a character_id"}})


local function give_shackles_back()

    local item_id = exports["em_items"]:get_item_id_from_name("shackles")
    local storage_id = exports["em_fw"]:get_character_storage_id()
    local response = exports["em_fw"]:give_item(storage_id, item_id, 1, -1, -1)

    if not response.response.success then
        print(response)
    end

end

exports["em_commands"]:register_command_no_perms("unshackle", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then

            if not is_other_character_shackled(character_id) then
                exports['t-notify']:Alert({style = "error", message = "Character isn't shackled"})
                return
            end

            local item_id = exports["em_items"]:get_item_id_from_name("handcuff keys")
            local storage_item_id = exports["em_items"]:get_character_storage_item_id(item_id)

            if storage_item_id == 0 then
                exports["t-notify"]:Alert({style="error", message = "You don't have handcuff keys"})
                return
            end

            exports["em_animations"]:play_animation_sync("mp_arresting", "a_uncuff", 2000, 16)
            exports["em_fw"]:trigger_event_for_character("em_gen_commands:unshackle_request", character_id)
            give_shackles_back()

        else

            exports["t-notify"]:Alert({style="error", message = "character isn't even around you"})

        end

    end, character_id, 5.0)

end,  "Unshakle someone's feet", {{name = "character_id", help = "try /ids to find a character_id"}})

RegisterNetEvent("em_gen_commands:shackle_request")
AddEventHandler("em_gen_commands:shackle_request", function()

    if shackled then
        return
    end
    shackled = true

    Citizen.CreateThread(function()

        while shackled do

            Citizen.Wait(5)
            if IsPedJumping(PlayerPedId()) or IsPedRunning(PlayerPedId()) then
                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
            end
            SetPedMoveRateOverride(PlayerPedId(), 0.5)

        end

    end)

end)

RegisterNetEvent("em_gen_commands:unshackle_request")
AddEventHandler("em_gen_commands:unshackle_request", function()

    if not shackled then
        return
    end

    shackled = false

end)

RegisterNetEvent("em_gen_commands:is_shackled_request")
AddEventHandler("em_gen_commands:is_shackled_request", function(other_character_id)

    exports["em_fw"]:trigger_event_for_character("em_gen_commands:is_shackled_response", other_character_id, shackled)

end)

RegisterNetEvent("em_gen_commands:is_shackled_response")
AddEventHandler("em_gen_commands:is_shackled_response", function(is_shackled)

    other_player_shackled = is_shackled

end)

function is_shackled()

    return shackled

end
