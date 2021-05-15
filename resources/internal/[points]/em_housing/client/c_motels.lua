
local motel_house_id = 0
local housing_doors_cache = {}

local function get_door_lock_interaction(house)

    local dialog = nil
    local callback = function() 

        exports["em_dialog"]:hide_dialog()
        exports["em_dal"]:toggle_housing_door_lock_async(function(locked)

            house.locked = locked
            exports["em_dal"]:trigger_proximity_event("em_housing:toogle_motel_lock", 100.0, house)
            TriggerEvent("PlaySoundForEveryoneInVicinity", "sounds/Doors/door_unlock.mp3")
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

local function prepare_house(house)

    if house.entrance then

        TriggerEvent("PlaySoundForEveryoneInVicinity", "sounds/Doors/door_open.mp3")
        spawn_house(function()

            SetEntityCoords(PlayerPedId(), house.t_x, house.t_y, house.t_z+0.05, false, false, false, false)
            SetEntityHeading(PlayerPedId(), house.t_heading)
            TriggerEvent("vSync:StopSyncWeather")

        end, house)

    else

        TriggerEvent("vSync:SyncWeather")
        TriggerEvent("PlaySound", "sounds/Doors/door_open.mp3", .3)
        TriggerEvent("PlaySoundForEveryoneInVicinity", "sounds/Doors/door_open.mp3")
        SetEntityCoords(PlayerPedId(), house.t_x, house.t_y, house.t_z+0.05, false, false, false, false)
        SetEntityHeading(PlayerPedId(), house.t_heading)
        despawn_house()

    end

end

local function get_walk_through_interaction(house)

    local dialog = nil
    local callback = function() 
        exports["em_dialog"]:hide_dialog()
    end

    if not house.locked then
        dialog = "[Walk through door]"
        callback = function()
            exports["em_dialog"]:hide_dialog()
            prepare_house(house)
        end
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
            t_heading = houses[i].exit_heading,
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
            t_heading = houses[i].enter_heading,
            can_unlock = houses[i].can_unlock,
            locked = houses[i].locked
        })

    end
    return housing_doors

end

local function refresh_loop(refresh_func)

    exports["em_dal"]:get_nearby_houses_async(function(houses)

        housing_doors_cache = get_split_by_doors(houses)
        refresh_func(housing_doors_cache)

    end, housing_type_ids.motels)

end

local function text(nearby_house)

    return "Press [E] to use door."

end

local function marker_loop()

    local found_nearby_door = false
    while true do

        Citizen.Wait(5)
        found_nearby_door = false
        for i = 1, #housing_doors_cache do

            if housing_doors_cache[i].house_id == motel_house_id and housing_doors_cache[i].entrance then
                found_nearby_door = true
                local x = housing_doors_cache[i].x
                local y = housing_doors_cache[i].y
                local z = housing_doors_cache[i].z
                DrawMarker(0, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 50, false, true, 2, nil, nil, false)
            end

        end
        if not found_nearby_door then
            Citizen.Wait(5000)
        end
    end

end

local function setup_blip()

    exports["em_dal"]:get_house_async(function(house_data)

        local house = house_data.house
        local blip = AddBlipForCoord(house.spawn_x, house.spawn_y, house.spawn_z)
        SetBlipSprite(blip, 40)
        SetBlipColour(blip, 19)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Motel")
        EndTextCommandSetBlipName(blip)

    end, motel_house_id)

end

AddEventHandler("em_dal:character_loaded", function()

    exports["em_dal"]:trigger_server_callback_async("em_housing:get_player_motel_allotment", function(house_id) 

        motel_house_id = house_id
        setup_blip()
        Citizen.CreateThread(marker_loop)

    end, exports["em_dal"]:get_player_id(), exports["em_dal"]:get_character_id())

    exports["em_points"]:register_points(refresh_loop, text, interact_motel)
    
end)

RegisterNetEvent("em_housing:toogle_motel_lock")
AddEventHandler("em_housing:toogle_motel_lock", function(house)

    for i = 1, #housing_doors_cache do

        if housing_doors_cache[i].housing_door_id == house.housing_door_id then
            housing_doors_cache[i].locked = house.locked
            break
        end

    end

end)
