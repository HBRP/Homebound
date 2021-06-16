

exports["em_dal"]:register_server_callback("em_commands:kick_character", function(source, callback, character_id, message)

	local source = exports["em_dal"]:get_server_id_from_character_id(character_id)

	if source == nil then
		callback("Character not on server. Try again?")
		return
	end

	DropPlayer(source, message)
	callback("Character kicked")

end)