

local server_callbacks = {}

local function find_server_callback(event)

    for i = 1, #server_callbacks do
        if server_callbacks[i].event == event then
            return server_callbacks[i].callback
        end
    end
    return nil

end

local function handle_callback(source, callback_id, callback, args)

    callback(source, 
    function(...) 

        TriggerClientEvent("em_dal:server_callback:response", source, callback_id, ...)

    end, table.unpack(args))

end

RegisterServerEvent('em_dal:server_callback')
AddEventHandler('em_dal:server_callback', function(event, callback_id, ...)

    local source = source
    local callback = find_server_callback(event)

    if callback == nil then
        Citizen.Trace(event .. " callback was nil. Check if properly registered\n")
        return
    end

    handle_callback(source, callback_id, callback, {...})

end)


function register_server_callback(event, callback)

    for i = 1, #server_callbacks do
        if server_callbacks[i].event == event then
            Citizen.Trace("Replacing identical server_callback " .. event .. "\n")
            server_callbacks[i].callback = callback
            return
        end
    end

    table.insert(server_callbacks, {event = event, callback = callback})

end