
local weapons = nil

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

function get_ammo_item_id(item_id)

    for i = 1, #weapons do

        if weapons[i].item_id == item_id then
            return weapons[i].ammo_item_id
        end

    end
    return 0

end

function does_weapon_use_ammo(item_id)

    for i = 1, #weapons do

        if weapons[i].item_id == item_id then
            return weapons[i].item_uses_ammo
        end

    end
    return false

end

function get_ammo_for_weapon(ammo_item_id, storage_items)

    local ammo_count = 0
    for i = 1, #storage_items do

        if storage_items[i].item_id == ammo_item_id then
            ammo_count = ammo_count + storage_items[i].amount
        end

    end
    return ammo_count

end


function equip_weapon(item_id)

    local hash = get_item_weapon_hash(item_id)
    local ped  = PlayerPedId()
    GiveWeaponToPed(ped, hash, 0, false, true)
    SetCurrentPedWeapon(ped, hash, true)

    if not does_weapon_use_ammo(item_id) then
        return
    end

    local storage_items = (exports["em_fw"]:get_character_storage())["storage_items"]
    local ammo_amount   = get_ammo_for_weapon(get_ammo_item_id(item_id), storage_items)
    SetPedAmmo(ped, hash, ammo_amount)

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    weapons = exports["em_fw"]:get_weapons()

end)

AddEventHandler('em_fw:inventory_change', function()

    RemoveAllPedWeapons(PlayerPedId(), false)

end)