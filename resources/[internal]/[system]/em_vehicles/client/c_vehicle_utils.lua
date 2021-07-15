
function get_closest_vehicle()

    local closest_vehicle = -1
    local vehicle_distance = 100000000
    local ped_coords       = GetEntityCoords(PlayerPedId())

    for veh in exports["em_dal"]:enumerate_vehicles() do

        local distance = #(ped_coords - GetEntityCoords(veh))
        if distance < vehicle_distance then
            closest_vehicle  = veh
            vehicle_distance = distance
        end

    end

    return {closest_vehicle, vehicle_distance}

end