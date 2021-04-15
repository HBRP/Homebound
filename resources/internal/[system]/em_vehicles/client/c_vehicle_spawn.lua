--[[
    MIT License

    Copyright (c) 2017 ImagicTheCat

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]


function spawn_vehicle(model, plate, state, position, heading, rotation, place_ped_inside)

    -- load vehicle model
    local mhash = GetHashKey(model)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
        RequestModel(mhash)
        Citizen.Wait(10)
        i = i + 1
    end

    -- spawn car
    if HasModelLoaded(mhash) then

        local ped = GetPlayerPed(-1)
        local x, y, z = table.unpack(position)

        local nveh = CreateVehicle(mhash, x, y, z + 0.5, 0.0, true, false)
        if position and rotation then
            SetEntityQuaternion(nveh, table.unpack(rotation))
        end

        if not heading and not position then -- set vehicle heading same as player
            SetEntityHeading(nveh, GetEntityHeading(ped))
        end

        if heading then
            SetEntityHeading(nveh, heading)
        end

        SetVehicleOnGroundProperly(nveh)
        SetEntityInvincible(nveh,false)
        if place_ped_inside then
            SetPedIntoVehicle(ped, nveh, -1) -- put player inside
        end

        if plate then
            SetVehicleNumberPlateText(nveh, plate)
        end
        SetEntityAsMissionEntity(nveh, true, true)
        SetVehicleHasBeenOwnedByPlayer(nveh,true)


        SetModelAsNoLongerNeeded(mhash)

        if state then
            set_vehicle_state(nveh, state)
        end
        SetVehicleDoorsLocked(nveh, 10)
        register_vehicle_as_player_owned(nveh)

        return nveh

    end
end

-- return true if despawned
function despawn_vehicle(model)

    if veh then

        -- remove vehicle
        SetVehicleHasBeenOwnedByPlayer(veh,false)
        SetEntityAsMissionEntity(veh, false, true)
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

        return true
    end

end