
local function repair_vehicle()

    exports["em_dialog"]:hide_dialog()

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then

        veh = exports["em_fw"]:get_nearest_vehicle()
        if veh == 0 or #(GetEntityCoords(veh) - GetEntityCoords(PlayerPedId())) > 5.0 then

            exports['t-notify']:Alert({style = "error", message = "No close enough vehicle"})
            return

        end

    end
    exports["em_transactions"]:remove_cash(2000)

    exports["rprogress"]:Custom({
        Async    = false,
        Duration = 1000 * 60,
        Label = "Repairing vehicle"
    })

    exports["em_vehicles"]:repair_vehicle(veh)

end

AddEventHandler("expensive_mech", function(ped, entity)

    local cash_on_hand = exports["em_transactions"]:get_cash_on_hand()
    local response = "Yeah, cash only though."
    local callback = repair_vehicle

    if cash_on_hand < 2000 then

        response = "I would, but you're looking a little short."
        callback = function()
            exports["em_dialog"]:hide_dialog()
        end

    end

    local ped_dialog = {
        {
            dialog = "Could you repair my vehicle? ($2000)",
            response = response,
            callback = callback
        }
    }
    exports["em_dialog"]:show_dialog(ped.ped_name, ped_dialog)

end)