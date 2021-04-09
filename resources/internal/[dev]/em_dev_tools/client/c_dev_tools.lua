


local raycasting = false
RegisterCommand("show_object_raycast", function()

    raycasting = not raycasting

    if not raycasting then
        return
    end

    Citizen.CreateThread(function()

        while raycasting do
            Citizen.Wait(5)

            local hit, coords, entity = table.unpack(exports["em_fw"]:ray_cast_game_play_camera(1000.0))

            if hit then
                local position = GetEntityCoords(GetPlayerPed(-1))
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
            end

            if entity ~= 0 then
                local successful, return_value = pcall(GetEntityModel, entity)
                if successful then
                    local object_name = exports["ObjectNameFromHash"]:get_object_name(return_value)
                    if object_name ~= nil then
                        print(GetEntityCoords(entity))
                        print(GetEntityHeading(entity))
                        Citizen.Trace(string.format("hash: %d, name: %s\n", return_value, object_name))
                    end
                end
            end
        end
    end)
end, false)

RegisterCommand("create_object", function(source, args, raw_command)

    local hash = GetHashKey(args[1])

    print(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(5)
    end

    local player_coords = GetEntityCoords(PlayerPedId())
    CreatePed(29, hash, player_coords.x + 1, player_coords.y + 1, player_coords.z + 1, true, true, true)

end, false)