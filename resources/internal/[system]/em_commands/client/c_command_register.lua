

function register_command(command, callback, ...)

    RegisterCommand(command, function (source, args, raw)

        if exports["em_dal"]:can_use_command(command, table.concat(args, " ")) then
            callback(source, args, raw)
        else
            exports['t-notify']:Alert({style = 'error', message = "Cannot use command"})
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