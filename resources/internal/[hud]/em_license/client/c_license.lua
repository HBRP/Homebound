

exports["em_items"]:register_item_use("drivers license", function(storage_item_id, item_metadata)


    exports["em_fw"]:trigger_proximity_event("em_license:show_license", 10.0, item_metadata)


end)

RegisterNetEvent("em_license:show_license")
AddEventHandler("em_license:show_license", function(item_metadata) 


end)