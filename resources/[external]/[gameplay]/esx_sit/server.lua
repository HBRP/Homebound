local seatsTaken = {}

RegisterNetEvent('esx_sit:takePlace')
AddEventHandler('esx_sit:takePlace', function(objectCoords)
	seatsTaken[objectCoords] = true
end)

RegisterNetEvent('esx_sit:leavePlace')
AddEventHandler('esx_sit:leavePlace', function(objectCoords)
	if seatsTaken[objectCoords] then
		seatsTaken[objectCoords] = nil
	end
end)

exports["em_dal"]:register_server_callback('esx_sit:getPlace', function(source, callback, objectCoords)
    callback(seatsTaken[objectCoords])
end)