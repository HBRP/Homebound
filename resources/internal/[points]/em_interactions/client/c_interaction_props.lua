
local props = {}

local function interact_with_prop(prop, entity)

    TriggerEvent(prop.interaction_event, prop, entity)

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

        for i = 1, #props do

            local prop_hash = props[i].prop_hash
            local hash_key  = GetHashKey(props[i].prop_name)
            assert(prop_hash == hash_key, string.format("Hash mismatch %d %d", prop_hash, hash_key))

        end

        exports["em_points"]:register_raycast_points(refresh_loop, text, interact_with_prop)

    end)
    
end)

