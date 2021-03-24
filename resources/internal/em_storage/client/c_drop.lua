


local nearby_drops = {}
local bags = {}

local function nearby_drop_loop()

    local nearby_a_drop   = false
    local text_id = 0
    while true do

        Citizen.Wait(5)
        nearby_a_drop   = false
        local ped_coords = GetEntityCoords(PlayerPedId())
        for i = 1, #nearby_drops do
            if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_drops[i].x, nearby_drops[i].y, nearby_drops[i].z, true) < 2 then
                if not exports["cd_drawtextui"]:is_in_queue(text_id) then
                    text_id = exports["cd_drawtextui"]:show_text("Press [E] to open bag")
                end
                nearby_a_drop = true
                if IsControlJustReleased(0, 38) then
                    TriggerEvent("esx_inventoryhud:open_secondary_inventory", nearby_drops[i].storage_id, "Drop")
                end
            end
        end
        if not nearby_a_drop then
            if exports["cd_drawtextui"]:is_in_queue(text_id) then
                exports["cd_drawtextui"]:hide_text(text_id)
            end
            Citizen.Wait(1000)
        end
    end

end

function get_nearby_drop_storage_id()

    local ped_coords = GetEntityCoords(PlayerPedId())
    for i = 1, #nearby_drops do
        if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_drops[i].x, nearby_drops[i].y, nearby_drops[i].z, true) < 5 then
            return nearby_drops[i].storage_id
        end
    end

    local new_drop = exports["em_fw"]:get_free_drop_zone()
    return new_drop.storage_id

end

local function delete_bag(bag)

    SetEntityAsMissionEntity(bag, true, true)
    DeleteObject(bag)

end

local function set_bag_on_ground(x, y, z)

    local bag = GetHashKey("prop_paper_bag_small")
    RequestModel(bag)
    while not HasModelLoaded(bag) do
        Citizen.Wait(1)
    end
    local object = CreateObject(bag, x, y, z, true, true, true)
    PlaceObjectOnGroundProperly(object)
    table.insert(bags, object)

end

local function remove_existing_bags()

    for i = 1, #bags do
        delete_bag(bags[i])
    end
    bags = {}

end

local function add_new_bags()

    for i = 1, #nearby_drops do
        set_bag_on_ground(nearby_drops[i].x, nearby_drops[i].y, nearby_drops[i].z)
    end

end

local function refresh()

    nearby_drops = exports["em_fw"]:get_nearby_drops()
    if nearby_drops == nil then
        nearby_drops = {}
    end

    remove_existing_bags()
    add_new_bags()

end

local function nearby_drop_refresh_loop()

    Citizen.Wait(0)
    while true do

        refresh()
        Citizen.Wait(5000)

    end

end

AddEventHandler("em_storage:manual_drop_refresh", refresh)

Citizen.CreateThread(nearby_drop_refresh_loop)
Citizen.CreateThread(nearby_drop_loop)