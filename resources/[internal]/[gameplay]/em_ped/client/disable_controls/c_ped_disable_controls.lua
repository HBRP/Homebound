

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

local unconscious = false
local function disable_controls_when_unconscious()

    while unconscious do

        Citizen.Wait(5)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 63, true)
        DisableControlAction(0, 64, true)
        DisableControlAction(0, 68, true)
        DisableControlAction(0, 69, true)
        DisableControlAction(0, 70, true)

    end

end

Citizen.CreateThread(disable_pistol_whipping_loop)

AddEventHandler("em_medical:is_unconscious", function()

    unconscious = true
    Citizen.CreateThread(disable_controls_when_unconscious)

end)

AddEventHandler("em_medical:is_conscious", function()

    unconscious = false

end)