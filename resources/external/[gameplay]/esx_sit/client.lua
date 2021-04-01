local debugProps, sitting, lastPos, currentSitCoords, currentScenario = {}
local disableControls = false
local currentObj = nil

local function ped_using_scenario_loop()

	local playerPed = PlayerPedId()
	while sitting do

		Citizen.Wait(5)
		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup()
		end
	end

end

exports["em_commands"]:register_command_no_perms("sit", function(source, args, raw_command)

	if not IsPedOnFoot(PlayerPedId()) then
		return
	end

	if sitting then
		wakeup()
	else
		local object, distance = GetNearChair()
		if distance and distance < 1.4 then
			local hash = GetEntityModel(object)
			for k,v in pairs(Config.Sitable) do
				if GetHashKey(k) == hash then
					sit(object, k, v)
					break
				end
			end
		end
	end

end, "Sit on nearby chair")

function GetNearChair()
	local object, distance
	local coords = GetEntityCoords(GetPlayerPed(-1))
	for i = 1, #Config.Interactables do
		object = GetClosestObjectOfType(coords, 3.0, GetHashKey(Config.Interactables[i]), false, false, false)
		distance = #(coords - GetEntityCoords(object))
		if distance < 1.6 then
			return object, distance
		end
	end
	return nil, nil
end

function wakeup()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(GetPlayerPed(-1))

	TaskStartScenarioAtPosition(playerPed, currentScenario, 0.0, 0.0, 0.0, 180.0, 2, true, false)
	while IsPedUsingScenario(GetPlayerPed(-1), currentScenario) do
		Wait(100)
	end
	ClearPedTasks(playerPed)

	FreezeEntityPosition(playerPed, false)
	FreezeEntityPosition(currentObj, false)

	TriggerServerEvent('esx_sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
	sitting = false
	disableControls = false
end

function sit(object, modelName, data)
	-- Fix for sit on chairs behind walls
	if not HasEntityClearLosToEntity(GetPlayerPed(-1), object, 17) then
		return
	end

	disableControls = true
	currentObj = object
	FreezeEntityPosition(object, true)

	PlaceObjectOnGroundProperly(object)
	local pos = GetEntityCoords(object)
	local playerPos = GetEntityCoords(GetPlayerPed(-1))
	local objectCoords = pos.x .. pos.y .. pos.z

	exports["em_fw"]:trigger_server_callback('esx_sit:getPlace', function(occupied)
		if occupied then
			exports['swt_notifications']:Negative("Sit Chair", 'Chair already occupied', "top", 2000, true)
		else
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('esx_sit:takePlace', objectCoords)
			
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, false)

			Citizen.Wait(2500)
			if GetEntitySpeed(GetPlayerPed(-1)) > 0 then
				ClearPedTasks(GetPlayerPed(-1))
				TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z + (playerPos.z - pos.z)/2, GetEntityHeading(object) + 180.0, 0, true, true)
			end

			sitting = true
			Citizen.CreateThread(ped_using_scenario_loop)
		end
	end, objectCoords)
end