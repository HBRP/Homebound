

local callback_id = 0
local callbacks = {}

local function find_callbacks_index(callback_id)

    for i = 1, #callbacks do
        if callbacks[i].callback_id == callback_id then
            return i
        end
    end
    assert(0, "Unable to find callback_id")

end

function trigger_server_callback(event, callback, ...)

    local callback_event = {callback_id = callback_id, callback = callback, event_returned = false, arg = nil, async = false}
    table.insert(callbacks, callback_event)
    callback_id = callback_id + 1

    TriggerServerEvent("em_fw:server_callback", event, callback_event.callback_id, ...)
    while not callback_event.event_returned do

        Citizen.Wait(0)

    end
    callback(table.unpack(callback_event.arg))
    table.remove(callbacks, find_callbacks_index(callback_event.callback_id))

end

function trigger_server_callback_async(event, callback, ...)

    local callback_event = {callback_id = callback_id, callback = callback, event_returned = false, arg = nil, async = true}
    table.insert(callbacks, callback_event)
    callback_id = callback_id + 1
    TriggerServerEvent("em_fw:server_callback", event, callback_event.callback_id, ...)

end

RegisterNetEvent("em_fw:server_callback:response")
AddEventHandler("em_fw:server_callback:response", function(callback_id, ...)

    local idx = find_callbacks_index(callback_id)
    callbacks[idx].arg = {...}
    callbacks[idx].event_returned = true

    if callbacks[idx].async then

        if callbacks[idx].callback ~= nil then
            callbacks[idx].callback(table.unpack(callbacks[idx].arg))
        end
        
        table.remove(callbacks, find_callbacks_index(callback_id))
    end

end)