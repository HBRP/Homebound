
local is_there_nearby_stores = false
local nearby_stores = {}

local store_type_ids = {

    CONVENIENCE  = 1,
    BLACK_MARKET = 2,
    PAWN_SHOP    = 3

}

local function open_selected_store(store)

    exports["em_fw"]:get_store_items_async(function(store_items)

        TriggerEvent("esx_inventoryhud:open_store", store, store_items)

    end, store.store_type_id)

end

local function refresh_loop(refresh_func)

    exports["em_fw"]:get_nearby_stores_async(refresh_func)

end

local function text(nearby_store)

    return string.format("Press [E] to open %s", nearby_store.store_name)

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_points(refresh_loop, text, open_selected_store)
    
end)

