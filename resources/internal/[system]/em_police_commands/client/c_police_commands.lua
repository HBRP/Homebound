

exports["em_commands"]:register_command_no_perms("cuff", function(source, args, raw_command)


end, "Cuff someone", {{name = "character_id", help = "try /ids to find a character_id"}})

exports["em_commands"]:register_command_no_perms("shackle", function(source, args, raw_command)


end, "Shakle someone's feet", {{name = "character_id", help = "try /ids to find a character_id"}})


exports["em_commands"]:register_command("search", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then
            exports["em_fw"]:trigger_event_for_character("em_police_commands:search_request", character_id, exports["em_fw"]:get_character_id())
        else
            exports["t-notify"]:Alert({style="error", message = "Character isn't even around you"})
        end

    end, character_id, 5.0)

end, "Search someone's pockets", {{name = "character_id", help = "try /ids to find a character_id"}})

RegisterNetEvent("em_police_commands:search_request")
AddEventHandler("em_police_commands:search_request", function(response_character_id)

    exports["em_fw"]:trigger_event_for_character("em_police_commands:search_response", response_character_id, exports["em_fw"]:get_character_storage_id())

end)

RegisterNetEvent("em_police_commands:search_response")
AddEventHandler("em_police_commands:search_response", function(storage_id)

    TriggerEvent("esx_inventoryhud:open_secondary_inventory", storage_id, "Pockets")

end)

exports["em_commands"]:register_command("frisk", function(source, args, raw_command)

    if #args == 0 then
        return
    end
    local character_id = tonumber(args[1])

    exports["em_fw"]:is_character_id_in_radius_async(function(is_in_range) 

        if is_in_range then
            exports["em_fw"]:trigger_event_for_character("em_police_commands:frisk_request", character_id, exports["em_fw"]:get_character_id())
        else
            exports["t-notify"]:Alert({style="error", message = "Character isn't even around you"})
        end

    end, character_id, 5.0)

end, "Frisk someone for a gun", {{name = "character_id", help = "try /ids to find a character_id"}})

RegisterNetEvent("em_police_commands:frisk_request")
AddEventHandler("em_police_commands:frisk_request", function(response_character_id)

    local has_weapon = exports["em_items"]:does_character_have_a_weapon()
    exports["em_fw"]:trigger_event_for_character("em_police_commands:frisk_response", response_character_id, has_weapon)

end)

RegisterNetEvent("em_police_commands:frisk_response")
AddEventHandler("em_police_commands:frisk_response", function(has_weapon)

    if has_weapon then
        exports["t-notify"]:Alert({style="info", message = "You feel something"})
    else
        exports["t-notify"]:Alert({style="info", message = "You don't feel anything"})
    end

end)
