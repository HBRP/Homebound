
local motel_house_id = 0

local function get_door_lock_interaction(house)

    local dialog = nil
    local callback = function() 

        exports["em_dialog"]:hide_dialog()
        exports["em_fw"]:toggle_housing_door_lock_async(function(locked)

            house.locked = locked
            exports["em_fw"]:trigger_proximity_event("em_housing:toogle_motel_lock", 100.0, house)
            Citizen.Wait(200)
            interact_motel(house)

        end, house.housing_door_id)

    end

    if house.locked and (house.can_unlock or not house.entrance or motel_house_id == house.house_id) then
        dialog = "[Unlock door]"
    end

    if not house.locked and (house.can_unlock or motel_house_id == house.house_id) then
        dialog = "[Lock door]"
    end

    if dialog == nil then
        return nil
    end

    return {
        dialog = dialog,
        callback = callback
    }

end

local function get_walk_through_interaction(house)

    local dialog = nil
    local callback = function() 
        exports["em_dialog"]:hide_dialog()
    end

    if not house.locked then
        dialog = "[Walk through door]"
    end

    if house.locked then
        return nil
    end

    return {
        dialog = dialog,
        callback = callback
    }

end

function interact_motel(house)

    local dialog = {
        {
            dialog = "Knock",
            callback = function()
                exports["em_dialog"]:hide_dialog()
            end
        }
    }

    local lock_dialog = get_door_lock_interaction(house)
    local walk_dialog = get_walk_through_interaction(house)

    if lock_dialog ~= nil then
        table.insert(dialog, lock_dialog)
    end

    if walk_dialog ~= nil then
        table.insert(dialog, walk_dialog)
    end

    local house_name = nil
    if house.locked then
        house_name = string.format("%s (locked)", house.house_name)
    else
        house_name = string.format("%s (unlocked)", house.house_name)
    end

    exports["em_dialog"]:show_dialog(house_name, dialog)

end

local function get_split_by_doors(houses)

    local housing_doors = {}
    for i = 1, #houses do

        table.insert(housing_doors, {
            entrance = true,
            housing_door_id = houses[i].housing_door_id,
            house_id = houses[i].house_id,
            house_name = houses[i].house_name,
            x = houses[i].enter_x,
            y = houses[i].enter_y,
            z = houses[i].enter_z,
            t_x = houses[i].exit_x,
            t_y = houses[i].exit_y,
            t_z = houses[i].exit_z,
            can_unlock = houses[i].can_unlock,
            locked = houses[i].locked
        })
        table.insert(housing_doors, {
            entrance = false,
            housing_door_id = houses[i].housing_door_id,
            house_id = houses[i].house_id,
            house_name = houses[i].house_name,
            x = houses[i].exit_x,
            y = houses[i].exit_y,
            z = houses[i].exit_z,
            t_x = houses[i].enter_x,
            t_y = houses[i].enter_y,
            t_z = houses[i].enter_z,
            can_unlock = houses[i].can_unlock,
            locked = houses[i].locked
        })

    end
    return housing_doors

end

local function refresh_loop(refresh_func)

    exports["em_fw"]:get_nearby_houses_async(function(houses)

        local housing_doors = get_split_by_doors(houses)
        refresh_func(housing_doors)

    end, housing_type_ids.motels)

end

local function text(nearby_house)

    return "Press [E] to use door."

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_fw"]:trigger_server_callback_async("em_housing:get_player_motel_allotment", function(house_id) 

        motel_house_id = house_id

    end, exports["em_fw"]:get_player_id())

    exports["em_points"]:register_points(refresh_loop, text, interact_motel)
    
end)

RegisterNetEvent("em_housing:toogle_motel_lock")
AddEventHandler("em_housing:toogle_motel_lock", function(house)

    for i = 1, #housing_doors do

        if housing_doors[i].housing_door_id == house.housing_door_id then
            housing_doors[i].locked = house.locked
            break
        end

    end

end)
