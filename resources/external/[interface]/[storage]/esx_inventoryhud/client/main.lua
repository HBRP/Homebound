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

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
                openInventory()
            end
        end
    end
)

function openInventory()
    loadPlayerInventory()
    isInInventory = true
    SendNUIMessage(
        {
            action = "display",
            type = "normal"
        }
    )
    SetNuiFocus(true, true)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    SetNuiFocus(false, false)
end

RegisterNUICallback(
    "NUIFocusOff",
    function(data, cb)
        closeInventory()
        TriggerEvent("esx_inventoryhud:onClosedInventory", data.type)
        cb("ok")
    end
)

RegisterNUICallback(
    "GetNearPlayers",
    function(data, cb)
        local playerPed = PlayerPedId()
        local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
        local foundPlayers = false
        local elements = {}

        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                foundPlayers = true

                table.insert(
                    elements,
                    {
                        label = GetPlayerName(players[i]),
                        player = GetPlayerServerId(players[i])
                    }
                )
            end
        end

        if not foundPlayers then
            exports.pNotify:SendNotification(
                {
                    text = _U("players_nearby"),
                    type = "error",
                    timeout = 3000,
                    layout = "bottomCenter",
                    queue = "inventoryhud"
                }
            )
        else
            SendNUIMessage(
                {
                    action = "nearPlayers",
                    foundAny = foundPlayers,
                    players = elements,
                    item = data.item
                }
            )
        end

        cb("ok")
    end
)

RegisterNUICallback("UseItem", function(data, cb)

    exports["em_items"]:use_item(data["item"].item_id, data["item"].item_type_id, data["item"].storage_item_id)
    loadPlayerInventory()
    cb("ok")

end)

RegisterNUICallback("DropItem", function(data, cb)

    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        --TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
    end

    Wait(250)
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

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end

    return false
end

local left_storage_id  = nil
local right_storage_id = nil

function loadPlayerInventory()

    left_storage_id         = exports["em_fw"]:get_character_storage_id()
    local inventory         = exports["em_fw"]:get_storage(left_storage_id)
    local storage_items     = inventory["storage_items"]
    local max_storage_slots = inventory["storage_max_slots"]
    items = {}
    for i = 1, max_storage_slots do

        local item_in_slot = exports["em_items"]:get_item_in_slot(storage_items, i)
        if item_in_slot ~= nil then

            local name = item_in_slot.item_name
            if exports["em_items"]:is_item_type_a_weapon(item_in_slot.item_type_id) then
                name = exports["em_items"]:get_item_weapon_model(item_in_slot.item_id)
            end

            table.insert(items, {

                label           = string.upper(item_in_slot.item_name),
                name            = name,
                count           = item_in_slot.amount,
                item_id         = item_in_slot.item_id,
                item_type_id    = item_in_slot.item_type_id,
                storage_item_id = item_in_slot.storage_item_id,
                rare            = false,
                type            = "item_standard",
                canRemove       = true,
                usable          = true,
                limit           = -1,
                slot            = i

            })
        else
            table.insert(items, {
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
                limit           = -1,
                slot            = i
            })
        end

    end
    SendNUIMessage(
        {
            action = "setItems",
            itemList = items
        }
    )
    
end

RegisterNUICallback("MoveItem", function(data, cb)

    if data.inventory_from == "main" and data.inventory_to == "main" then
        exports["em_fw"]:move_item(left_storage_id, data.storage_item_id, left_storage_id, data.item_slot_to, data.item_id, data.amount)
    else
        Citizen.Trace("Unable to move\n")
    end
    loadPlayerInventory()
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
