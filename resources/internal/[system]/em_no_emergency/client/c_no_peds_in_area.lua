
local area_locations = {
    {x = 448.445, y = -994.68, z = 29.38, radius = 30.0}, -- mission row
    {x = -1190.178, y = -888.69, z = 13.9953, radius = 10.0}, -- burgershot
    {x = 1702.607, y = 2605.90, z = 45.56, radius = 200.0},
    {x = -569.338, y = 235.288, z = 74.89, radius = 20.0} -- hackerspace
}

local vehicle_locations = {
    {x = 1639.77, y = 2599.09, z = 45.56, radius = 10.0} -- Boilingbroke buses
}

local function clear_area_of_peds()

    for i = 1, #area_locations do
        ClearAreaOfPeds(area_locations[i].x, area_locations[i].y, area_locations[i].z, area_locations[i].radius, 1)
    end

end

local function clear_area_of_cards()

    for i = 1, #vehicle_locations do
        ClearAreaOfVehicles(vehicle_locations[i].x, vehicle_locations[i].y, vehicle_locations[i].z, vehicle_locations[i].radius, false, false, false, false, false)
    end

end



Citizen.CreateThread(function()

    while true do
        Citizen.Wait(100)
        clear_area_of_peds()
        clear_area_of_cards()
    end

end)