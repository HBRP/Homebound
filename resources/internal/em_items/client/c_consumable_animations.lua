
local IsAnimated = false

function eat(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_cs_burger_01'
        IsAnimated = true
        local ped = PlayerPedId()
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

function drink(prop_name)
    Citizen.Trace("Here\n")
    if not IsAnimated then
        prop_name = prop_name or 'prop_ld_flow_bottle'
        IsAnimated = true

        local ped = PlayerPedId()
        Citizen.CreateThread(function()
            local x,y,z = table.unpack(GetEntityCoords(ped))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(ped, 18905)
            AttachEntityToEntity(prop, ped, boneIndex, 0.12, 0.028, 0.001, -50.0, 180.0, 45.0, true, true, false, true, 1, true)

            TaskPlayAnim(ped, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

            Citizen.Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(ped)
            DeleteObject(prop)
        end)
    end
end

function donut(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_donut_02'
        IsAnimated = true

        local ped = PlayerPedId()
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

function apply_armour_anim()

    if not IsAnimated then

        IsAnimated = true

        exports["rprogress"]:Custom({
            Async    = false,
            Duration = 5000,
            Label = "Putting on armour"
        })
        
        IsAnimated = false

    end

end