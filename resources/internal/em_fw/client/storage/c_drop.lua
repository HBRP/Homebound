

function get_nearby_drops()

    local coords = GetEntityCoords(PlayerPedId())

    local nearby_drops = nil
    trigger_server_callback("em_fw:get_nearby_drops", function(result)

        nearby_drops = result

    end, coords.x, coords.y, coords.z)
    return nearby_drops

end

function get_nearby_drops_async(callback)

    local coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_drops", callback, coords.x, coords.y, coords.z)

end

function get_free_drop_zone()

    local coords = GetEntityCoords(PlayerPedId())
    local drop_zone = nil
    trigger_server_callback("em_fw:get_free_drop_zone", function(result)

        drop_zone = result

    end, coords.x, coords.y, coords.z)

    return drop_zone

end

function set_drop_zone_inactive(storage_id)

    local drop_zone = nil
    trigger_server_callback("em_fw:set_drop_zone_inactive", function(result)

        drop_zone = result

    end, storage_id)

    return drop_zone

end