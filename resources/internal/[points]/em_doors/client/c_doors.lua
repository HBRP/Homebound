
local local_doors = {}
local last_coords = vector3(0.0, 0.0, 0.0)
local next_refresh_time = 0

local function interact_with_door(door)

    exports["em_fw"]:toggle_door(door.door_location_id)

    door.locked = not door.locked
    exports["em_fw"]:trigger_proximity_event("em_doors:proximity_change", 100.0, door)
    PlaySound(-1, "Take_Picture", "MUGSHOT_CHARACTER_CREATION_SOUNDS", 0, 0, 1)
    Citizen.Wait(500)
    exports["cd_drawtextui"]:clear_queue()

end

local function set_prop_hashes(doors)

    for i = 1, #doors do
        for j = 1, #doors[i].doors do
            if doors[i].doors[j].prop_hash == nil then
                doors[i].doors[j].prop_hash = GetHashKey(doors[i].doors[j].model_name)
            end
        end
    end

end

local function freeze_doors(doors)

    for i = 1, #doors do 

        local prop_doors = doors[i].doors
        for j = 1, #prop_doors do

            local object = GetClosestObjectOfType(vector3(table.unpack(prop_doors[j].coords)), 1.0, prop_doors[j].prop_hash, false, false, false)
            if doors[i].locked then
                if math.abs(prop_doors[j].heading - GetEntityHeading(object)) >= 0.2 then
                    SetEntityHeading(object, prop_doors[j].heading)
                end
            end
            FreezeEntityPosition(object, doors[i].locked)

        end

    end

end

local function refresh_loop(refresh_func)

    local current_coords = GetEntityCoords(PlayerPedId())
    if #(current_coords - last_coords) > 25.0 or GetGameTimer() > next_refresh_time then

        exports["em_fw"]:get_nearby_doors_async(function(doors)

            doors = doors or {}
            set_prop_hashes(doors)
            freeze_doors(doors)

            local_doors = doors
            refresh_func(doors)

        end)
        last_coords = current_coords
        next_refresh_time = GetGameTimer() + 10000

    else

        set_prop_hashes(local_doors)
        freeze_doors(local_doors)
        refresh_func(local_doors)

    end

end

local function text(door)

    local locked_text = "unlock"
    if not door.locked then
        locked_text = "lock"
    end
    return string.format("[E] to %s %s", locked_text, door.door_location_text)

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_door_points(refresh_loop, text, interact_with_door, 250)
    
end)


RegisterNetEvent("em_doors:proximity_change")
AddEventHandler("em_doors:proximity_change", function(door)

    for i = 1, #local_doors do
        if local_doors[i].door_location_id == door.door_location_id then
            local_doors[i] = door
        end
    end

end)