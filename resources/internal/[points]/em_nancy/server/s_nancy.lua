

local used_beds = {}

exports["em_dal"]:register_server_callback("em_nancy:get_empty_bed", function(source, callback)

    for i = 1, #used_beds do
        if not used_beds[i] then
            used_beds[i] = true
            callback(i)
            return
        end
    end
    callback(0)

end)

exports["em_dal"]:register_server_callback("em_nancy:is_bed_empty", function(source, callback, idx)

    callback(used_beds[idx])

end)

exports["em_dal"]:register_server_callback("em_nancy:free_bed", function(source, callback, idx)

    used_beds[idx] = false
    callback()

end)

exports["em_dal"]:register_server_callback("em_nancy:take_bed", function(source, callback, idx)

    used_beds[idx] = true
    callback()

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    for i = 1, #beds do
        used_beds[i] = false
    end

end)