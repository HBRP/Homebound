
AddEventHandler("grocery_store", function(ped, entity)

	local dialog = {
		{
			dialog = "I'd like to see what you're selling",
			response = "Alright",
			callback = function()

	            exports["em_dal"]:get_store_items_async(function(store_items)

	                exports["em_dialog"]:hide_dialog()
	                TriggerEvent("esx_inventoryhud:open_store", {store_name = "Grocery Store"}, store_items)

	            end, store_type_ids.GROCERY_STORE)

			end
		}
	}
	exports["em_dialog"]:show_dialog(ped.ped_name, dialog)

end)