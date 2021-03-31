
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

local function store_loop()

    local nearby_point = false
    local draw_text_id = -1
    while is_there_nearby_stores do

        Citizen.Wait(5)
        ped_coords = GetEntityCoords(PlayerPedId())

        for i = 1, #nearby_stores do

            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_stores[i].x, nearby_stores[i].y, nearby_stores[i].z, true) < 2 then

                nearby_point = true
                if not exports["cd_drawtextui"]:is_in_queue(draw_text_id) then
                    draw_text_id = exports["cd_drawtextui"]:show_text(string.format("Press [E] to open %s", nearby_stores[i].store_name))
                end
                if IsControlJustReleased(0, 38) then
                    open_selected_store(nearby_stores[i])
                end

            end

        end
        if not nearby_point then
            exports["cd_drawtextui"]:hide_text(draw_text_id)
            Citizen.Wait(500)
        end
        nearby_point = false

    end

end

local function refresh_nearby_stores(result)

    nearby_stores = result or {}
    if not is_there_nearby_stores and #nearby_stores > 0 then
        Citizen.CreateThread(store_loop)
    end
    is_there_nearby_stores = #nearby_stores > 0

end

local function refresh_nearby_stores_loop()

    while true do

        Citizen.Wait(5000)
        exports["em_fw"]:get_nearby_stores_async(refresh_nearby_stores)

    end

end

AddEventHandler("em_fw:character_loaded", function()

    Citizen.CreateThread(refresh_nearby_stores_loop)
    
end)

