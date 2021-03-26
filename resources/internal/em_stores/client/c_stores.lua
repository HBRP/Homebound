
local nearby_stores = {}


local refresh_nearby_stores(result)

    nearby_stores = result

end

local refresh_nearby_stores_loop()

    while true do

        Citizen.Wait(5000)
        exports["em_fw"]:get_nearby_stores(refresh_nearby_stores)

    end

end

Citizen.CreateThread(refresh_nearby_stores_loop)