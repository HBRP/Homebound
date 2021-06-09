
local registered_vehicles = {}
local vehicle_keys = {}

local function has_plate_been_registered(plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then
            return true
        end

    end
    return false

end

local function is_registered_to_character(character_id, plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then
            return registered_vehicles[i].character_id == character_id and registered_vehicles[i].group_id == nil
        end

    end
    return false

end

local function is_registered_to_group_id(group_id, plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then
            return registered_vehicles[i].group_id == group_id
        end

    end
    return false

end

local function is_registered_to_group(plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then
            return registered_vehicles[i].group_id ~= nil
        end

    end
    return false

end

local function has_keys(character_id, plate)

    for i = 1, #vehicle_keys do
        if vehicle_keys[i].plate == plate then
            return vehicle_keys[i].character_id == character_id
        end
    end
    return false

end

exports["em_dal"]:register_server_callback("em_vehicles:register_plate_as_player_owned", function(source, callback, character_id, plate)

    if has_plate_been_registered(plate) then
        print(string.format("Plate %s has already been registered", plate))
        return
    end

    table.insert(registered_vehicles, {plate = plate, character_id = character_id, group_id = 0})
    table.insert(vehicle_keys, {plate = plate, character_id = character_id})

end)

exports["em_dal"]:register_server_callback("em_vehicles:register_plate_as_group_owned", function(source, callback, character_id, group_id, plate)

    if has_plate_been_registered(plate) then
        print(string.format("Plate %s has already been registered", plate))
        return
    end

    table.insert(registered_vehicles, {plate = plate, group_id = group_id, character_id = 0})
    table.insert(vehicle_keys, {plate = plate, character_id = character_id})

end)

exports["em_dal"]:register_server_callback("em_vehicles:is_vehicle_owned_by_group_id", function(source, callback, group_id, plate)

    callback(is_registered_to_group_id(group_id, plate))

end)

exports["em_dal"]:register_server_callback("em_vehicles:is_vehicle_owned_by_group", function(source, callback, plate)

    callback(is_registered_to_group(group_id, plate))

end)

exports["em_dal"]:register_server_callback("em_vehicles:is_vehicle_player_owned", function(source, callback, plate)

    callback(has_plate_been_registered(plate))

end)

exports["em_dal"]:register_server_callback("em_vehicles:is_vehicle_owned_by_character", function(source, callback, character_id, plate)

    callback(is_registered_to_character(character_id, plate))

end)

exports["em_dal"]:register_server_callback("em_vehicles:has_keys", function(source, callback, character_id, plate)

    callback(has_keys(character_id, plate))

end)

exports["em_dal"]:register_server_callback("em_vehicles:transfer_keys", function(source, callback, character_id, to_character_id, plate)

    for i = 1, #vehicle_keys do

        if vehicle_keys[i].plate == plate then

            if vehicle_keys[i].character_id == character_id then
                vehicle_keys[i].character_id = to_character_id
                callback(true)
                return
            end

        end

    end
    
    callback(false)

end)