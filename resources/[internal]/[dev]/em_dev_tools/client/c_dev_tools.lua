


local raycasting = false
RegisterCommand("show_object_raycast", function()

    raycasting = not raycasting

    if not raycasting then
        return
    end

    local last_entity = 0
    Citizen.CreateThread(function()

        while raycasting do
            Citizen.Wait(5)

            local hit, coords, entity = table.unpack(exports["em_dal"]:ray_cast_game_play_camera(1000.0))

            if hit then
                local position = GetEntityCoords(GetPlayerPed(-1))
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
            end

            if entity ~= 0 and GetEntityType(entity) ~= 0 then

                local successful, return_value = pcall(GetEntityModel, entity)
                if successful and last_entity ~= entity then

                    last_entity = entity
                    local object_name = exports["ObjectNameFromHash"]:get_object_name(return_value)
                    print(GetEntityCoords(entity))
                    print(GetEntityHeading(entity))
                    Citizen.Trace(string.format("hash: %d, name: %s\n", return_value, object_name or "nil"))

                end

            end
        end
    end)
end, false)

RegisterCommand("create_ped", function(source, args, raw_command)

    local hash = GetHashKey(args[1])

    print(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

    local player_coords = GetEntityCoords(PlayerPedId())
    CreatePed(29, hash, player_coords.x + 1, player_coords.y + 1, player_coords.z + 1, true, true, true)

end, false)

RegisterCommand("create_object", function(source, args, raw_command)

    local hash = GetHashKey(args[1])

    print(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

    local player_coords = GetEntityCoords(PlayerPedId())
    local x = args[2] or player_coords.x
    local y = args[3] or player_coords.y
    local z = args[4] or player_coords.z

    local obj = CreateObject(hash, x + 1, y + 1, z + 1, false, true, false)
    FreezeEntityPosition(obj, true)

    if args[5] then
        SetEntityHeading(obj, args[5])
    end
    Citizen.Trace(string.format("Heading: %.02f", GetEntityHeading(obj)))

end, false)

RegisterCommand("veh_data", function(source, args, raw_command)

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then

        local vehicle_mods  = exports["em_vehicles"]:get_vehicle_mods(veh)
        local vehicle_state = exports["em_vehicles"]:get_vehicle_state(veh)

        Citizen.Trace("Vehicle mods : " ..json.encode(vehicle_mods) .. "\n")
        Citizen.Trace("Vehicle state : " .. json.encode(vehicle_state) .. "\n")

    end

end, false)

RegisterCommand("object_hash", function(source, args, raw_command)

    if #args > 0 then
        Citizen.Trace(string.format("('%s', %d)\n", args[1], GetHashKey(args[1])))
    end

end, false)