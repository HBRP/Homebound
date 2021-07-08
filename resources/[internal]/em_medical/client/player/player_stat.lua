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
        if not is_player_unconscious() --[[and PLAYER.SHORTERM_EFFECTS["Starved"] == nil]] then
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
        if PLAYER.SHORTERM_EFFECTS["Dehydrated"] == nil and not is_player_unconscious() then
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