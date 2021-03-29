local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

isInInventory = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
            openInventory()
        end
    end
end)


local left_storage_id  = nil
local right_storage_id = nil
local right_inventory_name = nil
local in_store = false

function openInventory()

    left_storage_id  = nil
    right_storage_id = nil
    in_store = false

    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage(
        {
            action = "display",
            type = "normal"
        }
    )
    SetNuiFocus(true, true)
    TriggerEvent("opened_inventory")
end

function closeInventory()
    isInInventory = false
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    SetNuiFocus(false, false)
    TriggerEvent("closed_inventory")
end

RegisterNUICallback(
    "NUIFocusOff",
    function(data, cb)
        closeInventory()
        TriggerEvent("esx_inventoryhud:onClosedInventory", data.type)
        cb("ok")
    end
)

RegisterNUICallback("GetNearPlayers", function(data, cb)

    local elements = {}
    local characters = exports["em_fw"]:get_nearby_character_ids(3.0)

    for i = 1, #characters do
        table.insert(elements, { label = "", player = characters[i].character_id})
    end

    if #characters == 0 then
        exports['swt_notifications']:Negative("Storage", "No players nearby", "top", 3000, true)
    else
        SendNUIMessage(
        {
            action = "nearPlayers",
            foundAny = true,
            players = elements,
            item = data.item
        })
    end

    cb("ok")
end)

RegisterNUICallback("UseItem", function(data, cb)

    exports["em_items"]:use_item(data["item"].item_id, data["item"].item_type_id, data["item"].storage_item_id)
    closeInventory()
    cb("ok")

end)

RegisterNUICallback("DropItem", function(data, cb)

    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    item = data["item"]

    if data["number"] > item.count then
        exports['swt_notifications']:Negative("Storage", "Cannot drop more items than available in slot", "top", 3000, true)
        return
    end

    local drop_storage_id = exports["em_storage"]:get_nearby_drop_storage_id()

    exports["em_fw"]:give_item(drop_storage_id, item.item_id, data["number"], item.storage_item_id, -1)
    TriggerEvent("em_storage:manual_drop_refresh")
    loadPlayerInventory()

    cb("ok")
    
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            if GetPlayerServerId(players[i]) == data.player then
                foundPlayer = true
            end
        end
    end

    if foundPlayer then
        local count = tonumber(data.number)

        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end

        --TriggerServerEvent("esx:giveInventoryItem", data.player, data.item.type, data.item.name, count)
        Wait(250)
        loadPlayerInventory()
    else
        exports.pNotify:SendNotification(
            {
                text = _U("player_nearby"),
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "inventoryhud"
            }
        )
    end
    cb("ok")
end)

local function get_items_from_storage(storage_container)

    local storage_items     = storage_container["storage_items"]
    local max_storage_slots = storage_container["storage_max_slots"]
    local temp_items = {}
    for i = 1, max_storage_slots do

        local item_in_slot = exports["em_items"]:get_item_in_slot(storage_items, i)
        if item_in_slot ~= nil then

            local name = item_in_slot.item_name
            if exports["em_items"]:is_item_type_a_weapon(item_in_slot.item_type_id) then
                name = exports["em_items"]:get_item_weapon_model(item_in_slot.item_id)
            end

            table.insert(temp_items, {

                label           = string.upper(item_in_slot.item_name),
                name            = name:gsub(" ", "_"),
                count           = item_in_slot.amount,
                item_id         = item_in_slot.item_id,
                item_type_id    = item_in_slot.item_type_id,
                storage_item_id = item_in_slot.storage_item_id,
                rare            = false,
                type            = "item_standard",
                item_metadata   = item_in_slot.item_metadata,
                canRemove       = true,
                usable          = true,
                limit           = -1,
                slot            = i

            })
        else
            table.insert(temp_items, {
                label           = "",
                name            = "",
                count           = 0,
                item_id         = 0,
                storage_item_id = 0,
                item_type_id    = 0,
                rare            = false,
                type            = "item_standard",
                canRemove       = false,
                usable          = false,
                item_metadata   = nil,
                limit           = -1,
                slot            = i
            })
        end
    end
    return temp_items
end

function loadPlayerInventory()

    left_storage_id = exports["em_fw"]:get_character_storage_id()
    local storage_container = exports["em_fw"]:get_character_storage()

    SendNUIMessage(
        {
            action = "setItems",
            itemList = get_items_from_storage(storage_container)
        }
    )
    
end

local function load_secondary_inventory(storage_id)

    local storage_container = exports["em_fw"]:get_storage(right_storage_id)

    if right_inventory_name == "Drop" and #storage_container["storage_items"] == 0 then

        exports["em_fw"]:set_drop_zone_inactive(right_storage_id)
        TriggerEvent("em_storage:manual_drop_refresh")
        closeInventory()
        right_storage_id = nil
        right_inventory_name = nil
        return

    end

    SendNUIMessage(
    {
        action = "setSecondInventoryItems",
        itemList = get_items_from_storage(storage_container)
    })


end

