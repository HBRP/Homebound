
local store_type_ids = {

    CONVENIENCE  = 1,
    BLACK_MARKET = 2,
    PAWN_SHOP    = 3,
    AMMUNATION   = 4,
    TATTOO_SHOP  = 5

}

local function rob_npc_dialog(ped)

    return {
        
    }

end

local function shop_dialog()

    return {
        dialog = "I'd like to buy items",
        response = "Sure thing.",
        callback = function()

            exports["em_fw"]:get_store_items_async(function(store_items)
                TriggerEvent("esx_inventoryhud:open_store", {store_name = "Convenience Store"}, store_items)
            end, store_type_ids.CONVENIENCE)

        end
    }

end

AddEventHandler("convenience_clerk", function(ped, entity)

    local clerk_dialog = {}
    table.insert(clerk_dialog, shop_dialog)


end)