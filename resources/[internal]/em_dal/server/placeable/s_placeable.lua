
register_server_callback("em_dal:placeable_get_placed_props", function(source, callback, x, y, z)

	local endpoint = string.format("/Placeable/PlacedProps/%.2f/%.2f/%.2f", x, y, z)
	HttpGetSim(endpoint, nil, callback)

end)

register_server_callback("em_dal:placeable_insert_prop", function(source, callback, prop_id, x, y, z, metadata)

	local data = {
		character_id = get_character_id_from_source(source),
		prop_id = prop_id,
		x = x,
		y = y,
		z = z,
		metadata = metadata
	}
	HttpPostSim("/Placeable/Place", data, callback)

end)