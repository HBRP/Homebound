

local function disable_pistol_whipping_loop()
    while true do
        Citizen.Wait(5)
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
        else
            Citizen.Wait(25)
        end
    end
end

Citizen.CreateThread(disable_pistol_whipping_loop)