
local weapons = nil
local attachments = nil

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

function get_ammo_for_weapon(ammo_item_id, storage_items)

    local ammo_count = 0
    for i = 1, #storage_items do

        if storage_items[i].item_id == ammo_item_id then
            ammo_count = ammo_count + storage_items[i].amount
        end

    end
    return ammo_count

end

local equiped_weapon_hash = nil
local equiped_weapon_item_id = nil
local running_shooting_loop = false

local function remove_ammo(ammo_item_id, amount, storage_items)

    if amount == 0 then
        return
    end

    amount_left_to_remove = amount
    for i = 1, #storage_items do

        if storage_items[i].item_id == ammo_item_id then

            if storage_items[i].amount >= amount_left_to_remove then
                exports["em_fw"]:remove_item(storage_items[i].storage_item_id, amount_left_to_remove)
                break
            else
                exports["em_fw"]:remove_item(storage_items[i].storage_item_id, amount_left_to_remove - storage_items[i].amount)
                amount_left_to_remove = amount_left_to_remove - storage_items[i].amount
            end

        end

    end

end

local function shooting_loop()

    running_shooting_loop = true

    local ped = PlayerPedId()
    while running_shooting_loop do

        Citizen.Wait(10)
        if IsPedShooting(ped) then

            assert(equiped_weapon_hash == GetSelectedPedWeapon(ped))
            Citizen.Wait(1000)
            local current_ammo_in_gun = GetAmmoInPedWeapon(ped, equiped_weapon_hash)
            local ammo_item_id        = get_weapon_ammo_item_id(equiped_weapon_item_id)
            local storage_items       = (exports["em_fw"]:get_character_storage())["storage_items"]
            local ammo_in_inventory   = get_ammo_for_weapon(ammo_item_id, storage_items)
            local ammo_diff = ammo_in_inventory - current_ammo_in_gun
            remove_ammo(ammo_item_id, ammo_diff, storage_items)

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

    exports["em_fw"]:get_storage_async(function(result)

        local storage_items = result["storage_items"]

        for i = 1, #storage_items do
            local hash = get_attachment_hash(item_id, storage_items[i].item_id)
            if hash ~= nil then
                GiveWeaponComponentToPed(PlayerPedId(), equiped_weapon_hash, hash)
            end
        end

    end, item_metadata.hidden.storage_id)

end

local function animate_fast_pullout()

    local dict = "move_m@intimidation@cop@unarmed"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), dict, "idle", 8.0, 8.0, 750, 2 + 16 + 32, 1.0, 0, 0, 0)
    Citizen.Wait(750)
    TaskPlayAnim(PlayerPedId(), dict, "idle", 8.0, 8.0, 0, 16 + 32, 1.0, 0, 0, 0)

end

local function animate_normal_pullout()

    local dict = "reaction@intimidation@1h"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    if intro then
        TaskPlayAnimAdvanced(GetPlayerPed(-1), dict, "intro", GetEntityCoords(PlayerPedId(), true), 0, 0, GetEntityHeading(PlayerPedId()), 8.0, 3.0, -1, 50, 0, 0, 0)
    else
        TaskPlayAnimAdvanced(GetPlayerPed(-1), dict, "outro", GetEntityCoords(PlayerPedId(), true), 0, 0, GetEntityHeading(PlayerPedId()), 8.0, 3.0, -1, 50, 0, 0, 0)
    end

    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())

end

function animate_weapon_pullout(intro)

    if exports["em_jobs"]:can_fast_draw() then
        animate_fast_pullout(intro)
    else
        animate_normal_pullout(intro)
    end

end

function equip_weapon(item_id, item_metadata)

    animate_weapon_pullout(true)

    local hash = get_item_weapon_hash(item_id)
    local ped  = PlayerPedId()
    GiveWeaponToPed(ped, hash, 0, false, true)
    SetCurrentPedWeapon(ped, hash, true)

    equiped_weapon_hash    = hash
    equiped_weapon_item_id = item_id

    if not does_weapon_use_ammo(item_id) then
        return
    end

    local storage_items = (exports["em_fw"]:get_character_storage())["storage_items"]
    local ammo_amount   = get_ammo_for_weapon(get_weapon_ammo_item_id(item_id), storage_items)
    SetPedAmmo(ped, hash, ammo_amount)

    if not running_shooting_loop then
        Citizen.CreateThread(shooting_loop)
    end
    set_attachments(item_id, item_metadata)

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    weapons     = exports["em_fw"]:get_weapons()
    attachments = exports["em_fw"]:get_attachments()

end)

AddEventHandler('em_fw:inventory_change', function()

    local ped = PlayerPedId()
    if equiped_weapon_hash ~= nil and equiped_weapon_hash == GetSelectedPedWeapon(ped) then
        local storage_items = (exports["em_fw"]:get_character_storage())["storage_items"]
        local ammo_amount   = get_ammo_for_weapon(get_weapon_ammo_item_id(equiped_weapon_item_id), storage_items)
        SetPedAmmo(ped, equiped_weapon_hash, ammo_amount)
        return
    end

    RemoveAllPedWeapons(ped, false)
    running_shooting_loop  = false
    equiped_weapon_hash    = nil
    equiped_weapon_item_id = nil

end)