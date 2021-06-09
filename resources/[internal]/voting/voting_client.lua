local ESX = nil
local voting_options = nil

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local function get_character_id()

end

local function get_steam_id()

end

local function get_elections(voting_options)

    local temp_options = {}

    for i = 1, #voting_options do

        local unique_option = true
        for j = 1, #temp_options do
            if voting_options[i].voting_id == temp_options[j].voting_id then
                unique_option = false
            end
        end
        if unique_option then
            table.insert(temp_options, {
                label     = ('%s'):format(voting_options[i].voting_name),
                voting_id = voting_options[i].voting_id
            })
        end

    end

    return temp_options

end

local function get_election_options(voting_id, voting_options)

    local options = {}
    for i = 1, #voting_options do
        
        if voting_options[i].voting_id == voting_id then
            table.insert(options, {
                label = ('%s'):format(voting_options[i].voting_option),
                voting_id = voting_id,
                voting_option_id = voting_options[i].voting_option_id
            })
        end

    end
    return options

end

local function show_election_options(election_label, voting_id, voting_options)

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'voting', {
        title    = election_label,
        align    = 'top-left',
        elements = get_election_options(voting_id, voting_options)
    }, function(data, menu)
        menu.close()
        TriggerServerEvent("voting_cast_ballot", data.current.voting_id, data.current.voting_option_id)
    end, function(data, menu)
        menu.close()
    end)

end

RegisterNetEvent('voting_options_response')
AddEventHandler('voting_options_response', function(voting_options)

    if voting_options == nil or #voting_options == 0 then
        exports["mythic_notify"]:SendAlert('inform', "There is nothing to vote on.", 5000)
        return
    end
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'voting', {
        title    = 'Vote!',
        align    = 'top-left',
        elements = get_elections(voting_options)
    }, function(data, menu)
        menu.close()
        show_election_options(data.current.label, data.current.voting_id, voting_options)
    end, function(data, menu)
        menu.close()
    end)

end)

--[[

RegisterCommand('showelection', function()
    TriggerServerEvent("voting_get_voting_options")
end, false)

]]

local voting_location = {x = 236.33, y = -407.93, z = 47.1}

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(5)
        local distance = GetDistanceBetweenCoords(voting_location.x, voting_location.y, voting_location.z, GetEntityCoords(PlayerPedId()), true)
        if distance < 3.0 and IsControlJustPressed(0, 38) then
            TriggerServerEvent("voting_get_voting_options")
            Citizen.Wait(500)
        elseif distance < 15.0 then
            DrawMarker(27, voting_location.x, voting_location.y, voting_location.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 1.0,1.0,1.0, 255,255,255,255, false, false, 0, false, nil, nil, false)
        end
    end

end)