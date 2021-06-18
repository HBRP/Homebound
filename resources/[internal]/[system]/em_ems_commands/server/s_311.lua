

RegisterServerEvent("em_ems_commands:311")
AddEventHandler("em_ems_commands:311", function(message, coords)

	local law_enforcement = exports["em_dal"]:get_all_characters_with_group_name("Law Enforcement")
	local ems = exports["em_dal"]:get_all_characters_with_group_name("Emergency Medical Services")

	for i = 1, #law_enforcement do
		TriggerClientEvent("em_ems_commands:311", law_enforcement[i].source, source, message, coords)
	end

	for i = 1, #ems do
		TriggerClientEvent("em_ems_commands:311", ems[i].source, source, message, coords)
	end

end)

RegisterServerEvent("em_ems_commands:311r")
RegisterServerEvent("em_ems_commands:311r", function(to_source, message)

	local law_enforcement = exports["em_dal"]:get_all_characters_with_group_name("Law Enforcement")
	local ems = exports["em_dal"]:get_all_characters_with_group_name("Emergency Medical Services")

	TriggerClientEvent("em_ems_commands:311r", to_source, source, message)

	for i = 1, #law_enforcement do
		TriggerClientEvent("em_ems_commands:311r", law_enforcement[i].source, to_source, message)
	end

	for i = 1, #ems do
		TriggerClientEvent("em_ems_commands:311r", ems[i].source, to_source, message)
	end

end)