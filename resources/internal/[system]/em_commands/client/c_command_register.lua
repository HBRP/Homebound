

function register_command(command, callback, ...)

    RegisterCommand(command, function (source, args, raw)

        if exports["em_fw"]:can_use_command(command) then
            callback(source, args, raw)
        else
            exports['swt_notifications']:Negative("Command", 'Cannot use command', "top", 2000, true)
        end

    end)

    TriggerEvent('chat:addSuggestion', "/" .. command, ...)

end

function register_command_no_perms(command, callback, ...)

    RegisterCommand(command, function (source, args, raw)

        callback(source, args, raw)

    end)

    TriggerEvent('chat:addSuggestion', "/" .. command, ...)

end