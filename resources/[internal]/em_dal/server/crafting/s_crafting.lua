

register_server_callback("em_dal:get_recipes", function(source, callback)

	local endpoint = string.format("/Crafting/Recipes/%d", get_character_id_from_source(source))
	HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_context_recipes", function(source, callback, context)

    local data = {character_id = get_character_id_from_source(source), context = context}
	HttpGetSim("/Crafting/ContextRecipes", data, callback)

end)