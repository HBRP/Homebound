
local nearby_drops = {}
local bags = {}
local player_coords = nil
local force_refresh = false

function get_nearby_drop_storage_id()

    local ped_coords = GetEntityCoords(PlayerPedId())
    for i = 1, #nearby_drops do
        if GetDistanceBetweenCoords(ped_coords.x, ped_coords.y, ped_coords.z, nearby_drops[i].x, nearby_drops[i].y, nearby_drops[i].z, true) < 5 then
            return nearby_drops[i].storage_id
        end
    end

    local new_drop = exports["em_dal"]:get_free_drop_zone()
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


local function open_drop(drop)
    TriggerEvent("esx_inventoryhud:open_secondary_inventory", drop.storage_id, "Drop")
end

local function refresh_loop(refresh_check)
    
    local temp_coords = GetEntityCoords(PlayerPedId())

    if #(temp_coords - player_coords) < 50.0 and not force_refresh then
        return
    end

    player_coords = temp_coords
    force_refresh = false

    exports["em_dal"]:get_nearby_drops_async(function(result)

        nearby_drops = result
        if nearby_drops == nil then
            nearby_drops = {}
        end
        remove_existing_bags()
        add_new_bags()
        refresh_check(nearby_drops)
        
    end)

end

local function text(stash)
    return "Press [E] to open bag"
end

AddEventHandler("em_dal:character_loaded", function()

    player_coords = GetEntityCoords(PlayerPedId())
    exports["em_points"]:register_points(refresh_loop, text, open_drop, 1000)
    
end)


AddEventHandler("em_storage:manual_drop_refresh", function()

    exports["em_dal"]:trigger_proximity_event("em_storage:proximity_drop", 75.0)

end)

RegisterNetEvent("em_storage:proximity_drop")
AddEventHandler("em_storage:proximity_drop", function()

    force_refresh = true

end)