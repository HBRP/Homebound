
local function browse_basic_selection()

    exports["em_dialog"]:hide_dialog()
    exports["em_fw"]:get_vehicle_store_stock_async(function(result)

        TriggerEvent("OpenVehicleShop", result)

    end, "PDM%20Basic")

end

AddEventHandler("pdm_worker", function(ped, entity)

    local ped_dialog = {
        {
            dialog = "Browse basic selection",
            response = "Sure thing.",
            callback = browse_basic_selection
        }
    }
    exports["em_dialog"]:show_dialog(ped.ped_name, ped_dialog)

end)