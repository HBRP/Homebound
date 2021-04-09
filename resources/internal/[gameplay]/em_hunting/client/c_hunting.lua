

local animal_skinning = {

    ['a_c_mtlion'] = {{item_name = 'mountain lion meat', amount = 3},{item_name = 'mountain lion pelt', amount = 1}},
    ['a_c_deer']   = {{item_name = 'deer meat', amount = 3},{item_name = 'deer pelt', amount = 1}},
    ['a_c_coyote'] = {{item_name = 'coyote meat', amount = 2}, {item_name = 'coyote pelt', amount = 1}},
    ['a_c_rabbit_01'] = {{item_name = 'rabbit meat', amount = 1}, {item_name = 'rabbit pelt', amount = 1}},
    ['a_c_seagull'] = {{item_name = 'beach pigeon', amount = 1}, {item_name = 'feathers', amount = 20}},
    ['a_c_crow'] = {{item_name = 'crow meat', amount = 1}, {item_name = 'feathers', amount = 10}},
    ['a_c_cormorant'] = {{item_name = 'cormorant meat', amount = 1}, {item_name = 'feathers', amount = 20}},
    ['a_c_chickenhawk'] = {{item_name = 'chicken hawk meat', amount = 1}, {item_name = 'feathers', amount = 20}},
    ['a_c_husky'] = {{item_name = 'dog meat', amount = 1}, {item_name = 'dog pelt', amount = 1}},
    ['a_c_poodle'] = {{item_name = 'dog meat', amount = 1}, {item_name = 'dog pelt', amount = 1}},
    ['a_c_cat_01'] = {{item_name = 'cat meat', amount = 1}, {item_name = 'cat pelt', amount = 1}},
    ['a_c_pug'] = {{item_name = 'dog meat', amount = 1}, {item_name = 'dog pelt', amount = 1}}

}

local entities = {}

local function give_items(prop)

    local items = animal_skinning[prop.prop_name]
    for i = 1, #items do

        local item_id = exports["em_items"]:get_item_id_from_name(items[i].item_name)
        exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), item_id, items[i].amount, -1, -1)

    end

end

local function animate_skinning(prop)

    exports["em_animations"]:play_animation_sync("rcmextreme3", "idle", 2500, 2 + 32)

end

local function can_skin(entity)

    for i = 1, #entities do
        if entities[i] == entity then
            return false
        end
    end
    return true

end

AddEventHandler("animal_cutting", function(prop, entity)

    if not IsEntityDead(entity) then
        exports["t-notify"]:Alert({style="error", message="Animal isn't dead!"})
        return
    end

    if not can_skin(entity) then
        exports["t-notify"]:Alert({style="error", message="Animal is already being skinned"})
    end

    if not exports["em_items"]:does_character_have_knife() then
        exports["t-notify"]:Alert({style="error", message="You need to have a knife"})
        return
    end

    exports["em_fw"]:trigger_proximity_event("em_hunting:skinning_animal", 100.0, NetworkGetNetworkIdFromEntity(entity))

    animate_skinning(prop)
    give_items(prop)

    exports["t-notify"]:Alert({style="info", message="Skinned Animal"})
    exports["em_fw"]:trigger_proximity_event("em_hunting:delete_entity", 100.0, NetworkGetNetworkIdFromEntity(entity))

end)

RegisterNetEvent("em_hunting:delete_entity")
AddEventHandler("em_hunting:delete_entity", function(entity_network_id)

    local entity = NetworkGetEntityFromNetworkId(entity_network_id)

    for i = 1, #entities do

        if entities[i] == entity then
            table.remove(entities, i)
            break
        end

    end

    DeleteEntity(entity)

end)

RegisterNetEvent("em_hunting:skinning_animal")
AddEventHandler("em_hunting:skinning_animal", function(entity_network_id)

    local entity = NetworkGetEntityFromNetworkId(entity_network_id)
    table.insert(entities, entity)

end)