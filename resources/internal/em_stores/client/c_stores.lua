
local nearby_stores = {}

local store_type_ids = {

    CONVENIENCE  = 1,
    BLACK_MARKET = 2,
    PAWN_SHOP    = 3

}

local function open_selected_store(store)

    Citizen.Trace(json.encode(store) .. "\n")
    exports["em_fw"]:get_store_items_async(function(store_items)

        Citizen.Trace(json.encode(store_items) .. "\n")
        TriggerEvent("esx_inventoryhud:open_store", store_items)

    end, store.store_type_id)

end

local function store_loop()

    local nearby_point = false
    local draw_text_id = -1
    while true do

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
            Citizen.Wait(100)
        end
        nearby_point = false

    end

end

local function refresh_nearby_stores(result)

    nearby_stores = result
    if nearby_stores == nil then
        nearby_stores = {}
    end

end

local function refresh_nearby_stores_loop()

    while true do

        Citizen.Wait(5000)
        exports["em_fw"]:get_nearby_stores_async(refresh_nearby_stores)

    end

end

Citizen.CreateThread(refresh_nearby_stores_loop)
Citizen.CreateThread(store_loop)