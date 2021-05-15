
local items_cache = nil
local item_use_callbacks = {}

local function fire_item_callback(item_id, storage_item_id, item_metadata)

    for i = 1, #item_use_callbacks do
        if item_use_callbacks[i].item_id == item_id then
            item_use_callbacks[i].callback(storage_item_id, item_metadata)
            break
        end
    end

end

function get_item_id_from_name(item_name)

    for i = 1, #items_cache do
        if items_cache[i].item_name == item_name then
            return items_cache[i].item_id
        end
    end
    return 0

end

function get_item_name_from_item_id(item_id)

    for i = 1, #items_cache do
        if items_cache[i].item_id == item_id then
            return items_cache[i].item_name
        end
    end
    return 0

end

function get_character_storage_item_id(item_id)

    local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
    for i = 1, #storage_items do

        if storage_items[i].item_id == item_id then
            return storage_items[i].storage_item_id
        end

    end
    return 0

end

function get_character_storage_item_id_by_name(item_name)

    local item_id = get_item_id_from_name(item_name)
    return get_character_storage_item_id(item_id)

end

function get_item_amount_by_name(item_name)

    local item_id = get_item_id_from_name(item_name)
    local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
    local amount = 0

    for i = 1, #storage_items do

        if storage_items[i].item_id == item_id then
            amount = amount + storage_items[i].amount
        end

    end

    return amount

end

function has_item_by_name(item_name)

    return get_character_storage_item_id_by_name(item_name) > 0

end


function register_item_use(item_name, callback)

    Citizen.CreateThread(function() 

        while items_cache == nil do
            Citizen.Wait(1000)
        end

        local item_id = get_item_id_from_name(item_name)
        for i = 1, #item_use_callbacks do

            if item_use_callbacks[i].item_id == item_id then

                Citizen.Trace(string.format("Replacing register_item_use %s callback", item_name))
                item_use_callbacks[i].callback = callback
                return

            end 

        end 

        table.insert(item_use_callbacks, {item_id = item_id, callback = callback})

    end)

end

local function apply_item_modifiers(item_id)

    local item_modifiers = exports["em_dal"]:get_item_modifiers(item_id)
    for i = 1, #item_modifiers do

        if item_modifiers[i].item_modifier_type_id == item_modifier_type_ids.FOOD then

            exports["em_medical"]:add_stat("FOOD", item_modifiers[i].item_modifier)

        elseif item_modifiers[i].item_modifier_type_id == item_modifier_type_ids.LIQUID then

            exports["em_medical"]:add_stat("WATER", item_modifiers[i].item_modifier)
            
        elseif item_modifiers[i].item_modifier_type_id == item_modifier_type_ids.ARMOUR then

            AddArmourToPed(PlayerPedId(), item_modifiers[i].item_modifier)

        end

    end

end

function use_item(item_id, item_type_id, storage_item_id, item_metadata)

    if item_type_id == item_type_ids.FOOD then

        eat()
        apply_item_modifiers(item_id)
        exports["em_dal"]:remove_item(storage_item_id, 1)

    elseif item_type_id == item_type_ids.LIQUID then

        drink()
        apply_item_modifiers(item_id)
        exports["em_dal"]:remove_item(storage_item_id, 1)

    elseif item_type_id == item_type_ids.ARMOUR then

        apply_armour_anim()
        apply_item_modifiers(item_id)
        exports["em_dal"]:remove_item(storage_item_id, 1)

    elseif item_type_id == item_type_ids.WEAPON then

        equip_weapon(item_id, item_metadata)

    end
    fire_item_callback(item_id, storage_item_id, item_metadata)

end

function get_item_in_slot(storage_items, slot)

    for i = 1, #storage_items do
        if slot == storage_items[i].slot then
            return storage_items[i]
        end
    end

    return nil

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_dal"]:trigger_server_callback("em_items:get_items", function(items)

        items_cache = items or {}
        
    end)

end)