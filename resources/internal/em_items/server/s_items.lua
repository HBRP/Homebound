
local items_cache = {}

function get_item_id_from_name(item_name)

    for i = 1, #items_cache do
        if items_cache[i].item_name == item_name then
            return items_cache[i].item_id
        end
    end

    assert(1 ~= 0, string.format("Item by name %s does not exist", item_name))

    return 0

end

function get_item_name_from_item_id(item_id)

    for i = 1, #items_cache do
        if items_cache[i].item_id == item_id then
            return items_cache[i].item_name
        end
    end

    assert(1 ~= 0, string.format("Item by id %d does not exist", item_id))

    return 0

end

function give_item_by_name(source, item_name, amount)

    local character = exports["em_dal"]:get_character_from_source(source)
    local item_id   = get_item_id_from_name(item_name)

    exports["em_dal"]:give_item(source, function() end, character.character_id, character.storage_id, item_id, amount, -1, -1)

end

function remove_item_by_name(source, item_name, amount)

    local item_id = get_item_id_from_name(item_name)
    local storage_items = get_storage_items(source)

    local amount_left = amount
    for i = 1, #storage_items do

        if amount_left == 0 then
            return
        end

        if storage_items[i].item_id == item_id then

            if storage_items[i].amount - amount_left >= 0 then
                exports["em_dal"]:remove_item(source, function() end, storage_items[i].storage_item_id, amount_left)
                amount_left = 0
            else
                exports["em_dal"]:remove_item(source, function() end, storage_items[i].storage_item_id, storage_items[i].amount)
                amount_left = amount_left - storage_items[i].amount
            end

        end

    end

end

function get_storage_items(source)

    local character = exports["em_dal"]:get_character_from_source(source)
    local storage_items = nil

    exports["em_dal"]:get_storage(source, function(storage) 

        storage_items = storage["storage_items"]

    end, character.storage_id)

    while storage_items == nil do
        Citizen.Wait(100)
    end

    return storage_items

end

function get_item_amount_by_name(source, item_name)

    local item_id = get_item_id_from_name(item_name)
    local storage_items = get_storage_items(source)
    local amount = 0

    for i = 1, #storage_items do

        if storage_items[i].item_id == item_id then
            amount = amount + storage_items[i].amount
        end

    end

    return amount

end

exports["em_dal"]:register_server_callback("em_items:get_items", function(source, callback)

    callback(items_cache)

end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_dal"]:get_items(function(result) items_cache = result or {} end)

end)