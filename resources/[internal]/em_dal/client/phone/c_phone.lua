

function phone_get_phone_data_async(callback)

	trigger_server_callback_async("em_dal:phone_get_phone_data", callback)

end

function phone_delete_messages_async(callback, phone_number)

	trigger_server_callback_async("em_dal:phone_delete_messages", callback, phone_number)

end

function phone_delete_all_messages_async(callback)

	trigger_server_callback_async("em_dal:delete_all_messages", callback)

end

function phone_new_message_async(callback, phone_number, message)

	trigger_server_callback_async("em_dal:phone_new_message", callback, phone_number, message)

end

function phone_get_messages_async(callback)

	trigger_server_callback_async("em_dal:phone_get_messages", callback)

end

function phone_mark_messages_read_async(callback, phone_number)

	trigger_server_callback_async("em_dal:phone_mark_messages_read", callback, phone_number)

end

function phone_new_contact_async(callback, phone_number, phone_contact_name)

	trigger_server_callback_async("em_dal:phone_new_contact", callback, phone_number, phone_contact_name)

end

function phone_get_contacts_async(callback)

	trigger_server_callback_async("em_dal:phone_get_contacts", callback)

end

function phone_delete_contact_async(callback, phone_contact_id)

	trigger_server_callback_async("em_dal:phone_delete_contact", callback, phone_contact_id)

end

function phone_update_contact_async(callback, phone_contact_id, phone_number, phone_contact_name)

	trigger_server_callback_async("em_dal:phone_update_contact", callback, phone_contact_id, phone_number, phone_contact_name)

end