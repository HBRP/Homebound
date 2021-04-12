
local keys = {
    {key = 157, slot = 1},
    {key = 158, slot = 2},
    {key = 160, slot = 3},
    {key = 164, slot = 4},
    {key = 165, slot = 5}
}

local key_tab = 37

local function use_item_in_slot(slot)

    local storage_items = (exports["em_fw"]:get_character_storage())["storage_items"]
    local item_in_slot = exports["em_items"]:get_item_in_slot(storage_items, slot)

    if item_in_slot == nil then
        return
    end
    exports["em_items"]:use_item(item_in_slot.item_id, item_in_slot.item_type_id, item_in_slot.storage_item_id, item_in_slot.item_metadata)

end

local function check_for_hotkeys()

    if exports["em_gen_commands"]:is_handcuffed() then
        return
    end

    for i = 1, #keys do
        if IsDisabledControlJustReleased(0, keys[i].key) then
            use_item_in_slot(keys[i].slot)
            break
        end
    end

    if IsDisabledControlJustReleased(0, key_tab) then

        local weapon_hash = GetSelectedPedWeapon(PlayerPedId())

        if weapon_hash == -1569615261 or weapon_hash == 0 then
            return
        end

        exports["em_items"]:animate_weapon_pullout(exports["em_items"]:get_weapon_item_id_from_hash(weapon_hash), false)
        SetPedCurrentWeaponVisible(PlayerPedId(), false, true, false, false)
        SetCurrentPedWeapon(PlayerPedId(), 0xA2719263, true)

    end

end

local function disable_hotkeys()

    for i = 1, #keys do
        DisableControlAction(0, keys[i].key, true)
    end
    DisableControlAction(0, key_tab, true)

end

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(5)
        disable_hotkeys()
        check_for_hotkeys()
    end

end)