AddEventHandler("esx_inventoryhud:open_secondary_inventory", function(other_storage_id, name)

    openInventory()
    right_storage_id     = other_storage_id
    right_inventory_name = name
    load_secondary_inventory(right_storage_id)
    SendNUIMessage(
    {
        action = "setInfoText",
        text   = name
    })

end)

AddEventHandler("esx_inventoryhud:open_store", function(store, store_items)

    SendNUIMessage(
        {
            action = "setType",
            type = "shop"
        }
    )
    SendNUIMessage(
        {
            action = "setInfoText",
            text   = store.store_name
        }
    )
    local temp_items = {}
    for i = 1, #store_items do

        local name = store_items[i].item_name
        if exports["em_items"]:is_item_type_a_weapon(store_items[i].item_type_id) then
            name = exports["em_items"]:get_item_weapon_model(store_items[i].item_id)
        end

        table.insert(temp_items, {
            label           = string.upper(store_items[i].item_name),
            name            = name:gsub(" ", "_"),
            count           = -1,
            item_id         = store_items[i].item_id,
            storage_item_id = 0,
            item_type_id    = store_items[i].item_type_id,
            rare            = false,
            type            = "item_standard",
            canRemove       = false,
            usable          = false,
            limit           = -1,
            slot            = i,
            price           = store_items[i].item_price
        })

    end

    SendNUIMessage(
    {
        action   = "setSecondInventoryItems",
        itemList = temp_items
    })
    loadPlayerInventory()
    SendNUIMessage(
        {
            action = "display",
            type = "shop"
        }
    )
    SetNuiFocus(true, true)

    in_store = true

end)

local function reload_inventories()

    loadPlayerInventory()
    if right_storage_id ~= nil then
        load_secondary_inventory(right_storage_id)
    end

end

RegisterNUICallback("MoveItem", function(data, cb)


    if in_store then

        Citizen.Trace(json.encode(data) .. "\n")

    elseif data.inventory_from == "main" and data.inventory_to == "main" then

        local response = exports["em_fw"]:move_item(left_storage_id, data.storage_item_id, left_storage_id, data.item_slot_to, data.item_id, data.amount)
        if not response.response.success then
            exports['swt_notifications']:Negative("Storage", response.response.message, "top", 2000, true)
        end

    elseif data.inventory_from == "main" and data.inventory_to == "other" then

        local response = exports["em_fw"]:move_item(left_storage_id, data.storage_item_id, right_storage_id, data.item_slot_to, data.item_id, data.amount)
        if not response.response.success then
            exports['swt_notifications']:Negative("Storage", response.response.message, "top", 2000, true)
        end
        
    else
        exports['swt_notifications']:Negative("Storage", "Unable to move item", "top", 2000, true)
    end
    reload_inventories()
    cb("ok")

end)


Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            if isInInventory then
                local playerPed = PlayerPedId()
                DisableControlAction(0, 1, true) -- Disable pan
                DisableControlAction(0, 2, true) -- Disable tilt
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 263, true) -- Melee Attack 1
                DisableControlAction(0, Keys["W"], true) -- W
                DisableControlAction(0, Keys["U"], true) -- U
                DisableControlAction(0, Keys["A"], true) -- A
                DisableControlAction(0, 31, true) -- S (fault in Keys table!)
                DisableControlAction(0, 30, true) -- D (fault in Keys table!)

                DisableControlAction(0, Keys["R"], true) -- Reload
                DisableControlAction(0, Keys["SPACE"], true) -- Jump
                DisableControlAction(0, Keys["Q"], true) -- Cover
                DisableControlAction(0, Keys["TAB"], true) -- Select Weapon
                DisableControlAction(0, Keys["F"], true) -- Also 'enter'?

                DisableControlAction(0, Keys["F1"], true) -- Disable phone
                DisableControlAction(0, Keys["F2"], true) -- Inventory
                DisableControlAction(0, Keys["F3"], true) -- Animations
                DisableControlAction(0, Keys["F6"], true) -- Job

                DisableControlAction(0, Keys["V"], true) -- Disable changing view
                DisableControlAction(0, Keys["C"], true) -- Disable looking behind
                DisableControlAction(0, Keys["X"], true) -- Disable clearing animation
                DisableControlAction(2, Keys["P"], true) -- Disable pause screen

                DisableControlAction(0, 59, true) -- Disable steering in vehicle
                DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                DisableControlAction(0, 72, true) -- Disable reversing in vehicle

                DisableControlAction(2, Keys["LEFTCTRL"], true) -- Disable going stealth

                DisableControlAction(0, 47, true) -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 75, true) -- Disable exit vehicle
                DisableControlAction(27, 75, true) -- Disable exit vehicle
            end
        end
    end
)

RegisterNetEvent("esx_inventoryhud:closeInventory")
AddEventHandler(
    "esx_inventoryhud:closeInventory",
    function()
        closeInventory()
    end
)

RegisterNetEvent("esx_inventoryhud:reloadPlayerInventory")
AddEventHandler(
    "esx_inventoryhud:reloadPlayerInventory",
    function()
        if isInInventory then
            loadPlayerInventory()
        end
    end
)
