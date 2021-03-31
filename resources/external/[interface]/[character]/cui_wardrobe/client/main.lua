
local isVisible = false
local isOpening = false
local isLoading = false
local outfits = {}

local function disble_controls_loop()

    while isVisible do
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        Citizen.Wait(5)
    end

end

function setVisible(visible)
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = 'setVisible',
        value = visible
    })
    isVisible = visible

    if isVisible then
        Citizen.CreateThread(disble_controls_loop)
    end

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
        TriggerEvent("cd_drawtextui:temp_hide_text")
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
    TriggerEvent("cd_drawtextui:temp_show_text")
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

exports["em_commands"]:register_command('wardrobe', function(source, args, raw)

    TriggerEvent('cui_wardrobe:open')

end, "(DEV) Open Wardrobe")