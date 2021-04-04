
Citizen.CreateThread(function()

    while true do

        Citizen.Wait(5)
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            if exports["em_items"]:does_weapon_hash_alert_cops(GetSelectedPedWeapon(ped)) then
                send_dispatch("Law Enforcement", '10-71', 'Gunfire', 2)
                Citizen.Wait(10000)
            end
        else
            Citizen.Wait(25)
        end

    end

end)