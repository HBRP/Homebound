local connectedPlayers = {}

function update_connected_players()

	local characters = exports["em_fw"]:get_current_character_ids()
	connectedPlayers = {}

	for i = 1, #characters do

		connectedPlayers[characters[i].source] = {
			ping = GetPlayerPing(characters[i].source),
			id = characters[i].character_id,
			name = exports["em_fw"]:get_steam_id(characters[i].source)
		}

	end
	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)

end

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(5000)
		update_connected_players()
	end

end)