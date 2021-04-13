local cuffed = false
local other_player_cuffed = nil

local function is_other_character_cuffed(character_id)

    other_player_cuffed = nil
    exports["em_fw"]:trigger_event_for_character("em_gen_commands:is_cuffed_request", character_id, exports["em_fw"]:get_character_id())

    while other_player_cuffed == nil do
        Citizen.Wait(50)
    end

    local temp = other_player_cuffed
    other_player_cuffed = nil

    return temp

end

exports["em_commands"]:register_command_no_perms("cuff", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then

            if is_other_character_cuffed(character_id) then
                exports['t-notify']:Alert({style = "error", message = "Character already cuffed"})
                return
            end

            local item_id = exports["em_items"]:get_item_id_from_name("handcuffs")
            local storage_item_id = exports["em_items"]:get_character_storage_item_id(item_id)

            if storage_item_id == 0 then
                exports["t-notify"]:Alert({style="error", message = "You don't have handcuffs"})
                return
            end

            exports["em_animations"]:play_animation_sync("mp_arrest_paired", "cop_p2_back_right", 2000, 16)
            exports["em_fw"]:trigger_event_for_character("em_gen_commands:cuff_request", character_id)
            exports["em_fw"]:remove_item(storage_item_id, 1)

        else

            exports["t-notify"]:Alert({style="error", message = "character isn't even around you"})

        end

    end, character_id, 5.0)

end, "Cuff someone", {{name = "character_id", help = "try /ids to find a character_id"}})


local function give_handcuffs_back()

    local item_id = exports["em_items"]:get_item_id_from_name("handcuffs")
    local storage_id = exports["em_fw"]:get_character_storage_id()
    local response = exports["em_fw"]:give_item(storage_id, item_id, 1, -1, -1)

    if not response.response.success then
        print(response)
    end

end

exports["em_commands"]:register_command_no_perms("uncuff", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then

            if not is_other_character_cuffed(character_id) then
                exports['t-notify']:Alert({style = "error", message = "Character isn't handcuffed"})
                return
            end

            local item_id = exports["em_items"]:get_item_id_from_name("handcuff keys")
            local storage_item_id = exports["em_items"]:get_character_storage_item_id(item_id)

            if storage_item_id == 0 then
                exports["t-notify"]:Alert({style="error", message = "You don't have handcuff keys"})
                return
            end

            exports["em_animations"]:play_animation_sync("mp_arresting", "a_uncuff", 2000, 16)
            exports["em_fw"]:trigger_event_for_character("em_gen_commands:uncuff_request", character_id)
            give_handcuffs_back()

        else

            exports["t-notify"]:Alert({style="error", message = "character isn't even around you"})

        end

    end, character_id, 5.0)

end,  "Shackle someone", {{name = "character_id", help = "try /ids to find a character_id"}})

RegisterNetEvent("em_gen_commands:cuff_request")
AddEventHandler("em_gen_commands:cuff_request", function()

    if cuffed then
        return
    end
    cuffed = true

    SetEnableHandcuffs(PlayerPedId(), true)
    Citizen.CreateThread(function()

        exports["em_animations"]:play_animation_cont("mp_arresting", "idle", 2 + 16 + 32)
        while cuffed do

            if not GetIsTaskActive(PlayerPedId(), 134) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
                exports["em_animations"]:play_animation_cont("mp_arresting", "idle", 2 + 16 + 32)
            end
            Citizen.Wait(5000)

        end
    end)
    Citizen.CreateThread(function()

        while cuffed do

            Citizen.Wait(5)

            DisableControlAction(0, 23, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 63, true)
            DisableControlAction(0, 64, true)

            DisablePlayerFiring(PlayerId(), true)

            if GetIsTaskActive(PlayerPedId(), 1) then
                SetPedRagdollOnCollision(PlayerPedId(), true)
            end

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                DisableControlAction(0, 59, true)
            end

        end
        SetPedRagdollOnCollision(PlayerPedId(), false)
        SetEnableHandcuffs(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())
        SetPedPathCanUseLadders(PlayerPedId(), true)

    end)

end)

RegisterNetEvent("em_gen_commands:uncuff_request")
AddEventHandler("em_gen_commands:uncuff_request", function()

    if not cuffed then
        return
    end

    cuffed = false

end)

RegisterNetEvent("em_gen_commands:is_cuffed_request")
AddEventHandler("em_gen_commands:is_cuffed_request", function(other_character_id)

    exports["em_fw"]:trigger_event_for_character("em_gen_commands:is_cuffed_response", other_character_id, cuffed)

end)

RegisterNetEvent("em_gen_commands:is_cuffed_response")
AddEventHandler("em_gen_commands:is_cuffed_response", function(is_cuffed)

    other_player_cuffed = is_cuffed

end)

function is_handcuffed()

    return cuffed

end
