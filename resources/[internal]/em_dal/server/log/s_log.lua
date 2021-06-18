

function log_generic(source, log_key, log_info)

	local data = {
		character_id = get_character_id_from_source(source),
		log_key = log_key,
		log_info = log_info
	}
	HttpPutSim("/Log/Generic", data, function() end)

end