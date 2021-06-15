
local recipes_cache = {}

local function set_recipes(recipes)

	for i = 1, #recipes do
		for j = 1, #recipes[i].inputs do
			recipes[i].inputs[j].itemname = exports["em_items"]:get_item_name_from_item_id(recipes[i].inputs[j].itemid)
		end
		for j = 1, #recipes[i].outputs do
			recipes[i].outputs[j].itemname = exports["em_items"]:get_item_name_from_item_id(recipes[i].outputs[j].itemid)
		end
	end
	recipes_cache = recipes

end

function open_crafting(context)

	local crafting_function = nil

	if context == 0 or context == nil then
		crafting_function = function(callback) exports["em_dal"]:get_recipes_async(callback) end
	else
		crafting_function = function(callback, context) exports["em_dal"]:get_context_recipes_async(callback, context) end
	end

	crafting_function(function(recipes)

		set_recipes(recipes)
		local inventory = exports["em_dal"]:get_character_storage()["storage_items"]
		SendNUIMessage({display = true, inventory = inventory, recipes = recipes, title = "Personal Crafting"})
		SetNuiFocus(true, true)

	end, context)

end

exports["em_commands"]:register_command("test_crafting", function()

	open_crafting()

end)

RegisterNUICallback("craft", function(data, cb)

	if data.amount == 0 then
		return
	end

	local inputs  = data.recipe.inputs
	local outputs = data.recipe.outputs
	local storage_id = exports["em_dal"]:get_character_storage_id()

	for i = 1, #inputs do
		exports["em_dal"]:remove_any_item(storage_id, inputs[i].itemid, inputs[i].amount * data.amount)
	end

	for i = 1, #outputs do
		exports["t-notify"]:Alert({style = "success", message = string.format("Made %d %s", outputs[i].amount * data.amount, outputs[i].itemname)})
		exports["em_dal"]:give_item(storage_id, outputs[i].itemid, outputs[i].amount * data.amount, -1, -1)
	end

	local inventory = exports["em_dal"]:get_character_storage()["storage_items"]
	SendNUIMessage({display = true, inventory = inventory, recipes = recipes_cache, title = "Personal Crafting"})
	SetNuiFocus(true, true)

end)

RegisterNUICallback("close", function(data, cb)

	SetNuiFocus(false, false)
	cb(true)

end)

RegisterNUICallback("notify", function(data, cb)

	exports["t-notify"]:Alert(data)

end)

RegisterCommand('crafting_tab', open_crafting, false)
RegisterKeyMapping('crafting_tab', 'crafting_tab', 'keyboard', 'TAB')