

function catch(what)
    return what[1]
 end
 
function try(what)
    status, result = pcall(what[1])
    if not status then
        what[2](result)
    end
    return result
end

local races = {}
local tracks = {}
local raceInfo = {}
local playerInfo = {}

--[[
    NUI CALLBACKS
--]]

exports["em_dal"]:register_server_callback("gcphone:getRaces", function(source, callback)

    local data = {}
    data.code = true
    data.races = races
    data.tracks = tracks
    if playerInfo[source] ~= nil then
        data.userInfo = playerInfo[source]
    end
    callback(data)

end)

exports["em_dal"]:register_server_callback("gcphone:startRace", function(source, callback, data)

    TriggerClientEvent('gcphone:racing:startRace', -1, data.raceID)
    callback(true)

end)

exports["em_dal"]:register_server_callback("gcphone:createRace", function(source, callback, data)

    local alias = data.raceInfo.yourAlias
    local raceID = #races+1
    race = {}
    race.raceID = #races+1
    race.trackID = data.raceInfo.trackID
    race.eventName = data.raceInfo.eventName
    race.owner = source
    race.status = 0
    race.Laps = data.raceInfo.Laps
    race.money = data.raceInfo.money
    race.CST = data.raceInfo.CST
    race.reverse = data.raceInfo.reverse
    race.showPosition = data.raceInfo.showPosition
    race.sendNotification = data.raceInfo.sendNotification
    race.checkpoints = tracks[race.trackID].checkpoints
    race.checkpointsCount = #tracks[race.trackID].checkpoints
    race.players = {}
    table.insert(races, race)
    TriggerClientEvent('gcphone:racing:setRaces', -1, races)
    TriggerClientEvent('gcphone:racing:updateCurrentRace', source, raceID)
    TriggerClientEvent('gcphone:racing:updateJoinedRaces', source, raceID, true)
    TriggerClientEvent('gcphone:racing:NUIsetRaces', -1)
    local data = {}
    data.success = true
    data.eventID = raceID
    data.alias = alias
    callback(data)

end)


exports["em_dal"]:register_server_callback("gcphone:joinRace", function(source, callback, data)
    local raceID = tonumber(data.raceID)
    if races[data.raceID] then
        playerInfo = {}
        playerInfo.id = source
        playerInfo.alias = data.yourAlias
        playerInfo.checkpoint = 0
        playerInfo.position = 0
        local index = #races[data.raceID].players+1
        races[data.raceID].players[index] = playerInfo
        TriggerClientEvent('gcphone:racing:setRaces', -1, races)
        TriggerClientEvent('gcphone:racing:NUIsetRaces', -1)
        TriggerClientEvent('gcphone:racing:updateCurrentRace', source, raceID)
        TriggerClientEvent('gcphone:racing:updateJoinedRaces', source, raceID, true)
        local response = {}
        response.success = true
        response.eventID = data.raceID
        response.playerIndex = index
        callback(response)
    else
        callback(false)
    end
end)

Citizen.CreateThread(function()

    Citizen.Wait(0)
    exports["em_dal"]:phone_get_races(0, function(races)

        for i = 1, #races do

            races[i].id     = races[i].racing_track_id
            races[i].type   = races[i].race_type
            races[i].name   = races[i].race_name

        end
        tracks = races

    end)

end)