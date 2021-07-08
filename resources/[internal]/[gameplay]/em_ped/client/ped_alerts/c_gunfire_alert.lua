
Citizen.CreateThread(function()

    while true do

        Citizen.Wait(5)
        if IsPedShooting(PlayerPedId()) then
            if exports["em_items"]:does_weapon_hash_alert_cops(GetSelectedPedWeapon(PlayerPedId())) then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", '10-71', 'Gunfire', 2)
                Citizen.Wait(10000)
            end
        else
            Citizen.Wait(25)
        end

    end

end)