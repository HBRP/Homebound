local PlayerData = {}
local Time = 10 * 1000 -- Time for each stage (ms)

local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local anim = "machinic_loop_mechandplayer"
local flags = 49

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

function hotWire(vehicle)

	local player_entity = PlayerPedId()
	local finished_jacking = false

	loadAnimDict(animDict)
	ClearPedTasks(player_entity)
	TaskPlayAnim(player_entity, animDict, anim, 3.0, 1.0, 1000 * 30, flags, -1, 0, 0, 0)

	Citizen.CreateThread(function()

		while GetVehiclePedIsIn(PlayerPedId(), false) == vehicle and not finished_jacking do
			Citizen.Wait(5)
		end
		StopAnimTask(player_entity, animDict, anim, 1.0)
		Citizen.Wait(1000)
		if finished_jacking then
			SetVehicleEngineOn(vehicle, true, false, true)
			SetVehicleRadioEnabled(vehicle, false)
		end
		RemoveAnimDict(animDict)
		exports["rprogress"]:Stop()

	end)

	exports["rprogress"]:Custom({
			Async    = false,
			Duration = 1000 * 30,
			Label    = "Hotwiring"
	})

	finished_jacking = true

end

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

	local lock = GetVehicleDoorLockStatus(veh)
		
	local doorAngle = GetVehicleDoorAngleRatio(veh, 0)

	if cfg.chance > 100 then
		cfg.chance = 100
	elseif cfg.chance < 0 then
		cfg.chance = 0
	end

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
			TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
			TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "GTA", string.format("Help someone is stealing my %s with plate %s", GetLabelText(vehicle_model), plate), 2)
			return
		else
			SetVehicleDoorsLocked(veh, 2)
			TriggerServerEvent("nfw:lock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
			TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "GTA", string.format("Help someone just tried to steal my car!"), 2)

			SetVehicleCanBeUsedByFleeingPeds(veh, true)
			SetPedFleeAttributes(pedd, 0, true)
			return
		end
		return

	end

	if lucky then
		SetVehicleDoorsLocked(veh, 1)
		TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
		Citizen.Wait(2500)
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

	if not IsVehicleEngineOn(veh) then
		SetVehicleEngineOn(veh, false, true, true)
	end
	SetVehicleNeedsToBeHotwired(veh, false)
	SetVehicleDoorsLocked(veh, 1)

end)

RegisterNetEvent("nfw:lock_doors_for_everyone_response")
AddEventHandler("nfw:lock_doors_for_everyone_response", function(network_veh)

	local veh = NetworkGetEntityFromNetworkId(network_veh)
	local pedd = GetPedInVehicleSeat(veh, -1)

	if pedd ~= 0 then
		SetVehicleDoorsLocked(veh, 2)
	else
		SetVehicleDoorsLocked(veh, 7)
		SetVehicleEngineOn(veh, false, true, true)
	end

	SetVehicleNeedsToBeHotwired(veh, false)

end)

exports["em_context"]:register_always_checked_context("nfw:hotwiring", function()

	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	if veh == 0 then
		return
	end

	if exports["em_vehicles"]:has_keys(veh) then
		return
	end

	if IsVehicleEngineOn(veh) then
		return
	end

	return {

		dialog = "[Hotwire]",
		callback = function()

			exports["em_dialog"]:hide_dialog()

			if exports["em_items"]:has_item_by_name("toolkit") or exports["em_items"]:has_item_by_name("screwdriver") or exports["em_items"]:has_item_by_name("crowbar") then
				hotWire(GetVehiclePedIsIn(PlayerPedId(), false))
			else
				exports['t-notify']:Alert({style = "error", message = "Missing items. You need a toolkit, screwdriver or crowbar to hotwire a car", duration = 5000})
			end

		end

	}

end)