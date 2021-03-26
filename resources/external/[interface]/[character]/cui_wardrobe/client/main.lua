
local isVisible = false
local isOpening = false
local isLoading = false
local outfits = {}

function setVisible(visible)
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = 'setVisible',
        value = visible
    })
    isVisible = visible

    if Config.HideMinimapOnOpen then
        DisplayRadar(not visible)
    end
end

function refreshUI()

    local html = ''
    local emptyName = 'Empty slot'
    local gender = exports["em_fw"]:get_character_gender()
    for i = 1, Config.SlotsNumber do
        if outfits[i] ~= nil then
            html = html .. '<div class="slot" data-number="' .. i .. '" data-gender="' .. gender .. '"><span class="slot-text">' .. outfits[i].outfit_name ..'</span><div class="controls"><button class="edit"></button><button class="clear"></button></div></div>'
        else
            -- empty slot
            html = html .. '<div class="slot empty" data-number="' .. i .. '"><span class="slot-text">' .. emptyName ..'</span><div class="controls"><button class="edit"></button></div></div>'
        end
    end

    SendNUIMessage({
        action = 'refresh',
        html = html,
        model = gender
    })
end

RegisterNetEvent('cui_wardrobe:open')
AddEventHandler('cui_wardrobe:open', function()
    if not isOpening then
        isOpening = true
        RequestStreamedTextureDict('shared')

        outfits = exports["em_fw"]:get_all_outfit_meta_data()
        if outfits == nil then
            outfits = {}
        end

        while not HasStreamedTextureDictLoaded('shared') do
            Wait(100)
        end

        refreshUI()
        setVisible(true)
        isOpening = false
    end
end)

RegisterNetEvent('cui_wardrobe:close')
AddEventHandler('cui_wardrobe:close', function()
    SetStreamedTextureDictAsNoLongerNeeded('shared')
    setVisible(false)
end)

RegisterNUICallback('close', function(data, cb)
    TriggerEvent('cui_wardrobe:close')
end)

RegisterNUICallback('save', function(data, cb)

    local ped_appearance = exports["fivem-appearance"]:getPedAppearance(PlayerPedId())
    local outfit = {
        ped_components = ped_appearance["components"],
        props = ped_appearance["props"]
    }

    if outfits[tonumber(data['slot'])] == nil then

        exports["em_fw"]:create_outfit(data['name'], json.encode(outfit))
        local active_outfit = exports["em_fw"]:get_active_outfit()

        outfits[tonumber(data['slot'])] = {}
        outfits[tonumber(data['slot'])].outfit_name         = active_outfit["outfit_name"]
        outfits[tonumber(data['slot'])].character_outfit_id = active_outfit["character_outfit_id"]

    else

        exports["em_fw"]:update_outfit(outfits[tonumber(data['slot'])].character_outfit_id, data['name'], json.encode(outfit))

    end

    
    SendNUIMessage({
        action = 'completeEdit',
        slot = tonumber(data['slot']),
        name = data['name']
    })

end)

RegisterNUICallback('clear', function(data, cb)

    exports["em_fw"]:delete_outfit(outfits[tonumber(data['slot'])].character_outfit_id)
    SendNUIMessage({
        action = 'completeDeletion',
        slot = tonumber(data['slot'])
    })

end)

RegisterNUICallback('load', function(data, cb)
    if not isLoading then
        local player_data = exports["em_fw"]:get_outfit(outfits[tonumber(data['slot'])].character_outfit_id)
        local outfit_data = json.decode(player_data['outfit'])
        local outfit      = json.decode(outfit_data)
        exports["fivem-appearance"]:setPedComponents(PlayerPedId(), outfit.ped_components)
        exports["fivem-appearance"]:setPedProps(PlayerPedId(), outfit.props)
    end
end)

RegisterNUICallback('playSound', function(data, cb)
    local sound = data['sound']
    if sound == 'changeoutfit' then
        PlaySoundFrontend(-1, 'Continue_Appears', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    elseif sound == 'smallbuttonclick' then
        PlaySoundFrontend( -1, 'HACKING_MOVE_CURSOR', 0, 1 )
    elseif sound == 'panelbuttonclick' then
        PlaySoundFrontend(-1, 'Reset_Prop_Position', 'DLC_Dmod_Prop_Editor_Sounds', 0)
    elseif sound == 'error' then
        PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
    end
end)

-- Map Locations
if not Config.UseAnywhere then
    local closestCoords = nil
    local distToClosest = 1000.0
    local inMarkerRange = false

    function DisplayTooltip(suffix)
        SetTextComponentFormat('STRING')
        AddTextComponentString('Press ~INPUT_PICKUP~ to ' .. suffix)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end

    function UpdateClosestLocation(locations)
        local pedPosition = GetEntityCoords(PlayerPedId())
        for i = 1, #locations do
            local loc = locations[i]
            local distance = GetDistanceBetweenCoords(pedPosition.x, pedPosition.y, pedPosition.z, loc[1], loc[2], loc[3], true)
            if (distToClosest == nil or closestCoords == nil) or (distance < distToClosest) or (closestCoords == loc) then
                distToClosest = distance
                closestCoords = vector3(loc[1], loc[2], loc[3])
            end

            if (distToClosest < 20.0) and (distToClosest > 1.0) then
                inMarkerRange = true
            else
                inMarkerRange = false
            end
        end
    end

    local waitTime = 2000
    Citizen.CreateThread(function()
        while true do
            if distToClosest > 500.0 then
                waitTime = 5000
            elseif distToClosest > 100.0 then
                waitTime = 2000
            else
                waitTime = 500
            end

            UpdateClosestLocation(Config.Locations)
            Citizen.Wait(waitTime)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if inMarkerRange then
                DrawMarker(
                    20,
                    closestCoords.x, closestCoords.y, closestCoords.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    1.0, 1.0, 1.0,
                    45, 110, 185, 128,
                    true,   -- move up and down
                    false,
                    2,
                    true,  -- rotate
                    nil,
                    nil,
                    false
                )
            end

            if distToClosest < 1.0 and (not isVisible) then
                DisplayTooltip('use wardrobe.')
                if IsControlJustPressed(1, 38) then
                    TriggerEvent('cui_wardrobe:open')
                end
            end

            Citizen.Wait(0)
        end
    end)

    if Config.DisplayBlips then
        Citizen.CreateThread(function()
            for k, v in ipairs(Config.Locations) do
                local blip = AddBlipForCoord(v)
                SetBlipSprite(blip, 366)
                SetBlipColour(blip, 84)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('Wardrobe')
                EndTextCommandSetBlipName(blip)
            end
        end)
    end
end

-- Default controls
Citizen.CreateThread(function()
    while true do
        if isVisible then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
        end
        Citizen.Wait(0)
    end
end)

exports["em_commands"]:register_command('wardrobe', function(source, args, raw)

    TriggerEvent('cui_wardrobe:open')

end, "(DEV) Open Wardrobe")