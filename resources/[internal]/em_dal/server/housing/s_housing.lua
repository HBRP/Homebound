
local housing_doors = {}

local function set_locks(nearby_houses)

    for i = 1, #nearby_houses do

        local found_door = false
        for j = 1, #housing_doors do

            if housing_doors[j].housing_door_id == nearby_houses[i].housing_door_id then

                nearby_houses[i].locked = housing_doors[j].locked
                found_door = true
                break

            end

        end

        if not found_door then

            table.insert(housing_doors, {house_id = nearby_houses[i].house_id, housing_door_id = nearby_houses[i].housing_door_id, locked = true})
            nearby_houses[i].locked = true

        end

    end

end

function lock_doors_for_house_id(house_id)

    for i = 1, #housing_doors do

        if housing_doors[i].house_id == house_id then

            housing_doors[i].locked = true

        end

    end

end

function get_all_house_ids_of_type_async(callback, housing_type_id)

    Citizen.CreateThread(function()
        local endpoint = string.format("/Housing/House/All/%d", housing_type_id)
        HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

            local temp = json.decode(result_data) or {}
            callback(temp)

        end)
    end)

end

function get_housing_storage_async(callback, character_id, house_id)

    local endpoint = string.format("/Housing/Storage/Points/%d/%d", character_id, house_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data) or {}
        callback(temp)

    end)

end

register_server_callback("em_dal:get_nearby_houses", function(source, callback, housing_type_id, character_id, x, y, z)

    local endpoint = string.format("/Housing/House/Nearby/%d/%d/%.2f/%.2f/%.2f", housing_type_id, character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data) or {}
        set_locks(temp)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_house", function(source, callback, house_id)

    local endpoint = string.format("/Housing/House/%d", house_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:toggle_housing_door_lock", function(source, callback, housing_door_id)

    for i = 1, #housing_doors do

        if housing_doors[i].housing_door_id == housing_door_id then

            housing_doors[i].locked = not housing_doors[i].locked
            callback(housing_doors[i].locked)
            break

        end

    end

end)