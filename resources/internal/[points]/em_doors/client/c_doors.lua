

local function interact_with_door(door)

    print(json.encode(door))

end

local function refresh_loop(refresh_func)

    exports["em_fw"]:get_nearby_doors_async(function(doors)

        for i = 1, #doors do
            for j = 1, #doors[i].doors do
                doors[i].doors[j].prop_hash = GetHashKey(doors[i].doors[j].model_name)
            end
        end
        refresh_func(doors)

    end)

end

local function text(door)

    return string.format("Press [E] to %s", "open")

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_raycast_door(refresh_loop, text, interact_with_door, 2500)
    
end)

--exports["em_points"]:register_raycast_door(refresh_loop, text, interact_with_door, 2500)

