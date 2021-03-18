

local item_type_ids = {

    FOOD       = 1,
    LIQUID     = 2,
    WEAPON     = 3,
    AMMO       = 4,
    ATTACHMENT = 5,
    BAG        = 6,
    MISC       = 7

}

local item_modifier_type_ids = {

    FOOD   = 1,
    LIQUID = 2

}

local function apply_item_modifiers(item_id)

    local item_modifiers = exports["em_fw"]:get_item_modifiers(item_id)
    for i = 1, #item_modifiers do

        if item_modifiers[i].item_modifier_type_id == item_modifier_type_ids.FOOD then

            exports["em_medical"]:add_stat("FOOD", item_modifiers[i].item_modifier)

        elseif item_modifiers[i].item_modifier_type_id == item_modifier_type_ids.LIQUID then

            exports["em_medical"]:add_stat("WATER", item_modifiers[i].item_modifier)
            
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

    end

end