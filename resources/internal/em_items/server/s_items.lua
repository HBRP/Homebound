
local items_cache = {}

function get_item_id_from_name(item_name)

    for i = 1, #items_cache do
        if items_cache[i].item_name == item_name then
            return items_cache[i].item_id
        end
    end
    return 0

end

function get_item_name_from_item_id(item_id)

    for i = 1, #items_cache do
        if items_cache[i].item_id == item_id then
            return items_cache[i].item_name
        end
    end
    return 0

end

exports["em_fw"]:register_server_callback("em_items:get_items", function(source, callback)

    callback(items_cache)

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_fw"]:get_items(function(result) items_cache = result or {} end)

end)