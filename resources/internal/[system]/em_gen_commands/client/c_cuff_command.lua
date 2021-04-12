local cuffed = false

exports["em_commands"]:register_command_no_perms("cuff", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then

            local item_id = exports["em_items"]:get_item_id_from_name("handcuffs")
            local storage_item_id = exports["em_items"]:get_character_storage_item_id(item_id)

            if storage_item_id == 0 then
                exports["t-notify"]:Alert({style="error", message = "You don't have handcuffs"})
                return
            end

            exports["em_animations"]:play_animation_sync("mp_arrest_paired", "cop_p2_back_right", 2000, 16)
            exports["em_fw"]:trigger_event_for_character("em_gen_commands:cuff_request", character_id)

        else

            exports["t-notify"]:Alert({style="error", message = "character isn't even around you"})

        end

    end, character_id, 5.0)

end, "Cuff someone", {{name = "character_id", help = "try /ids to find a character_id"}})


RegisterNetEvent("em_gen_commands:cuff_request")
AddEventHandler("em_gen_commands:cuff_request", function()

    if cuffed then
        return
    end
    cuffed = true

    SetEnableHandcuffs(PlayerPedId(), true)
    Citizen.CreateThread(function()

        while cuffed do

            exports["em_animations"]:play_animation_sync("mp_arresting", "idle", 5000, 2 + 16 + 32)
            Citizen.Wait(1000)

        end
    end)
    Citizen.CreateThread(function()

        while cuffed do

            Citizen.Wait(5)

            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 63, true)
            DisableControlAction(0, 64, true)

            DisablePlayerFiring(PlayerId(), true)
            SetPedPathCanUseLadders(PlayerPedId(), false)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                DisableControlAction(0, 59, true)
            end

        end
        SetEnableHandcuffs(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())

    end)

end)

RegisterNetEvent("em_gen_commands:uncuff_request")
AddEventHandler("em_gen_commands:uncuff_request", function()

    if not cuffed then
        return
    end

    cuffed = false

end)

function is_handcuffed()

    return cuffed

end