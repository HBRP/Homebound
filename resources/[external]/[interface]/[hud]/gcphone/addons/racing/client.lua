--[[
    Core
--]]

racing = false

currentRaces = {}
joinedRaces = {}

SetBlips = {}
checkpointMarkers = {}

--[[
    NUI
--]]

RegisterNUICallback('getRaces', function (data, cb)

    exports["em_dal"]:trigger_server_callback("gcphone:getRaces", function(races)
        cb(races)
    end)

end)

RegisterNUICallback('createRace', function (data, cb)

    exports["em_dal"]:trigger_server_callback("gcphone:createRace", function(res)
        cb(res)
    end, data)

end)

RegisterNUICallback('joinRace', function (data, cb)

    exports["em_dal"]:trigger_server_callback("gcphone:joinRace", function(res)
        cb(res)
    end, data)

end)


RegisterNUICallback('racingSetGPS', function (data, cb)
    if racing then
        local raceID = tonumber(data.raceID)
        SetNewWaypoint(currentRaces[raceID].checkpoints[1].coords.x, currentRaces[raceID].checkpoints[1].coords.y)
        cb(true)
    end
    cb(false)
end)

RegisterNUICallback('racingStartRace', function (data, cb)

    exports["em_dal"]:trigger_server_callback("gcphone:startRace", function(res)
        cb(res)
    end, data)
    cb()

end)


-- update Races
RegisterNetEvent('gcphone:racing:setRaces')
AddEventHandler('gcphone:racing:setRaces', function (races)
    currentRaces = races 
end)
RegisterNetEvent('gcphone:racing:NUIsetRaces')
AddEventHandler('gcphone:racing:NUIsetRaces', function ()
    SendNUIMessage({event = 'updateRacingRaces'})    
end)

--[[
    Events
]]

-- Update JoinedRaces
RegisterNetEvent('gcphone:racing:updateJoinedRaces')
AddEventHandler('gcphone:racing:updateJoinedRaces', function (eventID, value)
    local raceID = tonumber(eventID)
    joinedRaces[raceID] = true
end)

-- Update Client Race
RegisterNetEvent('gcphone:racing:updateCurrentRace')
AddEventHandler('gcphone:racing:updateCurrentRace', function (eventID)
    racing = true
    print("EVENT "..eventID)
    local raceID = tonumber(eventID)
    checkpoints = currentRaces[raceID].checkpoints
    for index, checkpoint in pairs(checkpoints) do
        local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
        local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
        local key = #SetBlips+1
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipAsFriendly(checkpoint.blip, true)
        SetBlipSprite(checkpoint.blip, 1)
        ShowNumberOnBlip(checkpoint.blip, index)
        BeginTextCommandSetBlipName("STRING");
        AddTextComponentString(tostring("Checkpoint " ..index))
        EndTextCommandSetBlipName(checkpoint.blip)
        SetBlips[key] = checkpoint.blip
    end
end)

RegisterNetEvent('gcphone:racing:startRace')
AddEventHandler('gcphone:racing:startRace', function (eventID)
    startRace(eventID)
end)

--[[
    Functions
]]

function Draw2DText(x, y, text, scale)
    -- Draw text on screen
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


function startRace(eventID)
    local raceID = tonumber(eventID)
    if joinedRaces[raceID] then
        local myLap = 0
        local mycheckpoint = 1
        local ped = GetPlayerPed(-1)

        local plyCoords = GetEntityCoords(ped)

        SetBlipColour(SetBlips[1], 3)
        SetBlipScale(SetBlips[1], 1.6)

        exports["rprogress"]:Custom({
            Async    = true,
            Duration = 3000,
            Label = "Starting race"
        })
        PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        Citizen.Wait(1000)
        PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        Citizen.Wait(1000)
        PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        Citizen.Wait(1000)
        PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        SendNUIMessage({event = 'updateRacingStatus', data = 1})

        while myLap < tonumber(currentRaces[raceID].Laps) and racing do
            Citizen.Wait(1)
            local plyCoords = GetEntityCoords(ped)
        
            if
                (Vdist(
                    currentRaces[raceID].checkpoints[mycheckpoint]["coords"]["x"],
                    currentRaces[raceID].checkpoints[mycheckpoint]["coords"]["y"],
                    currentRaces[raceID].checkpoints[mycheckpoint]["coords"]["z"],
                    plyCoords.x,
                    plyCoords.y,
                    plyCoords.z
                )) < 30.0
            then
                SetBlipColour(SetBlips[mycheckpoint], 3)
                SetBlipScale(SetBlips[mycheckpoint], 1.0)
        
                PlaySound(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
                mycheckpoint = mycheckpoint + 1
        
                SetBlipColour(SetBlips[mycheckpoint], 2)
                SetBlipScale(SetBlips[mycheckpoint], 1.6)
                SetBlipAsShortRange(SetBlips[mycheckpoint - 1], true)
                SetBlipAsShortRange(SetBlips[mycheckpoint], false)
        
                if mycheckpoint > #currentRaces[raceID].checkpoints then
                    mycheckpoint = 1
                end
        
                SetNewWaypoint(
                    currentRaces[raceID].checkpoints[mycheckpoint]["coords"]["x"],
                    currentRaces[raceID].checkpoints[mycheckpoint]["coords"]["y"]
                )
        
                if not sprint and mycheckpoint == 1 then
                    SetBlipColour(SetBlips[1], 2)
                    SetBlipScale(SetBlips[1], 1.6)
                end
        
                if mycheckpoint == #currentRaces[raceID].checkpoints then
                    myLap = myLap + 1
        
                    -- Uncomment these lines to make the checkpoints re-draw on each lap
                    --ClearBlips()
                    --RemoveCheckpoints()
                    --LoadMapBlips(map)
                    SetBlipColour(SetBlips[1], 3)
                    SetBlipScale(SetBlips[1], 1.0)
                    SetBlipColour(SetBlips[2], 2)
                    SetBlipScale(SetBlips[2], 1.6)
                end
                print(mycheckpoint)
                SendNUIMessage({event = 'updateRacingCurrentLap', data = myLap})
                SendNUIMessage({event = 'updateRacingCurrentCheckpoint', data = mycheckpoint})
            end
        end
        
        PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
        --ESX.ShowNotification("¡Has terminado!")
        Citizen.CreateThread(function()

            local end_time = GetGameTimer() + 1000
            while GetGameTimer() < end_time do
                Citizen.Wait(5)
                Draw2DText(0.5, 0.5, 'Finished!', 0.25)
            end

        end)
        SendNUIMessage({event = 'updateRacingStatus', data = 0})
        Wait(10000)
        SendNUIMessage({event = 'updateRacingActive', data = false})
        racing = false
        ClearBlips()
        RemoveCheckpoints()
    end
end

function ClearBlips()
    for i = 1, #SetBlips do
        RemoveBlip(SetBlips[i])
    end
    SetBlips = {}
end

function RemoveCheckpoints()
    for i = 1, #checkpointMarkers do
        SetEntityAsNoLongerNeeded(checkpointMarkers[i].left)
        DeleteObject(checkpointMarkers[i].left)
        SetEntityAsNoLongerNeeded(checkpointMarkers[i].right)
        DeleteObject(checkpointMarkers[i].right)
        checkpointMarkers[i] = nil
    end
end
  