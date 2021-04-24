
RegisterNetEvent('nfwlock:removeKit')
AddEventHandler('nfwlock:removeKit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('lockpick', 1)
end)

local vehicles = {}

RegisterNetEvent("nfwlock:setVehicleDoorsForEveryone")
AddEventHandler("nfwlock:setVehicleDoorsForEveryone", function(veh, doors, plate)
    local _source = source
    local veh_model = veh[1]
    local veh_doors = veh[2]
    local veh_plate = veh[3]

    if vehicles[veh_plate] then
        return
    end

    local players = GetPlayers()
    for _,player in pairs(players) do
        TriggerClientEvent("nfwlock:setVehicleDoors", player, table.unpack(veh, doors))
    end
    vehicles[veh_plate] = true

end)

RegisterNetEvent("nfw:unlock_doors_for_everyone")
AddEventHandler("nfw:unlock_doors_for_everyone", function(network_veh, plate, force_unlock)

    if not force_unlock then
        if vehicles[plate] then
            return
        end
        
        vehicles[plate] = true
    end

    TriggerClientEvent("nfw:unlock_doors_for_everyone_response", -1, network_veh)    

end)

RegisterNetEvent("nfw:lock_doors_for_everyone")
AddEventHandler("nfw:lock_doors_for_everyone", function(network_veh, plate)

    if vehicles[plate] then
        return
    end
    
    vehicles[plate] = true

    TriggerClientEvent("nfw:lock_doors_for_everyone_response", -1, network_veh)

end)