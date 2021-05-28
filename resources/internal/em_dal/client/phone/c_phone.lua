

function get_phone_data_async(callback)

	trigger_server_callback_async("em_dal:get_phone_data", callback)

end

function delete_messages_async(transmitter_phone, receiving_phone)

	trigger_server_callback_async("em_dal:delete_messages", function() end, transmitter_phone, receiving_phone)

end