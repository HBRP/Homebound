RegisterNetEvent("gcPhone:tchat_receive")
AddEventHandler("gcPhone:tchat_receive", function(message)
    SendNUIMessage({ event = 'tchat_receive', message = message })
    cb(true)
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)

    exports["em_dal"]:appchat_send_message_async(function(response)

        data.time = response.time_sent
        TriggerServerEvent("gcPhone:tchat_propagate_new_message", data)

    end, data.channel, data.message)
    cb(true)

end)

RegisterNUICallback('tchat_getChannel', function(data, cb)

    exports["em_dal"]:appchat_get_messages_async(function(messages)

        for i = 1, #messages do
            messages[i].time = messages[i].time_sent
        end

        SendNUIMessage({ event = 'tchat_channel', messages = messages })
    end, data.channel)
    cb(true)

end)
