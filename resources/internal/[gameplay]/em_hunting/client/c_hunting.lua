

local animal_skinning = {

    ['a_c_mtlion'] = {{item_name = 'mountain lion meat', amount = 3},{item_name = 'mountain lion pelt', amount = 1}},
    ['a_c_deer']   = {{item_name = 'deer meat', amount = 3},{item_name = 'deer pelt', amount = 1}},
    ['a_c_coyote'] = {{item_name = 'coyote meat', amount = 2}, {item_name = 'coyote pelt', amount = 1}},
    ['a_c_rabbit_01'] = {{item_name = 'rabbit meat', amount = 1}, {item_name = 'rabbit pelt', amount = 1}},
    ['a_c_seagull'] = {{item_name = 'beach pidgeon', amount = 1}, {item_name = 'feathers', amount = 20}},
    ['a_c_crow'] = {{item_name = 'crow meat', amount = 1}, {item_name = 'feathers', amount = 10}},
    ['a_c_cormorant'] = {{item_name = 'cormorant meat', amount = 1}, {item_name = 'feathers', amount = 20}},
    ['a_c_chickenhawk'] = {{item_name = 'chicken hawk meat', amount = 1}, {item_name = 'feathers', amount = 20}}

}

local function give_items(prop)



end

local function animate_skinning(prop)

    exports["em_animations"]:play_animation("rcmextreme3", "idle", 2500, 2 + 32)
    Citizen.Wait(5000)

end

AddEventHandler("animal_cutting", function(prop, entity)

    if not exports["em_items"]:does_character_have_knife() then
        exports["t-notify"]:Alert({style="error", message="You need to have a knife"})
        return
    end

    if not IsEntityDead(entity) then
        exports["t-notify"]:Alert({style="error", message="Animal isn't dead!"})
        return
    end

    animate_skinning(prop)
    give_items(prop)

    exports["t-notify"]:Alert({style="info", message="Skinned Animal"})
    exports["em_fw"]:trigger_proximity_event("em_hunting:delete_entity", 100.0, NetworkGetNetworkIdFromEntity(entity))

end)

RegisterNetEvent("em_hunting:delete_entity")
AddEventHandler("em_hunting:delete_entity", function(entity_network_id)

    local entity = NetworkGetEntityFromNetworkId(entity_network_id)
    DeleteEntity(entity)

end)