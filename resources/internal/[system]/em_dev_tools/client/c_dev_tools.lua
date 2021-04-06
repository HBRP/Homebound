

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(5)

        local hit, coords, entity = table.unpack(exports["em_fw"]:ray_cast_game_play_camera(1000.0))

        if hit then
            local position = GetEntityCoords(GetPlayerPed(-1))
            DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
        end

--[[
        if entity ~= 0 then
            print(entity)
            local successful, return_value = pcall(GetEntityModel, entity)
            if successful then
                local object_name = exports["ObjectNameFromHash"]:get_object_name(return_value)
                if object_name ~= nil then
                    print(object_name)
                end
            end
        end
]]

    end
end)