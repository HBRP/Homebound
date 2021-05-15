
exports["em_commands"]:register_command("heal", function(source, args, command)

    if #args < 1 then
        exports["t-notify"]:Alert({style = "error", message = "No character specified"})
    end

    exports["em_dal"]:trigger_event_for_character("em_ems_commands:heal_event", tonumber(args[1]))

end, "Heal another character", {{name = "character_id", help = "try /ids to find a character_id"}})


RegisterNetEvent("em_ems_commands:heal_event")
AddEventHandler("em_ems_commands:heal_event", function()

    exports["em_medical"]:heal_player()
    exports["t-notify"]:Alert({style = "info", message = "You've been healed!"})

end)