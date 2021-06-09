local robbedRecently = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
        if aiming and not IsPedAPlayer(targetPed) then

            local playerPed = GetPlayerPed(-1)
            local pCoords   = GetEntityCoords(playerPed, true)
            local tCoords   = GetEntityCoords(targetPed, true)

            if #(pCoords - tCoords) > Config.RobDistance * 2 then
                goto continue
            end

            if GetVehiclePedIsIn(targetPed, false) == 0 then
                TaskSetBlockingOfNonTemporaryEvents(targetPed)
            end
            
            if IsControlJustPressed(0, 38) then

                if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
                    if robbedRecently then
                        exports['t-notify']:Alert({style = 'error', message = 'Cannot rob another person yet'})
                    elseif IsPedDeadOrDying(targetPed, true) then
                        exports['t-notify']:Alert({style = 'error', message = 'Target dead'})
                    elseif GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) >= Config.RobDistance then
                        exports['t-notify']:Alert({style = 'error', message = 'Target too far away'})
                    else
                        robNpc(targetPed)
                    end
                end
            end
        else
            Citizen.Wait(100)
        end
        ::continue::
    end
end)

function robNpc(targetPed)
    robbedRecently = true

    Citizen.CreateThread(function()
        local dict = 'random@mugging3'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(10)
        end

        TaskStandStill(targetPed, Config.RobAnimationSeconds * 1000)
        FreezeEntityPosition(targetPed, true)
        TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)

        exports["rprogress"]:Custom({
            Async    = false,
            Duration = Config.RobAnimationSeconds * 1000,
            Label = "Robbing"
        })
        TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", "10-31b", "Local was robbed", 2)

        local amount = math.random(Config.MinMoney, Config.MaxMoney)
        exports["em_dal"]:give_item(exports["em_dal"]:get_character_storage_id(), exports["em_items"]:get_item_id_from_name("cash"), amount , -1, -1)
        FreezeEntityPosition(targetPed, false)
        exports['t-notify']:Alert({style = 'success', message = string.format("Stole $%d", amount)})

        if Config.ShouldWaitBetweenRobbing then
            Citizen.Wait(math.random(Config.MinWaitSeconds, Config.MaxWaitSeconds) * 1000)
            exports['t-notify']:Alert({style = 'info', message = "Can rob again"})
        end
        ClearPedTasksImmediately(targetPed)

        robbedRecently = false
    end)
end
