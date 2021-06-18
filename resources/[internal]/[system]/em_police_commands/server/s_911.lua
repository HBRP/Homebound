

RegisterServerEvent("em_police_commands:911")
AddEventHandler("em_police_commands:911", function(message, coords)

	local character_jobs = exports["em_dal"]:get_all_characters_with_group_name("Law Enforcement")

	for i = 1, #character_jobs do
		TriggerClientEvent("em_police_commands:911", character_jobs[i].source, source, message, coords)
	end

end)

RegisterServerEvent("em_police_commands:911r")
RegisterServerEvent("em_police_commands:911r", function(to_source, message)

	local character_jobs = exports["em_dal"]:get_all_characters_with_group_name("Law Enforcement")

	TriggerClientEvent("em_police_commands:911r", to_source, source, message)

	for i = 1, #character_jobs do
		TriggerClientEvent("em_police_commands:911r", character_jobs[i].source, to_source, message)
	end

end)