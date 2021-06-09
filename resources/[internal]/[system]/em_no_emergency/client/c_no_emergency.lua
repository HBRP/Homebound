

local function clear_local_area_of_cops()

    local coords = GetEntityCoords(PlayerPedId())
    ClearAreaOfCops(coords.x, coords.y, coords.z , 500.0)

end

local function disable_dispatch_service()

    for i = 0, 15 do                                                        
        EnableDispatchService(i, false) 
    end

end

local function disable_scenarios()

    local scenarios = {
      --'WORLD_VEHICLE_ATTRACTOR',
      'WORLD_VEHICLE_AMBULANCE',
      --'WORLD_VEHICLE_BICYCLE_BMX',
      --'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
      --'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
      --'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
      --'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
      --'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
      --'WORLD_VEHICLE_BICYCLE_ROAD',
      --'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
      --'WORLD_VEHICLE_BIKER',
      --'WORLD_VEHICLE_BOAT_IDLE',
      --'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
      --'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
      --'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
      --'WORLD_VEHICLE_BROKEN_DOWN',
      --'WORLD_VEHICLE_BUSINESSMEN',
      'WORLD_VEHICLE_HELI_LIFEGUARD',
      --'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
      --'WORLD_VEHICLE_CONSTRUCTION_SOLO',
      --'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
      --'WORLD_VEHICLE_DRIVE_PASSENGERS',
      --'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
      --'WORLD_VEHICLE_DRIVE_SOLO',
      --'WORLD_VEHICLE_FARM_WORKER',
      'WORLD_VEHICLE_FIRE_TRUCK',
      --'WORLD_VEHICLE_EMPTY',
      --'WORLD_VEHICLE_MARIACHI',
      --'WORLD_VEHICLE_MECHANIC',
      'WORLD_VEHICLE_MILITARY_PLANES_BIG',
      'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
      --'WORLD_VEHICLE_PARK_PARALLEL',
      --'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
      --'WORLD_VEHICLE_PASSENGER_EXIT',
      'WORLD_VEHICLE_POLICE_BIKE',
      'WORLD_VEHICLE_POLICE_CAR',
      'WORLD_VEHICLE_POLICE',
      'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
      --'WORLD_VEHICLE_QUARRY',
      --'WORLD_VEHICLE_SALTON',
      --'WORLD_VEHICLE_SALTON_DIRT_BIKE',
      --'WORLD_VEHICLE_SECURITY_CAR',
      --'WORLD_VEHICLE_STREETRACE',
      --'WORLD_VEHICLE_TOURBUS',
      --'WORLD_VEHICLE_TOURIST',
      --'WORLD_VEHICLE_TANDL',
      --'WORLD_VEHICLE_TRACTOR',
      --'WORLD_VEHICLE_TRACTOR_BEACH',
      --'WORLD_VEHICLE_TRUCK_LOGS',
      --'WORLD_VEHICLE_TRUCKS_TRAILERS',
      --'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
    }

    for i, v in ipairs(scenarios) do
      SetScenarioTypeEnabled(v, false)
    end

end


local function remove_vehicles_from_areas()

    RemoveVehiclesFromGeneratorsInArea(-448.381, -328.73, 34.50, -499.502, -346.43, 34.50) -- Mount Zonah
    RemoveVehiclesFromGeneratorsInArea(291.604, -566.823, 43.2608, 288.7409, -614.184, 43.422) -- Pillbox Medical
    RemoveVehiclesFromGeneratorsInArea(378.5925, -575.367, 28.839, 354.327, -600.7609, 28.77) -- Pillbox Medical Lower
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
    disable_scenarios()
    while true do
        Citizen.Wait(50)
        remove_vehicles_from_areas()
        clear_local_area_of_cops()
    end

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(5)
        never_wanted()
    end

end)
