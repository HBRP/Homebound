
local function begin_transaction(data)

    local cash_on_hand = exports["em_transactions"]:get_cash_on_hand()
    if cash_on_hand >= data.number * data.item.price then
        local response = exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), data.item.item_id, data.number, -1, -1)
        if response.response.success then
            exports["em_transactions"]:remove_cash(data.number * data.item.price)
        else
            exports['t-notify']:Alert({style = 'error', message = "Cannot buy that many items"})
        end
    else
        exports['t-notify']:Alert({style = 'error', message = "Not enough cash on hand"})
    end

end

RegisterNUICallback(
    "BuyItem",
    function(data, cb)

        if data.number > 0 then
            begin_transaction(data)
        else
            exports['t-notify']:Alert({style = 'error', message = "Must specify a number greater than 0 to purchase an item"})
        end
        loadPlayerInventory()
        cb("ok")
    end
)
