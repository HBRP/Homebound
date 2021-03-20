

local function apply_item_modifiers(item_id)

    local item_modifiers = exports["em_fw"]:get_item_modifiers(item_id)
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

function use_item(item_id, item_type_id, storage_item_id)

    if item_type_id == item_type_ids.FOOD then

        eat()
        apply_item_modifiers(item_id)
        exports["em_fw"]:remove_item(storage_item_id, 1)

    elseif item_type_id == item_type_ids.LIQUID then

        drink()
        apply_item_modifiers(item_id)
        exports["em_fw"]:remove_item(storage_item_id, 1)

    elseif item_type_id == item_type_ids.ARMOUR then

        apply_armour_anim()
        apply_item_modifiers(item_id)
        exports["em_fw"]:remove_item(storage_item_id, 1)

    elseif item_type_id == item_type_ids.WEAPON then

        equip_weapon(item_id)

    end

end

function get_item_in_slot(storage_items, slot)

    for i = 1, #storage_items do
        if slot == storage_items[i].slot then
            return storage_items[i]
        end
    end

    return nil

end