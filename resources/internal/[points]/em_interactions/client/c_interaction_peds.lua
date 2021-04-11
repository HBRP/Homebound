
local known_interaction_peds = {}

local function interact_with_ped(ped, entity)

    TriggerEvent(ped.interaction_event, ped, entity)

end

local function set_hash_keys(peds)

    for i = 1, #peds do
        peds[i].prop_hash = GetHashKey(peds[i].ped_model) 
    end

end

local function spawn_peds(peds)

    local nearby_peds = {}
    for ped in exports["em_fw"]:enumerate_peds() do

        local entity_hash   = GetEntityModel(ped)
        local entity_coords = GetEntityCoords(ped)
        table.insert(nearby_peds, {ped = ped, entity_hash = entity_hash, entity_coords = entity_coords})

    end

    for i = 1, #peds do

        local found_ped = false
        for j = 1, #nearby_peds do

            if #(vector3(peds[i].x, peds[i].y, peds[i].z) - nearby_peds[j].entity_coords) <= 25.0 and nearby_peds[j].entity_hash == peds[i].prop_hash then

                table.insert(known_interaction_peds, nearby_peds[j].ped)
                found_ped = true
                break

            end

        end

        if not found_ped then

            RequestModel(peds[i].prop_hash)
            while not HasModelLoaded(peds[i].prop_hash) do
                Citizen.Wait(5)
            end

            local ped = CreatePed(5, peds[i].prop_hash, peds[i].x, peds[i].y, peds[i].z, peds[i].heading, true, false)
            TaskStandStill(ped, 1000000000)
            table.insert(known_interaction_peds, ped)

        end

    end

end

local function refresh_loop(refresh_func)

    exports["em_fw"]:get_nearby_interaction_peds_async(function(result)

        local peds = result or {}
        known_interaction_peds = {}

        set_hash_keys(peds)
        spawn_peds(peds)
        refresh_func(peds)

    end)

end

local function text(ped)

    return string.format("Press [E] to %s", ped.interaction_text)

end

function is_interaction_ped(ped)

    for i = 1, #known_interaction_peds do
        if known_interaction_peds[i] == ped then
            return true
        end
    end
    return false

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_raycast_points(refresh_loop, text, interact_with_ped)
    
end)

