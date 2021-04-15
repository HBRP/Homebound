
local registered_vehicles = {}

local function has_plate_been_registered(plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then
            return true
        end

    end
    return false

end

local function is_registered_to_player(character_id, plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then
            return registered_vehicles[i].character_id == character_id
        end

    end
    return false

end

exports["em_fw"]:register_server_callback("em_vehicles:register_plate_as_player_owned", function(source, callback, character_id, plate)

    if has_plate_been_registered(plate) then
        print(string.format("Plate %s has already been registered", plate))
        return
    end

    table.insert(registered_vehicles, {plate = plate, character_id = character_id})

end)

exports["em_fw"]:register_server_callback("em_vehicles:is_vehicle_player_owned", function(source, callback, plate)

    callback(has_plate_been_registered(plate))

end)

exports["em_fw"]:register_server_callback("em_vehicles:has_keys", function(source, callback, character_id, plate)

    callback(is_registered_to_player(character_id, plate))

end)

exports["em_fw"]:register_server_callback("em_vehicles:transfer_keys", function(source, callback, character_id, to_character_id, plate)

    for i = 1, #registered_vehicles do

        if registered_vehicles[i].plate == plate then

            if registered_vehicles[i].character_id == character_id then
                registered_vehicles[i].character_id = to_character_id
                callback(true)
                return
            end

        end

    end
    
    callback(false)

end)