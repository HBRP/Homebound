local isVisible = false
local tabletObject = nil
local callBip = nil
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local function open_cad()

    exports["em_fw"]:get_latest_cad_reports_async(function(cad_reports)

        local reports = cad_reports["reports"] or {}
        local warrants = cad_reports["warrants"] or {}

        local officer = exports["em_fw"]:get_character_name()
        local job = ""

        local playerPed = PlayerPedId()
        if not isVisible then
            local dict = "amb@world_human_seat_wall_tablet@female@base"
            RequestAnimDict(dict)
            if tabletObject == nil then
                tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
                AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
            end
            while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
            if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
                TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            end
        else
            DeleteEntity(tabletObject)
            ClearPedTasks(playerPed)
            tabletObject = nil
        end
        if #warrants == 0 then warrants = false end
        if #reports == 0 then reports = false end
        SendNUIMessage({
            type = "recentReportsAndWarrantsLoaded",
            reports = reports,
            warrants = warrants,
            officer = officer,
            department = job
        })
        ToggleGUI()

    end)

end

exports["em_commands"]:register_command("cad", function(source, args, callback)

    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if not isVisible and IsPedInAnyPoliceVehicle(playerPed) and GetEntitySpeed(playerVeh) < 5.0 then
        if GetVehicleNumberPlateText(getVehicleInFront()) then
            --TriggerServerEvent("cad:performVehicleSearchInFront", GetVehicleNumberPlateText(getVehicleInFront()))
        else
            open_cad()
        end
    elseif not IsPedInAnyPoliceVehicle(playerPed) then
        open_cad()
    end
    if DoesEntityExist(playerPed) and IsPedUsingActionMode(playerPed) then -- disable action mode/combat stance when engaged in combat (thing which makes you run around like an idiot when shooting)
        SetPedUsingActionMode(playerPed, -1, -1, 1)
    end

end)

local function get_charge_conversion(charges)

    local conversion = {}
    for i = 1, #charges do

        table.insert(conversion, {

            id = charges[i].cad_charge_id,
            label = charges[i].charge_name,
            amount = charges[i].charge_fine,


        })

    end
    return conversion

end

AddEventHandler("em_fw:character_loaded", function()

    exports["em_fw"]:get_charges_async(function(charges)

        SendNUIMessage({
            type = "offensesAndOfficerLoaded",
            offenses = get_charge_conversion(charges),
            name = exports["em_fw"]:get_character_name()
        })

    end)

end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("cad:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("cad:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("cad:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("cad:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("cad:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("cad:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("cad:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("cad:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("cad:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("cad:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("cad:getWarrants")
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("cad:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("cad:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("cad:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("cad:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("getCalls", function(data, cb)
    TriggerServerEvent("cad:getCalls")
end)

RegisterNUICallback("attachToCall", function(data, cb)
    TriggerServerEvent("cad:attachToCall", data.index)
    if not callBlip then
        callBlip = AddBlipForCoord(data.coords[1], data.coords[2], data.coords[3])
        SetBlipSprite(callBlip, 304)
        SetBlipDisplay(callBlip, 2)
        SetBlipScale(callBlip, 1.2)
        SetBlipColour(callBlip, 29)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("911 Call")
        EndTextCommandSetBlipName(callBlip)
    end
    cb('ok')
end)

RegisterNUICallback("detachFromCall", function(data, cb)
    TriggerServerEvent("cad:detachFromCall", data.index)
    if callBlip then
        RemoveBlip(callBlip)
        callBlip = nil
    end
    cb('ok')
end)

RegisterNUICallback("setCallWaypoint", function(data, cb)
    SetNewWaypoint(data.coords[1], data.coords[2])
    cb('ok')
end)

RegisterNUICallback("editCall", function(data, cb)
    TriggerServerEvent("cad:editCall", data.index, data.details)
    cb('ok')
end)

RegisterNUICallback("deleteCall", function(data, cb)
    TriggerServerEvent("cad:deleteCall", data.index)
    cb('ok')
end)

RegisterNUICallback("deleteCallBlip", function(data, cb)
    if callBlip then
        RemoveBlip(callBlip)
        callBlip = nil
    end
end)

RegisterNUICallback("saveVehicleChanges", function(data, cb)
    TriggerServerEvent("cad:saveVehicleChanges", data)
    cb('ok')
end)

RegisterNetEvent("cad:returnOffenderSearchResults")
AddEventHandler("cad:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("cad:closeModal")
AddEventHandler("cad:closeModal", function()
    SendNUIMessage({
        type = "closeModal"
    })
end)

RegisterNetEvent("cad:returnOffenderDetails")
AddEventHandler("cad:returnOffenderDetails", function(data)
    for i = 1, #data.vehicles do
        data.vehicles[i].model = GetLabelText(GetDisplayNameFromVehicleModel(data.vehicles[i].model))
    end
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("cad:returnOffensesAndOfficer")
AddEventHandler("cad:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("cad:returnReportSearchResults")
AddEventHandler("cad:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("cad:returnVehicleSearchInFront")
AddEventHandler("cad:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("cad:returnVehicleSearchResults")
AddEventHandler("cad:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("cad:returnVehicleDetails")
AddEventHandler("cad:returnVehicleDetails", function(data)
    if type(data.model) == 'number' then
        data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    end
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("cad:returnWarrants")
AddEventHandler("cad:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("cad:completedWarrantAction")
AddEventHandler("cad:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("cad:returnReportDetails")
AddEventHandler("cad:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

RegisterNetEvent("cad:sendNUIMessage")
AddEventHandler("cad:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("cad:sendNotification")
AddEventHandler("cad:sendNotification", function(message)
    SendNUIMessage({
        type = "sendNotification",
        message = message
    })
end)

RegisterNetEvent("cad:getNewCallCoords")
AddEventHandler("cad:getNewCallCoords", function(details, callid)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("cad:newCall", details, callid, coords)
end)

RegisterNetEvent("cad:newCall")
AddEventHandler("cad:newCall", function(details, callid, coords, index)
    local x, y, z = table.unpack(coords)
    local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local location = GetStreetNameFromHashKey(var1)..', '..zones[GetNameOfZone(x, y, z)]
    SendNUIMessage({
        type = "newCall",
        details = details,
        source = callid,
        coords = {x, y, z},
        location = location,
        id = index
    })
end)

RegisterNetEvent("cad:newCallAttach")
AddEventHandler("cad:newCallAttach", function(index, charname)
    SendNUIMessage({
        type = "newCallAttach",
        call = index,
        charname = charname
    })
end)

RegisterNetEvent("cad:newCallDetach")
AddEventHandler("cad:newCallDetach", function(index, charname)
    SendNUIMessage({
        type = "newCallDetach",
        call = index,
        charname = charname
    })
end)

RegisterNetEvent("cad:editCall")
AddEventHandler("cad:editCall", function(index, details)
    SendNUIMessage({
        type = "editCall",
        call = index,
        details = details
    })
end)

RegisterNetEvent("cad:deleteCall")
AddEventHandler("cad:deleteCall", function(index)
    SendNUIMessage({
        type = "deleteCall",
        call = index
    })
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end

function getVehicleInFront()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end
