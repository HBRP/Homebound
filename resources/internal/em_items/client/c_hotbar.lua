
local keys = {
    {key = 157, slot = 1},
    {key = 158, slot = 2},
    {key = 160, slot = 3},
    {key = 164, slot = 4},
    {key = 165, slot = 5}
}

local function use_item_in_slot(slot)

    local storage_items = (exports["em_fw"]:get_character_storage())["storage_items"]
    local item_in_slot = get_item_in_slot(storage_items, slot)

    if item_in_slot == nil then
        return
    end
    use_item(item_in_slot.item_id, item_in_slot.item_type_id, item_in_slot.storage_item_id)

end

local function check_for_hotkeys()

    for i = 1, #keys do
        if IsDisabledControlJustReleased(0, keys[i].key) then
            use_item_in_slot(keys[i].slot)
            break
        end
    end

end

local function disable_hotkeys()

    for i = 1, #keys do
        DisableControlAction(0, keys[i].key, true)
    end

end

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        disable_hotkeys()
        check_for_hotkeys()
    end

end)