
RegisterNetEvent("em_commands:propagate_to_clients")
AddEventHandler("em_commands:propagate_to_clients", function(content) 

    TriggerClientEvent('chat:addMessage', -1, content)

end)

RegisterNetEvent("em_commands:propagate_to_nearby_clients")
AddEventHandler("em_commands:propagate_to_nearby_clients", function(content, proximity) 

    TriggerClientEvent('em_commands:propagate_to_nearby_clients:response', -1, source, content, proximity)

end)

exports["em_dal"]:register_server_callback("em_commands:camera_rotation", function(source, callback)

    callback(GetPlayerCameraRotation(source))

end)