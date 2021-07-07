
register_server_callback("em_dal:get_character_health", function(source, callback)

	local endpoint = string.format("/Character/Health/%d", get_character_id_from_source(source))
	HttpGetSim(endpoint, nil, callback)

end)

register_server_callback("em_dal:set_character_health", function(source, callback, health)

	local data = {character_id = get_character_id_from_source(source), health = health}
	HttpPutSim("/Character/SetHealth", data, callback)

end)