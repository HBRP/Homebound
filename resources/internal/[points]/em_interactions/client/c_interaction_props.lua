
local props = {}

local function interact_with_prop(prop)

    TriggerEvent(prop.interaction_event, prop)

end

local function refresh_loop(refresh_func)

    refresh_func(props)

end

local function text(prop)

    return string.format("Press [E] to %s", prop.interaction_text)

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_fw"]:get_all_interaction_props_async(function(result)

        props = result or {}
        exports["em_points"]:register_raycast_points(refresh_loop, text, interact_with_prop)

    end)
    
end)

