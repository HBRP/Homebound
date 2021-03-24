local robbedRecently = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
        if aiming then
            TaskSetBlockingOfNonTemporaryEvents(targetPed)
            if IsControlJustPressed(0, 38) then
                local playerPed = GetPlayerPed(-1)
                local pCoords = GetEntityCoords(playerPed, true)
                local tCoords = GetEntityCoords(targetPed, true)

                if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
                    if robbedRecently then
                        exports['swt_notifications']:Negative("Rob Npc", 'Cannot rob another person yet', "top", 2000, true)
                    elseif IsPedDeadOrDying(targetPed, true) then
                        exports['swt_notifications']:Negative("Rob Npc", 'Target dead', "top", 2000, true)
                    elseif GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) >= Config.RobDistance then
                        exports['swt_notifications']:Negative("Rob Npc", 'Target too far away', "top", 2000, true)
                    else
                        robNpc(targetPed)
                    end
                end
            end
        end

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
        exports['swt_notifications']:Info("Rob Npc", 'Robbery started', "top", 2000, true)

        exports["rprogress"]:Custom({
            Async    = false,
            Duration = Config.RobAnimationSeconds * 1000,
            Label = "Robbing"
        })

        exports["em_fw"]:give_item(exports["em_fw"]:get_character_storage_id(), exports["em_items"]:get_item_id_from_name("cash"), math.random(Config.MinMoney, Config.MaxMoney), -1, -1)
        FreezeEntityPosition(targetPed, false)
        exports['swt_notifications']:Success("Rob Npc", 'Robbery complete', "top", 2000, true)

        if Config.ShouldWaitBetweenRobbing then
            Citizen.Wait(math.random(Config.MinWaitSeconds, Config.MaxWaitSeconds) * 1000)
            exports['swt_notifications']:Info("Rob Npc", 'Can rob again', "top", 2000, true)
        end
        ClearPedTasksImmediately(targetPed)

        robbedRecently = false
    end)
end
