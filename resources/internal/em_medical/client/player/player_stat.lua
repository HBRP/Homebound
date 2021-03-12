RequestAnimDict('mp_player_intdrink')
RequestAnimDict('mp_player_inteat@burger')

local STANDARD_DEPRECIATION    = 1/(2*3600)
local ACTIVE_DEPRECIATION      = 2 * STANDARD_DEPRECIATION
local VERY_ACTIVE_DEPRECIATION = 10 * ACTIVE_DEPRECIATION


function get_stat(name)

    assert(name ~= nil)
    local upper = name:upper()

    if upper == "HEALTH" then
        return 200
    elseif upper == "ARMOUR" then
        return PLAYER_STATS.LAST_ARMOUR
    end

    return PLAYER.MISC_LEVELS[upper]

end


function mod_stat(name, amount)

    assert(name ~= nil)
    local upper = name:upper()
    if PLAYER.MISC_LEVELS[upper] ~= nil then
        PLAYER.MISC_LEVELS[upper] = PLAYER.MISC_LEVELS[upper] + amount
    else
        Citizen.Trace("No stat by name of " .. name .. "\n")
    end

end

function get_stat_max(name)

    assert(name ~= nil)
    local upper = name:upper()

    if upper == "HEALTH" then
        return 200
    elseif upper == "ARMOUR" then
        return GetPlayerMaxArmour(PlayerId())
    end

    return PLAYER_MAX_LEVEL[upper]

end

function set_stat_max(name, amount)

end

function reset_stat_maxes()

    PLAYER.MISC_LEVELS.FOOD   = PLAYER_MAX_LEVEL.FOOD
    PLAYER.MISC_LEVELS.WATER  = PLAYER_MAX_LEVEL.WATER
    PLAYER.MISC_LEVELS.STRESS = PLAYER_MAX_LEVEL.STRESS

end

function reset_stat(to_current_maxes)

    PLAYER.MISC_LEVELS.FOOD   = PLAYER_MAX_LEVEL.FOOD
    PLAYER.MISC_LEVELS.WATER  = PLAYER_MAX_LEVEL.WATER
    PLAYER.MISC_LEVELS.STRESS = 0

end

function add_stat(name, amount)

    assert(name ~= nil)
    local upper = name:upper()
    if PLAYER.MISC_LEVELS[upper] == nil then
        Citizen.Trace("No stat by name of " .. name .. "\n")
        return
        
    end

    PLAYER.MISC_LEVELS[upper] = PLAYER.MISC_LEVELS[upper] + amount
    if PLAYER.MISC_LEVELS[upper] < 0 then
        PLAYER.MISC_LEVELS[upper] = 0
    end


    if PLAYER.MISC_LEVELS[upper] > PLAYER_MAX_LEVEL[upper] then
        PLAYER.MISC_LEVELS[upper] = PLAYER_MAX_LEVEL[upper]
    end

end

function food_loop()

    if PLAYER.MISC_LEVELS.FOOD > PLAYER_MAX_LEVEL.FOOD then
        PLAYER.MISC_LEVELS.FOOD = PLAYER_MAX_LEVEL.FOOD
    end

    if PLAYER.MISC_LEVELS.FOOD <= 0 then
        if not is_player_unconscious() then
            apply_short_term_effect(EFFECTS.STARVED)
        end
    else
        if IsPedInAnyVehicle(ped, false) then
            PLAYER.MISC_LEVELS.FOOD = PLAYER.MISC_LEVELS.FOOD - STANDARD_DEPRECIATION
        else
            if IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped) then
                PLAYER.MISC_LEVELS.FOOD = PLAYER.MISC_LEVELS.FOOD - ACTIVE_DEPRECIATION -- ~30 Mins of swimming
            elseif IsPedRunning(ped) or IsPedSprinting(ped) then
                PLAYER.MISC_LEVELS.FOOD = PLAYER.MISC_LEVELS.FOOD - VERY_ACTIVE_DEPRECIATION -- ~30 Mins of running
            elseif IsPedWalking(ped) then
                PLAYER.MISC_LEVELS.FOOD = PLAYER.MISC_LEVELS.FOOD - ACTIVE_DEPRECIATION -- ~1 Hour of walking
            else
                PLAYER.MISC_LEVELS.FOOD = PLAYER.MISC_LEVELS.FOOD - STANDARD_DEPRECIATION -- ~2 Hours standing still
            end
        end
    end

end

function water_loop()

    if PLAYER.MISC_LEVELS.WATER > PLAYER_MAX_LEVEL.WATER then
        PLAYER.MISC_LEVELS.WATER = PLAYER_MAX_LEVEL.WATER
    end

    if PLAYER.MISC_LEVELS.WATER <= 0 then
        if not is_player_unconscious() then
            apply_short_term_effect(EFFECTS.DEHYDRATED)
        end
    else
        if IsPedInAnyVehicle(ped, false) then
            PLAYER.MISC_LEVELS.WATER = PLAYER.MISC_LEVELS.WATER - STANDARD_DEPRECIATION
        else
            if IsPedRunning(ped) or IsPedSprinting(ped) then
                PLAYER.MISC_LEVELS.WATER = PLAYER.MISC_LEVELS.WATER - 100 * VERY_ACTIVE_DEPRECIATION  -- ~30 Mins of running
            elseif IsPedWalking(ped) then
                PLAYER.MISC_LEVELS.WATER = PLAYER.MISC_LEVELS.WATER - ACTIVE_DEPRECIATION -- ~1 Hour of walking
            else
                PLAYER.MISC_LEVELS.WATER = PLAYER.MISC_LEVELS.WATER - STANDARD_DEPRECIATION -- ~2 Hours of standing still
            end
        end
    end

end


function on_eat(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(ped, 18905)
			AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            TaskPlayAnim(ped, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

            Citizen.Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(ped)
            DeleteObject(prop)
		end)
	end
end

function on_drink(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(ped, 18905)
			AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            TaskPlayAnim(ped, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

            Citizen.Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(ped)
            DeleteObject(prop)
		end)
    end
end

function on_donut(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_donut_02'
		IsAnimated = true
		Citizen.CreateThread(function()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(ped, 18905)
			AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
            TaskPlayAnim(ped, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(ped)
            DeleteObject(prop)
		end)
	end
end