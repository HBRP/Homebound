
local function open_stash(stash)
    TriggerEvent("esx_inventoryhud:open_secondary_inventory", stash.storage_id, "Stash")
end

local function refresh_loop(refresh_check)
    refresh_check(exports["em_fw"]:get_nearby_stashes())
end

local function text(stash)
    return "Press [E] to access stash"
end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_points"]:register_points(refresh_loop, text, open_stash)

end)