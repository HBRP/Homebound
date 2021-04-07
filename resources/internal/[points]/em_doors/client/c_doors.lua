
local function interact_with_door(door)

    exports["em_fw"]:toggle_door(door.door_location_id)

    local notify_message = string.format("%s door unlocked", door.door_location_text)
    if not door.locked then
        notify_message = string.format("%s door locked", door.door_location_text)
    end

    Citizen.Wait(500)
    exports["t-notify"]:Alert({style = "info", message = notify_message})
    exports["cd_drawtextui"]:clear_queue()

end

local function set_prop_hashes(doors)

    for i = 1, #doors do
        for j = 1, #doors[i].doors do
            doors[i].doors[j].prop_hash = GetHashKey(doors[i].doors[j].model_name)
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

    exports["em_fw"]:get_nearby_doors_async(function(doors)

        set_prop_hashes(doors)
        freeze_doors(doors)
        refresh_func(doors)

    end)

end

local function text(door)

    local locked_text = "open"
    if not door.locked then
        locked_text = "lock"
    end
    return string.format("Press [E] to %s %s", locked_text, door.door_location_text)

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_raycast_door(refresh_loop, text, interact_with_door, 500)
    
end)
