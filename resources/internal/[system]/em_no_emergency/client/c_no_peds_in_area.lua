
local area_locations = {
    {x = 448.445, y = -994.68, z = 29.38, radius = 30.0}, -- mission row
    {x = -1190.178, y = -888.69, z = 13.9953, radius = 10.0} -- burgershot
}

local function clear_area_of_peds()

    local coords = GetEntityCoords(PlayerPedId())
    for i = 1, #area_locations do
        ClearAreaOfPeds(area_locations[i].x, area_locations[i].y, area_locations[i].z, area_locations[i].radius, 1)
    end

end



Citizen.CreateThread(function()

    while true do
        Citizen.Wait(100)
        clear_area_of_peds()
    end

end)