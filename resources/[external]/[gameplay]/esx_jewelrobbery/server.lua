local joblist = {}
local resettime = nil
local policeclosed = false


--[[
RegisterServerEvent('esx_JewelRobbery:closestore')
AddEventHandler('esx_JewelRobbery:closestore', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ispolice = false
	for i, v in pairs(Config.PoliceJobs) do
		if xPlayer.job.name == v then
			ispolice = true
			break
		end
	end
    if ispolice and resettime ~= nil then
        TriggerClientEvent('esx_JewelRobbery:policeclosure', -1)
        policeclosed = true
    elseif ispolice and resettime == nil then
        TriggerClientEvent('esx:showNotification', _source, 'Store does not appear to be damaged - unable to force closed!')          
    else
        TriggerClientEvent('esx:showNotification', _source, 'Only Law enforcment or Vangelico staff can decide if store is closed!')           
    end
end)
]]

RegisterServerEvent('esx_JewelRobbery:playsound')
AddEventHandler('esx_JewelRobbery:playsound', function(x,y,z, soundtype)
    TriggerClientEvent('esx_JewelRobbery:playsound', -1, x, y, z, soundtype)
end)

local function award_items(source)

    local randomitem = math.random(1,100)
    for i, v in pairs(Config.ItemDrops) do 
        if randomitem <= v.chance then
            randomamount = math.random(1, v.max)
            local response = exports["em_items"]:give_item_by_name(source, v.name, randomamount)

            if response.result.success then
                TriggerClientEvent('t-notify:client:Alert', source, {style = "info", message = string.format("Obtained %d %s", randomamount, v.name)})
            else
                TriggerClientEvent('t-notify:client:Alert', source, {style = "error", message = response.result.message})
                break
            end
        end
    end

end

local function reset_timer()
    Citizen.CreateThread(function()
        if resettime == nil then
            totaltime = Config.ResetTime * 60
            resettime = os.time() + totaltime

            while os.time() < resettime do
                Citizen.Wait(2350)
            end

            for i, v in pairs(Config.CaseLocations) do
                v.Broken = false
            end
            TriggerClientEvent('esx_JewelRobbery:resetcases', -1, Config.CaseLocations)
            resettime = nil
            policeclosed = false
        end
    end)
end

RegisterServerEvent('esx_JewelRobbery:setcase')
AddEventHandler('esx_JewelRobbery:setcase', function(casenumber, switch)

    if Config.CaseLocations[casenumber].Broken then
        return
    end

    Config.CaseLocations[casenumber].Broken = true
    reset_timer()
    TriggerClientEvent('esx_JewelRobbery:setcase', -1, casenumber, true)
    award_items(source)

end)

RegisterServerEvent('esx_JewelRobbery:policenotify')
AddEventHandler('esx_JewelRobbery:policenotify', function()
    TriggerClientEvent('esx_JewelRobbery:policenotify', -1)    
end)

RegisterServerEvent('esx_JewelRobbery:loadconfig')
AddEventHandler('esx_JewelRobbery:loadconfig', function()

    TriggerClientEvent('esx_JewelRobbery:loadconfig', source, Config.CaseLocations)
    --if policeclosed then
    --    TriggerClientEvent('esx_JewelRobbery:policeclosure', _source)
    --end

end)
