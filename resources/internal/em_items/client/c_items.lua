

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

local weapons = nil

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

    elseif item_type_id == item_type_ids.WEAPON then

        local hash = get_item_weapon_hash(item_id)
        GiveWeaponToPed(PlayerPedId(), hash, 0, false, true)
        SetCurrentPedWeapon(PlayerPedId(), hash, true)

    end

end

function is_item_type_a_weapon(item_type_id)

    return item_type_ids.WEAPON == item_type_id

end

function get_item_weapon_model(item_id)

    for i = 1, #weapons do

        if weapons[i].item_id == item_id then
            return weapons[i].item_weapon_model
        end

    end
    return nil

end

function get_item_weapon_hash(item_id)

    for i = 1, #weapons do

        if weapons[i].item_id == item_id then
            return weapons[i].item_weapon_hash
        end

    end
    return nil

end

function get_item_in_slot(storage_items, slot)

    for i = 1, #storage_items do
        if slot == storage_items[i].slot then
            return storage_items[i]
        end
    end

    return nil

end

local function setup_weapon_cache()

    weapons = exports["em_fw"]:get_weapons()

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    setup_weapon_cache()


end)