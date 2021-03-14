
Citizen.CreateThread(function()
    
    while true do

        Citizen.Wait(5)

        if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
            DisplayRadar(false)
            Citizen.Wait(1000)
        else
            DisplayRadar(true)
            Citizen.Wait(1000)
        end

    end

end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        HideHudComponentThisFrame(1)  -- Wanted Stars
        HideHudComponentThisFrame(2)  -- Weapon Icon
        HideHudComponentThisFrame(3)  -- Cash
        HideHudComponentThisFrame(4)  -- MP Cash
        HideHudComponentThisFrame(6)  -- Vehicle Name
        HideHudComponentThisFrame(7)  -- Area Name
        HideHudComponentThisFrame(8)  -- Vehicle Class
        HideHudComponentThisFrame(9)  -- Street Name
        HideHudComponentThisFrame(13) -- Cash Change
        HideHudComponentThisFrame(17) -- Save Game
        HideHudComponentThisFrame(20) -- Weapon Stats
    end

end)