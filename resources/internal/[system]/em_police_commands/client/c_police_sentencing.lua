
local function sentence_player(result)

	local character_id = exports["em_form"]:get_form_number(result, "State ID")
	local time = exports["em_form"]:get_form_number(result, "Time")
	local fine = exports["em_form"]:get_form_number(result, "Fine")

	exports["em_dal"]:trigger_event_for_character("em_police_commands:teleport_to_prison", character_id)

end

RegisterNetEvent("em_police_commands:teleport_to_prison")
AddEventHandler("em_police_commands:teleport_to_prison", function()

	SetEntityCoords(PlayerPedId(), 1774.039185, 2545.649170, 45.586483)
	SetEntityHeading(PlayerPedId(), 120.12)

end)

local function sentencing()

	local form_inputs = {

		{
			input_type = "text_input",
			input_name = "State ID",
			placeholder = "The character id/state id",
			numbers_valid = true,
			characters_valid =  false,
			optional = false
		},
		{
			input_type = "text_input",
			input_name = "Time",
			placeholder = "Time to sentence",
			numbers_valid = true,
			characters_valid =  false,
			optional = false
		},
		{
			input_type = "text_input",
			input_name = "Fine",
			placeholder = "Fine amount",
			numbers_valid = true,
			characters_valid =  false,
			optional = false
		}

	}
	exports["em_form"]:display_form(sentence_player, "Sentencing", form_inputs)

end

exports["em_commands"]:register_command("sentence", function(source, args, raw_command)

	sentencing()

end, "Sentence people to jail!")