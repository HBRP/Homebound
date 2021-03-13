

local function clear_local_area_of_cops()

    local coords = GetEntityCoords(PlayerPedId())
    ClearAreaOfCops(coords.x, coords.y, coords.z , 1000, 0)

end

local function disable_dispatch_service()

    for i = 0, 15 do                                                        
        EnableDispatchService(i, false) 
    end

end

local function remove_vehicles_from_areas()

    RemoveVehiclesFromGeneratorsInArea(412.174, -1012.538, 32.0, 405.46, -975.148, 27.0) -- Mission Row Front Parking

end

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(500)
    end

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        clear_local_area_of_cops()
        disable_dispatch_service()
        remove_vehicles_from_areas()
    end

end)