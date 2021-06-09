
local keys = {
    {slot = 1},
    {slot = 2},
    {slot = 3},
    {slot = 4},
    {slot = 5}
}

local key_tab = 37

local function put_away_weapon(weapon_hash)

    exports["em_items"]:animate_weapon_pullout(exports["em_items"]:get_weapon_item_id_from_hash(weapon_hash), false)
    SetPedCurrentWeaponVisible(PlayerPedId(), false, true, false, false)
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263, true)

end

local function use_item_in_slot(slot)

    local storage_items = (exports["em_dal"]:get_character_storage())["storage_items"]
    local item_in_slot = exports["em_items"]:get_item_in_slot(storage_items, slot)

    if item_in_slot == nil then
        return
    end

    local weapon_hash = GetSelectedPedWeapon(PlayerPedId())
    if weapon_hash ~= -1569615261 and weapon_hash ~= 0 then
        
        if exports["em_items"]:is_item_type_a_weapon(item_in_slot.item_type_id) then

            if exports["em_items"]:get_item_weapon_hash(item_in_slot.item_id) == weapon_hash then

                put_away_weapon(weapon_hash)
                return

            end

        end

    end
    exports["em_items"]:use_item(item_in_slot.item_id, item_in_slot.item_type_id, item_in_slot.storage_item_id, item_in_slot.item_metadata)

end

local function use_hotkey(idx)

    if exports["em_gen_commands"]:is_handcuffed() then
        return
    end

    use_item_in_slot(keys[idx].slot)

end

local function disable_hotkeys()

    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(20)
    DisableControlAction(0, key_tab, true)

end

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        disable_hotkeys()
    end

end)

RegisterCommand('hotbar_1', function() use_hotkey(1) end, false)
RegisterCommand('hotbar_2', function() use_hotkey(2) end, false)
RegisterCommand('hotbar_3', function() use_hotkey(3) end, false)
RegisterCommand('hotbar_4', function() use_hotkey(4) end, false)
RegisterCommand('hotbar_5', function() use_hotkey(5) end, false)
RegisterCommand('hotbar_tab', function()

    local weapon_hash = GetSelectedPedWeapon(PlayerPedId())

    if weapon_hash == -1569615261 or weapon_hash == 0 then
        return
    end

    put_away_weapon(weapon_hash)

end, false)


RegisterKeyMapping('hotbar_1', 'hotbar_1', 'keyboard', '1')
RegisterKeyMapping('hotbar_2', 'hotbar_2', 'keyboard', '2')
RegisterKeyMapping('hotbar_3', 'hotbar_3', 'keyboard', '3')
RegisterKeyMapping('hotbar_4', 'hotbar_4', 'keyboard', '4')
RegisterKeyMapping('hotbar_5', 'hotbar_5', 'keyboard', '5')
RegisterKeyMapping('hotbar_tab', 'hotbar_tab', 'keyboard', 'TAB')