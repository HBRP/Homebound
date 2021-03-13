

function register_command(command, callback, ...)

    RegisterCommand(command, function (source, args, raw)

        if exports["em_fw"]:can_use_command(command) then
            callback(source, args, raw)
        end

    end)

    TriggerEvent('chat:addSuggestion', "/" .. command, ...)

end