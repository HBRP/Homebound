
local form_callback = nil

function display_form(callback, title, form)

	form_callback = callback
	SendNUIMessage({title = title, form = form, display = true})
	SetNuiFocus(true, true)

end

function get_form_value(form, input_name)

	for i = 1, #form do

		if form[i].input_name == input_name then

			return form[i].value

		end

	end
	assert(0 == 1, string.format("Could not find input value for %s", input_name))

end

RegisterNUICallback("submit", function(data, cb)

	form_callback(data)
	cb()

end)

RegisterNUICallback("quit", function(data, cb)

	SetNuiFocus(false, false)
	cb()

end)

RegisterCommand("test_form", function(source, args, raw_command)

	local test_form = {

		{
			input_type = "text_input",
			input_name = "test_this_form",
			placeholder = "testing_this_form_placeholder",
			options = {},
			numbers_valid = true,
			characters_valid =  false,
			optional = false
		},
		{
			input_type = "dropdown",
			input_name =  "dropdown_form",
			options =  {"first option", "second option", "third option"}
		},
		{
			input_type = "radiobutton",
			input_name =  "radio_button",
			options =  {"first option", "second option", "third option"}
		}

	}

	display_form(function(inputs)

		print(json.encode(inputs))
		print(get_form_value(inputs, "dropdown_form"))

	end, "test_form_title", test_form)

end)