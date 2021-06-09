
local manual_stashes = {}

local function open_stash(stash)
    TriggerEvent("esx_inventoryhud:open_secondary_inventory", stash.storage_id, "Stash")
end

local function refresh_loop(refresh_check)

    local nearby_stashes = exports["em_dal"]:get_nearby_stashes()

    for i = 1, #manual_stashes do
        table.insert(nearby_stashes, manual_stashes[i])
    end

    refresh_check(nearby_stashes)

end

local function text(stash)
    return "Press [E] to access stash"
end

AddEventHandler("em_dal:character_loaded", function()

    exports["em_points"]:register_points(refresh_loop, text, open_stash)

end)


function register_manual_stashes(stashes)
    manual_stashes = stashes
end

function deregister_manual_stashes()
    manual_stashes = {}
end