local PlayerData = {}
pBreaking = false
local Time = 10 * 1000 -- Time for each stage (ms)


local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local anim = "machinic_loop_mechandplayer"
local flags = 49
local finished_jacking = false

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function disableEngine(vehicle)
	Citizen.CreateThread(function()
		while finished_jacking do
			SetVehicleEngineOn(vehicle, false, true, false)
			if not finished_jacking then
				break
			end
			Citizen.Wait(5)
		end
	end)
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value[1] == element then
			return true
		end
	end
	return false
end

local function has_value (tab, val)

	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false

end	

function hotWire(vehicle)

	local player_entity = PlayerPedId()
	disableEngine(vehicle)
	pBreaking = false
	loadAnimDict(animDict)
	ClearPedTasks(player_entity)
	TaskPlayAnim(player_entity, animDict, anim, 3.0, 1.0, 1000 * 30, flags, -1, 0, 0, 0)
	if hotwiring then
		exports["rprogress"]:Custom({
				Async    = false,
				Duration = 1000 * 30,
				Label    = "Hotwiring"
		})
	end
	StopAnimTask(player_entity, animDict, anim, 1.0)
	Citizen.Wait(1000)
	TriggerEvent('EngineToggle:Engine')
	SetVehicleJetEngineOn(vehicle, true)
	RemoveAnimDict(animDict)
	if not Radio then
		SetVehicleRadioEnabled(vehicle, false)
	end
	finished_jacking = true

end

local vehicles = {}; RPWorking = true

RegisterNetEvent('EngineToggle:Engine')
AddEventHandler('EngineToggle:Engine', function()
	local veh
	local StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
	Citizen.Wait(1500)
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then 
		if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
			vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
			if vehicles[StateIndex][2] then
				exports['t-notify']:Alert({style = "success", message = 'Engine turned on!'})
			end
		end 
	end 
end)

local function check_for_car()

	Citizen.Wait(100)
	local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
	if not DoesEntityExist(veh) then
		return
	end

	if exports["em_vehicles"]:is_vehicle_owned_by_group(veh) or exports["em_vehicles"]:is_vehicle_player_owned(veh) then
		return
	end

	local plate = GetVehicleNumberPlateText(veh)
	local jacked = true
	exports["em_fw"]:trigger_server_callback("nfw_locksystem:is_car_jacked", function(result)

		jacked = result

	end, plate)

	if jacked then
		return
	end

	finished_jacking = false
	-- gets vehicle player is trying to enter and its lock status
	local lock = GetVehicleDoorLockStatus(veh)
		
	-- Get the conductor door angle, open if value > 0.0
	local doorAngle = GetVehicleDoorAngleRatio(veh, 0)

	-- normalizes chance
	if cfg.chance > 100 then
		cfg.chance = 100
	elseif cfg.chance < 0 then
		cfg.chance = 0
	end

	-- check if got lucky
	local lucky = (math.random(100) < cfg.chance)
	if doorAngle > 0.0 then
		lucky = true
	end

	local pedd = GetPedInVehicleSeat(veh, -1)

	if IsPedAPlayer(pedd) then
		return
	end

	local vehicle_class = GetVehicleClass(veh)
	if vehicle_class == 13 or vehicle_class == 8 or vehicle_class == 9 then
		SetVehicleDoorsLocked(veh, 1)
		TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
		return
	end

	if not IsVehicleWindowIntact(veh, 0) then
		SetVehicleDoorsLocked(veh, 7)
		TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
		Citizen.Wait(2500)
		return
	end

	if pedd ~= 0 then

		if math.random(100) > 75 then
			local vehicle_model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
			SetVehicleDoorsLocked(veh, 2)
			finished_jacking = true
			TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
			TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "GTA", string.format("Help someone is stealing my %s with plate %s", GetLabelText(vehicle_model), plate), 2)
		else
			SetVehicleDoorsLocked(veh, 2)
			TriggerServerEvent("nfw:lock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
			TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "GTA", string.format("Help someone just tried to steal my car!"), 2)

			SetVehicleCanBeUsedByFleeingPeds(veh, true)
			SetPedFleeAttributes(pedd, 0, true)
			--TaskReactAndFleePed(pedd, PlayerPedId())
		end
		return

	end

	if lucky then
		SetVehicleDoorsLocked(veh, 1)
		TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
		Citizen.Wait(2500)
		hotWire(veh)
	else
		SetVehicleDoorsLocked(veh, 2)
		TriggerServerEvent("nfw:lock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
	end
end

RegisterCommand('getting_in_car', check_for_car, false)
RegisterKeyMapping('getting_in_car', 'getting_in_car', 'keyboard', 'F')


RegisterNetEvent("nfw:unlock_doors_for_everyone_response")
AddEventHandler("nfw:unlock_doors_for_everyone_response", function(network_veh)

	local veh = NetworkGetEntityFromNetworkId(network_veh)
	disableEngine(veh)

	SetVehicleEngineOn(veh, false, true, true)
	SetVehicleNeedsToBeHotwired(veh, false)

	SetVehicleDoorsLocked(veh, 1)

end)

RegisterNetEvent("nfw:lock_doors_for_everyone_response")
AddEventHandler("nfw:lock_doors_for_everyone_response", function(network_veh)

	local veh = NetworkGetEntityFromNetworkId(network_veh)
	disableEngine(veh)

	SetVehicleEngineOn(veh, false, true, true)
	SetVehicleNeedsToBeHotwired(veh, false)

	SetVehicleDoorsLocked(veh, 7)

end)

exports["em_items"]:register_item_use("lockpick", function()

	local hit, coords, entity = table.unpack(exports["em_fw"]:ray_cast_game_play_camera(10.0))

	if not hit then
		return
	end

	if entity ~= 0 and GetEntityType(entity) ~=2 then
		return
	end

	exports["rprogress"]:Custom({
		Async    = true,
		Duration = 1000 * 10,
		Label    = "Lockpicking vehicle"
	})

	exports["em_animations"]:play_animation_sync('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 10000, 16)
	SetVehicleDoorsLocked(entity, 1)
	SetVehicleDoorsLockedForAllPlayers(entity, false)
	ClearPedTasks(PlayerPedId())

	if math.random(100) > 70 then
			local vehicle_model = GetDisplayNameFromVehicleModel(GetEntityModel(entity))
			local plate = GetVehicleNumberPlateText(entity)
			SetVehicleAlarm(entity, true)
			SetVehicleAlarmTimeLeft(entity, 30 * 1000)
			TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "GTA", string.format("Car alarm set off for %s with plate %s", GetLabelText(vehicle_model), plate), 2)
	end

	Citizen.Wait(100)
	TaskEnterVehicle(PlayerPedId(), entity, 10.0, -1, 1.0, 1, 0)
	SetVehicleEngineOn(entity, false, true, true)
	SetVehicleNeedsToBeHotwired(entity, true)

end)