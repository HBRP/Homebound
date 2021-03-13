local function prevent_weapon_drops()

    local handle, ped = FindFirstPed()
    local finished = false

    repeat
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
    
end

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1000)
        prevent_weapon_drops()
    end

end)