

function get_recipes_async(callback)

	trigger_server_callback_async("em_dal:get_recipes", callback)

end

function get_context_recipes_async(callback)

	trigger_server_callback_async("em_dal:get_context_recipes", callback)

end