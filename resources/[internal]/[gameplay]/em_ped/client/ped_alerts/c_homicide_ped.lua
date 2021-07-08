
local function check_to_send_battery_alert()

    if exports["em_items"]:is_character_holding_a_weapon() then
        TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", 'Aggravated Battery', 'Someone is using a weapon against locals!', 2)
    else
        TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", 'Battery', 'Local has been punched!', 2)
    end

end

local function check_to_send_homicide_alert()

    local ret, entity = GetEntityPlayerIsFreeAimingAt(PlayerId()) -- GetPlayerTargetEntity(PlayerId())
    if entity == 0 or is_ped_an_animal(entity) then
        return
    end

    local character_seen = does_any_ped_see_me()

    if IsEntityDead(entity) and character_seen then

        TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", 'Corpse Mutilation', 'Potential corpse mutilation', 1)
        
    else

        check_to_send_battery_alert()
        Citizen.CreateThread(function()

            Citizen.Wait(1000*5)
            if IsEntityDead(entity) and character_seen then
                TriggerEvent("em_group_alerts:send_dispatch", "Law Enforcement", 'Homicide', 'Local is incapacitated', 1)
            end

        end)

    end
    Citizen.Wait(1000*5)

end

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(5)
        if IsPedShooting(PlayerPedId()) or IsPedPerformingMeleeAction(PlayerPedId()) then
            check_to_send_homicide_alert()
        else
            Citizen.Wait(25)
        end

    end

end)