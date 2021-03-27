local shopZone = nil

RegisterNetEvent("esx_inventoryhud:openShop")
AddEventHandler(
    "esx_inventoryhud:openShop",
    function(zone, items)
        setShopData(zone, items)
        openShop()
    end
)

function setShopData(zone, items)
    shopZone = zone

    SendNUIMessage(
        {
            action = "setType",
            type = "shop"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = _U("store")
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openShop()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "shop"
        }
    )

    SetNuiFocus(true, true)
end

local function begin_transaction(data)

    local cash_on_hand = exports["em_transactions"]:get_cash_on_hand()
    if cash_on_hand >= data.number * data.item.price then
        local response = exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), data.item.item_id, data.number, -1, -1)
        if response.response.success then
            exports["em_transactions"]:remove_cash(data.number * data.item.price)
        else
            exports['swt_notifications']:Negative("Shop", "Cannot buy that many items", "top", 2000, true)
        end
    else
        exports['swt_notifications']:Negative("Shop", "Not enough cash on hand.", "top", 2000, true)
    end

end

RegisterNUICallback(
    "BuyItem",
    function(data, cb)

        if data.number > 0 then
            begin_transaction(data)
        else
            exports['swt_notifications']:Negative("Shop", "Must specify a number greater than 0 to purchase an item", "top", 2000, true)
        end
        loadPlayerInventory()
        cb("ok")
    end
)
