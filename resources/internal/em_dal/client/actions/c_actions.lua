
function can_do_action(action)

	local can_use = false
	trigger_server_callback("em_dal:can_do_action", function(result)

		can_use = result.can_use

	end, action)

	return can_use

end

function can_do_action_async(callback, action)

	trigger_server_callback_async("em_dal:can_do_action", callback, action)

end