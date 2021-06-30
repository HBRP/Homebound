
function placeable_get_placed_props_async(callback)

	local x, y, z = unpack(GetEntityCoords(PlayerPedId()))
	trigger_server_callback_async("em_dal:placeable_get_placed_props", callback, x, y, z)


end

function placeable_insert_prop_async(callback, prop_id, metadata)

	local x, y, z = unpack(GetEntityCoords(PlayerPedId()))
	trigger_server_callback_async("em_dal:placeable_insert_prop", callback, prop_id, x, y, z, metadata)

end