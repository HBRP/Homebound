

function get_nearest_vehicle()

    local ped_coords  = GetEntityCoords(PlayerPedId())
    local closest_veh = 0
    local last_diff   = 10000000000
    for veh in enumerate_vehicles() do

        local veh_coords = GetEntityCoords(veh)
        local diff = #(ped_coords - veh_coords)
        if diff < last_diff then
            last_diff   = diff
            closest_veh = veh
        end

    end
    return closest_veh

end

function get_all_vehicle_models_async(callback)

    trigger_server_callback_async("em_dal:get_all_vehicle_models", callback)

end