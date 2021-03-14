

local function clear_local_area_of_cops()

    local coords = GetEntityCoords(PlayerPedId())
    ClearAreaOfCops(coords.x, coords.y, coords.z , 1000.0)

end

local function disable_dispatch_service()

    for i = 0, 15 do                                                        
        EnableDispatchService(i, false) 
    end

end


local function remove_vehicles_from_areas()

    RemoveVehiclesFromGeneratorsInArea(-448.381, -328.73, 34.50, -499.502, -346.43, 34.50) -- Mount Zonah
    RemoveVehiclesFromGeneratorsInArea(-629.365, -98.2345, 38.065, -643.37, -115.4596, 38.06) -- Government Center Fire department (DOES NOT WORK)
    RemoveVehiclesFromGeneratorsInArea(291.604, -566.823, 43.2608, 288.7409, -614.184, 43.422) -- Pillbox Medical
    RemoveVehiclesFromGeneratorsInArea(1837.8359, -3697.2387, 34.207, 1802.4299, 3682.012, 34.224) -- Sandy Medical
    RemoveVehiclesFromGeneratorsInArea(339.08, -1341.817, 32.4525, 326.145, -1491.701, 32.4525) -- Crusade Hospital (DOES NOT WORK)

end


local function never_wanted()
    SetPlayerWantedLevel(PlayerId(), 0, false)
    SetPlayerWantedLevelNow(PlayerId(), false)
    SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    disable_dispatch_service()

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        clear_local_area_of_cops()
        never_wanted()
        remove_vehicles_from_areas()
    end

end)
