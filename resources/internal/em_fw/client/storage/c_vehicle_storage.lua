
function get_vehicle_storage(plate, location)

    local storage = nil

    trigger_server_callback("em_fw:get_vehicle_storage", function(result)

        storage = result

    end, plate, location)

    return storage

end

function get_vehicle_storage_id(plate, location)

    local temp = nil

    trigger_server_callback("em_fw:get_vehicle_storage_id", function(result)

        temp = result

    end, plate, location)

    return temp["storage_id"]

end