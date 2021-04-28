

local nearby_houses = {}

local function attempt_toggle_lock(house)


end

local function get_split_by_doors(houses)

    local housing_doors = {}
    for i = 1, #houses do

        table.insert(housing_doors, {
            entrance = true,
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

    if nearby_house.locked and (nearby_house.can_unlock or not nearby_house.entrance) then
        return "Press [E] to use door.<br/>Press [G] to unlock."
    end

    if not nearby_house.locked and nearby_house.can_unlock then
        return "Press [E] to use door.<br/>Press [G] to lock."
    end

    if not nearby_house.locked then
        return "Press [E] to use door."
    end

    if nearby_house.locked then
        return "Door is Locked."
    end

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_points(refresh_loop, text, attempt_toggle_lock)
    
end)

