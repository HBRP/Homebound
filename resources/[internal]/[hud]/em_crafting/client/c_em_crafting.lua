
local function open_crafting()

	exports["em_dal"]:get_recipes_async(function(recipes)

		for i = 1, #recipes do
			for j = 1, #recipes[i].inputs do
				recipes[i].inputs[j].itemname = exports["em_items"]:get_item_name_from_item_id(recipes[i].inputs[j].itemid)
			end
			for j = 1, #recipes[i].outputs do
				recipes[i].outputs[j].itemname = exports["em_items"]:get_item_name_from_item_id(recipes[i].outputs[j].itemid)
			end
		end

		local inventory = exports["em_dal"]:get_character_storage()["storage_items"]
		SendNUIMessage({display = true, inventory = inventory, recipes = recipes, title = "Personal Crafting"})
		SetNuiFocus(true, true)

	end)

end

exports["em_commands"]:register_command("test_crafting", function()

	open_crafting()

end)

RegisterNUICallback("close", function(data, cb)

	SetNuiFocus(false, false)
	cb(true)

end)