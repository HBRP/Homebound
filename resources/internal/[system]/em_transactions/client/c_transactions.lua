
function get_cash_on_hand(character_storage_items)

    local storage_items = character_storage_items or exports["em_dal"]:get_character_storage()["storage_items"]
    local cash_on_hand  = 0
    local cash_item_id = exports["em_items"]:get_item_id_from_name("cash")
    for i = 1, #storage_items do

        if storage_items[i].item_id == cash_item_id then
            cash_on_hand = cash_on_hand + storage_items[i].amount
        end

    end
    return cash_on_hand

end

function remove_cash(amount)

    local amount_left_to_remove = math.ceil(amount)
    local cash_item_id  = exports["em_items"]:get_item_id_from_name("cash")
    local storage_items = exports["em_dal"]:get_character_storage()["storage_items"]

    if get_cash_on_hand(storage_items) < amount then
        exports['t-notify']:Alert({style = 'error', message = "You do not have enough cash on hand"})
        return false
    end

    for i = 1, #storage_items do
        if storage_items[i].item_id == cash_item_id then
            if storage_items[i].amount >= amount_left_to_remove then
                exports["em_dal"]:remove_item(storage_items[i].storage_item_id, amount_left_to_remove)
                amount_left_to_remove = 0
            else
                exports["em_dal"]:remove_item(storage_items[i].storage_item_id, storage_items[i].amount)
                amount_left_to_remove = amount_left_to_remove - storage_items[i].amount
            end
        end
    end
    exports['t-notify']:Alert({style = 'success', message = string.format("Spent $%d", math.ceil(amount))})

    return true

end