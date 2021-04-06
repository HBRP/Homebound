
local function interact_with_point(point)

    TriggerEvent(point.interaction_event, point)

end

local function refresh_loop(refresh_func)

    exports["em_fw"]:get_nearby_interaction_points_async(refresh_func)

end

local function text(point)

    return string.format("Press [E] to %s", point.interaction_text)

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_points(refresh_loop, text, interact_with_point)
    
end)

