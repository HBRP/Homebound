
local function repair_vehicle_context()

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then
        return nil
    end

    return {
        dialog = "Repair Vehicle",
        callback = function()
            exports["em_dialog"]:hide_dialog()
            TriggerEvent("PlaySoundForEveryoneInVicinity", "sounds/Repair/repair.mp3")
            exports["rprogress"]:Custom({
                Async    = false,
                Duration = 1000 * 2,
                Label = "Repairing vehicle."
            })
            exports["em_vehicles"]:repair_vehicle(veh)
        end
    }

end

register_context("Law Enforcement Repair", repair_vehicle_context)
register_context("Medical Services Repair", repair_vehicle_context)