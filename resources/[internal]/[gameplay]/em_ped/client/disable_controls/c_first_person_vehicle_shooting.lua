

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(5)
        if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
            if GetFollowPedCamViewMode() ~= 4 then
                DisableControlAction(0, 24, true)
                --DisableControlAction(0, 25, true)
                DisableControlAction(0, 63, true)
                DisableControlAction(0, 64, true)
                --DisableControlAction(0, 68, true)
                DisableControlAction(0, 69, true)
                DisableControlAction(0, 70, true)
            end
        else
            Citizen.Wait(1000)
        end
    end

end)