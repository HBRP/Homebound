
function appchat_get_messages_async(callback, channel)

	trigger_server_callback_async("em_dal:appchat_get_messages_async", callback, channel)

end

function appchat_send_message_async(callback, channel, message)

	trigger_server_callback_async("em_dal:appchat_send_message", callback, channel, message)

end