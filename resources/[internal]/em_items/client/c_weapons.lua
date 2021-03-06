
local weapons = nil
local attachments = nil

local equipped_weapon_hash = nil
local equipped_weapon_item_id = nil
local running_shooting_loop = false

function is_item_type_a_weapon(item_type_id)

    return item_type_ids.WEAPON == item_type_id

end

function is_item_type_ammo(item_type_id)

    return item_type_ids.AMMO == item_type_id

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

function get_weapon_ammo_item_id(item_id)

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

function does_weapon_hash_alert_cops(weapon_hash)

    for i = 1, #weapons do

        if weapons[i].item_weapon_hash == weapon_hash then
            return weapons[i].item_alerts_cops
        end
        
    end

    return false

end

function get_weapon_item_id_from_hash(weapon_hash)

    for i = 1, #weapons do

        if weapons[i].item_weapon_hash == weapon_hash then
            return weapons[i].item_id
        end
        
    end

    return 0

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

function get_weapon_type(item_id)

    for i = 1, #weapons do

        if weapons[i].item_id == item_id then
            return weapons[i].item_weapon_type_id
        end
        
    end

    return 0

end

function is_ped_shooting_a_gun()

    if IsPedShooting(PlayerPedId()) then

        local weapon_type = get_weapon_type(equipped_weapon_item_id)
        return weapon_type > 2 and weapon_type < 9

    end

    return false

end

function does_character_have_knife()

    local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
    for i = 1, #storage_items do

        if get_weapon_type(storage_items[i].item_id) == item_weapon_type_ids.KNIFE then
            return true
        end

    end
    
    return false

end

function does_character_have_a_weapon()

    local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
    for i = 1, #storage_items do

        if get_weapon_type(storage_items[i].item_id) ~= 0 then
            return true
        end

    end
    
    return false

end

function is_character_holding_a_weapon()

    local weapon_hash = GetSelectedPedWeapon(PlayerPedId())
    return not (weapon_hash == -1569615261 or weapon_hash == 0)

end

local function remove_ammo(ammo_item_id, amount, storage_items)

    if amount == 0 then
        return
    end
    exports["em_dal"]:remove_any_item(exports["em_dal"]:get_character_storage_id(), ammo_item_id, amount)

end

local function shooting_loop()

    running_shooting_loop = true

    local ped = PlayerPedId()
    local ped_was_shooting = false

    local shooting_weapon_hash = nil
    local shooting_weapon_item_id = nil
    while running_shooting_loop do

        Citizen.Wait(10)

        if IsPedShooting(ped) then

            ped_was_shooting = true
            shooting_weapon_hash    = equipped_weapon_hash
            shooting_weapon_item_id = equipped_weapon_item_id

            Citizen.Wait(2000)

        end

        if not IsPedShooting(ped) and ped_was_shooting then
            
            local ammo_item_id  = get_weapon_ammo_item_id(shooting_weapon_item_id)
            local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
            local inventory_ammo = get_ammo_for_weapon(ammo_item_id, storage_items)
            local ammo_diff = inventory_ammo - GetAmmoInPedWeapon(ped, shooting_weapon_hash)

            if ammo_diff < 0 then
                SetPedAmmo(ped, equipped_weapon_hash, inventory_ammo)
                goto shooting_loop_continue
            end

            --assert(ammo_diff >= 0, string.format("More ammo in gun than in inventory ammo_diff: %d for weapon_item_id: %d", ammo_diff, shooting_weapon_item_id))

            remove_ammo(ammo_item_id, ammo_diff, storage_items)

            ped_was_shooting = false
            shooting_weapon_hash = nil
            shooting_weapon_item_id = nil
            ::shooting_loop_continue::

        end

    end

end

local function get_attachment_hash(weapon_item_id, attachment_item_id)

    for i = 1, #attachments do
        if attachments[i].weapon_item_id == weapon_item_id and attachments[i].item_id == attachment_item_id then
            return attachments[i].item_attachment_hash
        end
    end
    return nil

end

local function set_attachments(item_id, item_metadata)

    if item_metadata.hidden == nil or item_metadata.hidden.storage_id == nil then
        return
    end

    exports["em_dal"]:get_storage_async(function(result)

        local storage_items = result["storage_items"]

        for i = 1, #storage_items do
            local hash = get_attachment_hash(item_id, storage_items[i].item_id)
            if hash ~= nil then
                GiveWeaponComponentToPed(PlayerPedId(), equipped_weapon_hash, hash)
            end
        end

    end, item_metadata.hidden.storage_id)

end

function equip_weapon(item_id, item_metadata)

    animate_weapon_pullout(item_id, true)

    local hash = get_item_weapon_hash(item_id)
    local ped  = PlayerPedId()

    local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
    local ammo_amount   = get_ammo_for_weapon(get_weapon_ammo_item_id(item_id), storage_items)
    SetPedAmmo(ped, hash, ammo_amount)
    
    GiveWeaponToPed(ped, hash, ammo_amount, false, true)
    SetCurrentPedWeapon(ped, hash, true)

    equipped_weapon_hash    = hash
    equipped_weapon_item_id = item_id

    if not does_weapon_use_ammo(item_id) then
        return
    end

    if not running_shooting_loop then
        Citizen.CreateThread(shooting_loop)
    end
    set_attachments(item_id, item_metadata)

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    weapons     = exports["em_dal"]:get_weapons()
    attachments = exports["em_dal"]:get_attachments()

end)

AddEventHandler('em_dal:inventory_change', function()

    local ped = PlayerPedId()
    if equipped_weapon_hash ~= nil and equipped_weapon_hash == GetSelectedPedWeapon(ped) then
        local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
        local ammo_amount   = get_ammo_for_weapon(get_weapon_ammo_item_id(equipped_weapon_item_id), storage_items)
        SetPedAmmo(ped, equipped_weapon_hash, ammo_amount)
        return
    end

    RemoveAllPedWeapons(ped, false)
    running_shooting_loop  = false
    equipped_weapon_hash    = nil
    equipped_weapon_item_id = nil

end)