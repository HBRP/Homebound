



-- VEHICLE STATE

function get_vehicle_mods(veh)
    local custom = {}

    custom.colours = {GetVehicleColours(veh)}
    custom.extra_colours = {GetVehicleExtraColours(veh)}
    custom.plate_index = GetVehicleNumberPlateTextIndex(veh)
    custom.wheel_type = GetVehicleWheelType(veh)
    custom.window_tint = GetVehicleWindowTint(veh)
    custom.livery = GetVehicleLivery(veh)
    custom.neons = {}
    for i=0,3 do
        custom.neons[i] = IsVehicleNeonLightEnabled(veh, i)
    end
    custom.neon_colour = {GetVehicleNeonLightsColour(veh)}
    custom.tyre_smoke_color = {GetVehicleTyreSmokeColor(veh)}

    custom.mods = {}
    for i=0,49 do
        custom.mods[i] = GetVehicleMod(veh, i)
    end

    custom.turbo_enabled = IsToggleModOn(veh, 18)
    custom.smoke_enabled = IsToggleModOn(veh, 20)
    custom.xenon_enabled = IsToggleModOn(veh, 22)

    return custom
end

-- partial update per property
function set_vehicle_mods(veh, custom)

    SetVehicleModKit(veh, 0)

    if custom.colours then
        SetVehicleColours(veh, table.unpack(custom.colours))
    end

    if custom.extra_colours then
        SetVehicleExtraColours(veh, table.unpack(custom.extra_colours))
    end

    if custom.plate_index then 
        SetVehicleNumberPlateTextIndex(veh, custom.plate_index)
    end

    if custom.wheel_type then
        SetVehicleWheelType(veh, custom.wheel_type)
    end

    if custom.window_tint then
        SetVehicleWindowTint(veh, custom.window_tint)
    end

    if custom.livery then
        SetVehicleLivery(veh, custom.livery)
    end

    if custom.neons then
        for i = 0, 3 do
            SetVehicleNeonLightEnabled(veh, i, custom.neons[i])
        end
    end

    if custom.neon_colour then
        SetVehicleNeonLightsColour(veh, table.unpack(custom.neon_colour))
    end

    if custom.tyre_smoke_color then
        SetVehicleTyreSmokeColor(veh, table.unpack(custom.tyre_smoke_color))
    end

    if custom.mods then
        for i, mod in pairs(custom.mods) do
            SetVehicleMod(veh, i, mod, false)
        end
    end

    if custom.turbo_enabled ~= nil then
        ToggleVehicleMod(veh, 18, custom.turbo_enabled)
    end

    if custom.smoke_enabled ~= nil then
        ToggleVehicleMod(veh, 20, custom.smoke_enabled)
    end

    if custom.xenon_enabled ~= nil then
        ToggleVehicleMod(veh, 22, custom.xenon_enabled)
    end
end

function get_vehicle_state(veh)

    local state = {
    customization = get_vehicle_mods(veh),
    condition = {
        health = GetEntityHealth(veh),
        engine_health = GetVehicleEngineHealth(veh),
        petrol_tank_health = GetVehiclePetrolTankHealth(veh),
        dirt_level = GetVehicleDirtLevel(veh)
        }
    }

    state.condition.windows = {}
    for i = 0 , 7 do 
        state.condition.windows[i] = IsVehicleWindowIntact(veh, i)
    end

    state.condition.tyres = {}
    for i = 0, 7 do
        local tyre_state = 2 -- 2: fine, 1: burst, 0: completely burst
        if IsVehicleTyreBurst(veh, i, true) then
            tyre_state = 0
        elseif IsVehicleTyreBurst(veh, i, false) then
            tyre_state = 1
        end

        state.condition.tyres[i] = tyre_state
    end

    state.condition.doors = {}
    for i = 0, 5 do
        state.condition.doors[i] = not IsVehicleDoorDamaged(veh, i)
    end

    state.locked = (GetVehicleDoorLockStatus(veh) >= 2)

    return state
end

-- partial update per property
function set_vehicle_state(veh, state)

    if state.condition then
        if state.condition.health then
            SetEntityHealth(veh, state.condition.health)
        end

        if state.condition.engine_health then
            SetVehicleEngineHealth(veh, state.condition.engine_health)
        end

        if state.condition.petrol_tank_health then
            SetVehiclePetrolTankHealth(veh, state.condition.petrol_tank_health)
        end

        if state.condition.dirt_level then
            SetVehicleDirtLevel(veh, state.condition.dirt_level)
        end

        if state.condition.windows then
            for i, window_state in pairs(state.condition.windows) do
                if not window_state then
                    SmashVehicleWindow(veh, i)
                end
            end
        end

        if state.condition.tyres then
            for i, tyre_state in pairs(state.condition.tyres) do
                if tyre_state < 2 then
                    SetVehicleTyreBurst(veh, i, (tyre_state == 1), 1000.01)
                end
            end
        end

        if state.condition.doors then
            for i, door_state in pairs(state.condition.doors) do
                if not door_state then
                    SetVehicleDoorBroken(veh, i, true)
                end
            end
        end
    end

    if state.locked ~= nil then 
        if state.locked then -- lock
            SetVehicleDoorsLocked(veh,2)
            SetVehicleDoorsLockedForAllPlayers(veh, true)
        else -- unlock
            SetVehicleDoorsLockedForAllPlayers(veh, false)
            SetVehicleDoorsLocked(veh,1)
            SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
        end
    end
end