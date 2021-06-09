RegisterServerEvent('gcPhone:tchat_propagate_new_message')
AddEventHandler("gcPhone:tchat_propagate_new_message", function(message_blob)

  TriggerClientEvent('gcPhone:tchat_receive', -1, message_blob)

end)