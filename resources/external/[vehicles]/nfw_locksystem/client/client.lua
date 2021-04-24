local PlayerData = {}
pBreaking = false
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

local vehicle
function disableEngine()
	Citizen.CreateThread(function()
		while hotwiring do
			SetVehicleEngineOn(vehicle, false, true, false)
			if not hotwiring then
				break
			end
			Citizen.Wait(0)
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

RegisterNetEvent('nfwlock:onUse')
AddEventHandler('nfwlock:onUse', function()
	local playerPed		= GetPlayerPed(-1)
  local coords		= GetEntityCoords(playerPed)
    

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = nil
    pBreaking = true

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if GetVehicleDoorLockStatus(vehicle) == 1 then
      exports['mythic_notify']:DoHudText('inform', 'Vehicle door is not locked.')
      pBreaking = false
      return
    end

		if DoesEntityExist(vehicle) then
			TriggerServerEvent('nfwlock:removeKit')
		end

    Citizen.Wait(1000)

	  RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
      Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.CreateThread(function()
      exports['progressBars']:startUI(30000, "Lockpicking...")

      Citizen.Wait(30000)
      alarmChance = math.random(100)
      if alarmChance <= cfg.alarmPercent then
        local pPed = GetPlayerPed(-1)
        local pPos = GetEntityCoords(pPed)
        local sPlates = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('Grand Theft Auto in progress. Plates: ' .. sPlates), pPos, {

          PlayerCoords = { x = pPos.x, y = pPos.y, z = pPos.z },
        })
        Citizen.Wait(2000)
        SetVehicleAlarm(vehicle, true)
		    SetVehicleAlarmTimeLeft(vehicle, 30 * 1000)
		    SetVehicleDoorsLocked(vehicle, 1)
		    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
      else
        SetVehicleDoorsLocked(vehicle, 1)
		    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
      end
    end)			
  end
end)	

function hotWire(vehicle)
  if IsVehicleNeedsToBeHotwired(vehicle) then
    disableEngine()
    hotwiring = true
    pBreaking = false
    loadAnimDict(animDict)
    ClearPedTasks(player_entity)
    TaskPlayAnim(player_entity, animDict, anim, 3.0, 1.0, 2000, flags, -1, 0, 0, 0)
    if hotwiring then
      exports['progressBars']:startUI(Time, "Hotwiring Vehicle...")
      Citizen.Wait(Time+500)
    end
    hotwiring = false
    StopAnimTask(player_entity, animDict, anim, 1.0)
    Citizen.Wait(1000)
    TriggerEvent('EngineToggle:Engine')
    SetVehicleJetEngineOn(vehicle, true)
    RemoveAnimDict(animDict)
    if not Radio then
      SetVehicleRadioEnabled(vehicle, false)
    end
  end
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
        exports['mythic_notify']:DoHudText('success', 'Engine turned on!')
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
	local plate = GetVehicleNumberPlateText(veh)
	if lucky then
		print("lucky")
		TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
	else
		print("not lucky")
		TriggerServerEvent("nfw:lock_doors_for_everyone", NetworkGetNetworkIdFromEntity(veh), plate)
	end
end

RegisterCommand('getting_in_car', check_for_car, false)
RegisterKeyMapping('getting_in_car', 'getting_in_car', 'keyboard', 'F')

RegisterNetEvent('nfwlock:setVehicleDoors')
AddEventHandler('nfwlock:setVehicleDoors', function(veh, doors)
  SetVehicleDoorsLocked(veh, doors)
  SetVehicleNeedsToBeHotwired(veh, false)
end)

RegisterNetEvent("nfw:unlock_doors_for_everyone_response")
AddEventHandler("nfw:unlock_doors_for_everyone_response", function(network_veh)

	local veh = NetworkGetEntityFromNetworkId(network_veh)
	SetVehicleDoorsLocked(veh, 1)

end)

RegisterNetEvent("nfw:lock_doors_for_everyone_response")
AddEventHandler("nfw:lock_doors_for_everyone_response", function(network_veh)

	print("locking doors")
	local veh = NetworkGetEntityFromNetworkId(network_veh)
	SetVehicleDoorsLocked(veh, 2)

end)


exports["em_items"]:register_item_use("lockpick", function()

	local hit, coords, entity = table.unpack(exports["em_fw"]:ray_cast_game_play_camera(10.0))

	if not hit then
		return
		--exports['t-notify']:Alert({style="error", message = "No vehicle nearby"})
	end

	if entity ~= 0 and GetEntityType(entity) ~=2 then
		return
		--exports['t-notify']:Alert({style="error", message = "Not looking at a vehicle"})
	end

  exports["rprogress"]:Custom({
      Async    = true,
      Duration = 1000 * 10,
      Label    = "Lockpicking vehicle"
  })

  exports["em_animations"]:play_animation_sync('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 10000, 16)
  TriggerServerEvent("nfw:unlock_doors_for_everyone", NetworkGetNetworkIdFromEntity(entity), GetVehicleNumberPlateText(entity), true)

end)