
local session_id = nil

Citizen.CreateThread(function()

    Citizen.Wait(0)
    SetNuiFocus(true, true)
    Citizen.Wait(0)
    SetNuiFocus(false, false)

end)

RegisterNUICallback("set_session_id", function(data, cb)

    session_id = data["session_id"]
    SetNuiFocus(false, false)
    TriggerServerEvent("GetPlayerInfo", data)

end)