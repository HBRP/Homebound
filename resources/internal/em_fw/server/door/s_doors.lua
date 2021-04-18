
local known_doors = {}

local function set_door_lock_states(doors)

    if doors == nil then
        return
    end

    for i = 1, #doors do

        local found_door = false
        for j = 1, #known_doors do

            if doors[i].door_location_id == known_doors[j].door_location_id then
                doors[i].locked = known_doors[j].locked
                found_door = true
                break
            end

        end
        if not found_door then
            table.insert(known_doors, {door_location_id = doors[i].door_location_id, locked = doors[i].locked_by_default})
            doors[i].locked = doors[i].locked_by_default
        end

    end

end

local function toggle_door_lock(door_location_id)

    for i = 1, #known_doors do

        if known_doors[i].door_location_id == door_location_id then

            known_doors[i].locked = not known_doors[i].locked
            break

        end

    end

end

register_server_callback("em_fw:get_nearby_doors", function(source, callback, character_id, x, y, z)

    local endpoint = string.format("/Doors/Nearby/%d/%.4f/%.4f/%.4f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        set_door_lock_states(temp)
        callback(temp)

    end)

end)

register_server_callback("em_fw:toggle_door", function(source, callback, door_location_id)

    toggle_door_lock(door_location_id)

end)