
local motel_allotment = {}
local housing_ids_cache = {}

local function set_allotment()

    for i = 1, #housing_ids_cache do

        table.insert(motel_allotment, {
            house_id = housing_ids_cache[i],
            player_id = nil
        })

    end

end

local function set_player_motel_allotment(player_id)

    for i = 1, #motel_allotment do

        if motel_allotment[i].player_id == nil then
            motel_allotment[i].player_id = player_id
            return
        end

    end

end

local function remove_player_motel_allotment(player_id)

    for i = 1, #motel_allotment do

        if motel_allotment[i].player_id == player_id then
            table.remove(motel_allotment, i)
            return

        end

    end

end

exports["em_fw"]:register_server_callback("em_housing:set_player_motel_allotment", function(source, callback, player_id)

    set_player_motel_allotment(player_id)

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_fw"]:get_all_house_ids_of_type_async(function(housing_ids)

        housing_ids_cache = housing_ids
        set_allotment()

    end, housing_type_ids.motels)

end)